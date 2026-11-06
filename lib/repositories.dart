import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'local_database.dart' hide Reservation, Space;
import 'models.dart';

const String baseUrl = 'https://TU_URL/spaces.json';
const String slotTakenMessage = 'La franja ya fue tomada';

class SpaceLoadResult {
  const SpaceLoadResult(this.spaces, {this.warning});

  final List<Space> spaces;
  final String? warning;
}

class SpaceRepository {
  SpaceRepository(this.database, {http.Client? client})
      : _client = client ?? http.Client();

  final LocalDatabase database;
  final http.Client _client;

  Future<SpaceLoadResult> load() async {
    try {
      final response = await _client
          .get(Uri.parse(baseUrl))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw StateError('El catálogo respondió ${response.statusCode}');
      }
      final decoded = jsonDecode(response.body) as List<dynamic>;
      final spaces = decoded
          .map((item) => Space.fromJson(item as Map<String, dynamic>))
          .toList();
      await database.cacheSpaces(spaces.map((s) => s.toCache()).toList());
      return SpaceLoadResult(spaces);
    } catch (error) {
      final cached = await database
          .customSelect('SELECT * FROM spaces ORDER BY name')
          .get();
      if (cached.isEmpty) {
        throw StateError(
            'No se pudo cargar el catálogo y no hay caché: $error');
      }
      return SpaceLoadResult(
        cached.map((row) => Space.fromCache(row.data)).toList(),
        warning: 'Sin conexión: se muestra el catálogo guardado. $error',
      );
    }
  }
}

class ReservationRepository {
  ReservationRepository(this.database, this.firestore);

  final LocalDatabase database;
  final FirebaseFirestore firestore;
  final Uuid _uuid = const Uuid();

  CollectionReference<Map<String, dynamic>> get _reservations =>
      firestore.collection('reservations');

  String slotId(String spaceId, String date, int hour) {
    final compactDate = date.replaceAll('-', '');
    return '${spaceId}_${compactDate}_${hour.toString().padLeft(2, '0')}';
  }

  Future<List<Reservation>> localForUser(String uid) async {
    final rows = await database.customSelect(
      'SELECT * FROM reservations WHERE user_id = ? ORDER BY date, hour',
      variables: [Variable<String>(uid)],
    ).get();
    return rows.map((row) => Reservation.fromLocal(row.data)).toList();
  }

  Future<String?> create({
    required String uid,
    required Space space,
    required DateTime date,
    required int hour,
    required int attendees,
    required String reason,
  }) async {
    _validateSlot(date, hour);
    if (attendees < 1 || attendees > space.capacity) {
      throw StateError(
          'Los asistentes deben estar entre 1 y ${space.capacity}.');
    }
    if (reason.trim().isEmpty) {
      throw StateError('Indica el motivo de la reserva.');
    }
    final reservation = Reservation(
      id: _uuid.v4(),
      userId: uid,
      spaceId: space.id,
      spaceName: space.name,
      capacity: space.capacity,
      date: _dateString(date),
      hour: hour,
      attendees: attendees,
      reason: reason.trim(),
      status: 'SOLICITADA',
      syncStatus: 'pendiente',
      createdAt: DateTime.now(),
    );
    await database.saveReservation(reservation.toLocal());
    try {
      await synchronize(uid);
      final saved = await database.customSelect(
        'SELECT sync_status, conflict_reason FROM reservations WHERE id = ?',
        variables: [Variable<String>(reservation.id)],
      ).getSingle();
      if (saved.read<String>('sync_status') == 'conflicto') {
        return saved.data['conflict_reason'] as String? ?? slotTakenMessage;
      }
      return 'Solicitud guardada y sincronizada.';
    } catch (error) {
      return 'Guardada en este dispositivo; se sincronizará al recuperar conexión. $error';
    }
  }

  Future<void> synchronize(String uid) async {
    final pending = await database.customSelect(
      "SELECT * FROM reservations WHERE user_id = ? AND sync_status = 'pendiente'",
      variables: [Variable<String>(uid)],
    ).get();
    for (final row in pending) {
      final local = Reservation.fromLocal(row.data);
      final reservationRef = _reservations.doc(local.id);
      if (local.status == 'CANCELADA') {
        final existing = await reservationRef.get();
        if (existing.exists) {
          final remote = Reservation.fromFirestore(existing.data()!);
          if (remote.status == 'SOLICITADA' || remote.status == 'CONFIRMADA') {
            try {
              await _cancelRemote(local, uid);
            } catch (error) {
              await database.saveReservation({
                ...local.toLocal(),
                'syncStatus': 'conflicto',
                'conflictReason': '$error',
              });
              continue;
            }
          } else {
            await database.saveReservation(remote.toLocal());
            continue;
          }
        }
        await database.saveReservation({
          ...local.toLocal(),
          'syncStatus': 'sincronizada',
          'conflictReason': null,
        });
        continue;
      }
      final slotRef = firestore.collection('slots').doc(
            slotId(local.spaceId, local.date, local.hour),
          );
      try {
        final remote = await firestore.runTransaction((transaction) async {
          final existing = await transaction.get(reservationRef);
          if (existing.exists) return existing.data()!;
          final slot = await transaction.get(slotRef);
          final slotStatus = slot.data()?['status'];
          if (slotStatus == 'ocupada' || slotStatus == 'bloqueada') {
            throw StateError(slotTakenMessage);
          }
          transaction.set(reservationRef, local.toFirestore());
          return local.toFirestore();
        });
        await database.saveReservation(
          Reservation.fromFirestore(remote).toLocal(),
        );
      } on StateError catch (error) {
        if (error.message != slotTakenMessage) rethrow;
        await database.saveReservation({
          ...local.toLocal(),
          'syncStatus': 'conflicto',
          'conflictReason': slotTakenMessage,
        });
      } on FirebaseException catch (error) {
        if (error.code == 'permission-denied') rethrow;
        throw StateError(_firebaseMessage(error));
      }
    }
  }

  Future<void> refreshMine(String uid) async {
    final snapshot = await _reservations.where('userId', isEqualTo: uid).get();
    for (final doc in snapshot.docs) {
      final remote = Reservation.fromFirestore(doc.data());
      await database.saveReservation(
        Reservation(
          id: remote.id,
          userId: remote.userId,
          spaceId: remote.spaceId,
          spaceName: remote.spaceName,
          capacity: remote.capacity,
          date: remote.date,
          hour: remote.hour,
          attendees: remote.attendees,
          reason: remote.reason,
          status: remote.status,
          syncStatus: 'sincronizada',
          createdAt: remote.createdAt,
          rejectReason: remote.rejectReason,
          checkIn: remote.checkIn,
          checkOut: remote.checkOut,
        ).toLocal(),
      );
    }
  }

  Future<List<Reservation>> remoteAll() async {
    final snapshot = await _reservations.get();
    return snapshot.docs
        .map((doc) => Reservation.fromFirestore(doc.data()))
        .toList();
  }

  Future<void> cancel(
    Reservation reservation,
    String uid,
    String actorRole,
  ) async {
    if (actorRole != 'usuario') {
      throw StateError('Solo un usuario puede cancelar reservas.');
    }
    if (reservation.userId != uid) {
      throw StateError('Solo el propietario puede cancelar la reserva.');
    }
    if (reservation.status != 'SOLICITADA' &&
        reservation.status != 'CONFIRMADA') {
      throw StateError('Esta reserva ya no se puede cancelar.');
    }
    if (DateTime.now().isAfter(
      reservation.startsAt.subtract(const Duration(hours: 1)),
    )) {
      throw StateError(
        'No se puede cancelar con menos de una hora de anticipación.',
      );
    }
    if (reservation.syncStatus != 'sincronizada') {
      final pending = reservation.syncStatus == 'pendiente';
      await database.saveReservation({
        ...reservation.toLocal(),
        'status': 'CANCELADA',
        'syncStatus': pending ? 'pendiente' : 'sincronizada',
        'conflictReason': null,
      });
      if (pending) await synchronize(uid);
      return;
    }
    await _cancelRemote(reservation, uid);
    await refreshMine(uid);
  }

  Future<void> _cancelRemote(Reservation reservation, String uid) async {
    final ref = _reservations.doc(reservation.id);
    final slotRef = firestore.collection('slots').doc(
          slotId(reservation.spaceId, reservation.date, reservation.hour),
        );
    await firestore.runTransaction((transaction) async {
      final doc = await transaction.get(ref);
      if (!doc.exists) throw StateError('La reserva no existe en el servidor.');
      final data = doc.data()!;
      if (data['userId'] != uid) {
        throw StateError('Solo el propietario puede cancelar la reserva.');
      }
      final status = data['status'] as String;
      if (status != 'SOLICITADA' && status != 'CONFIRMADA') {
        throw StateError('Esta reserva ya no se puede cancelar.');
      }
      final start = _startFrom(data);
      if (DateTime.now().isAfter(start.subtract(const Duration(hours: 1)))) {
        throw StateError(
          'No se puede cancelar con menos de una hora de anticipación.',
        );
      }
      DocumentSnapshot<Map<String, dynamic>>? slot;
      if (status == 'CONFIRMADA') slot = await transaction.get(slotRef);
      transaction.update(ref, {'status': 'CANCELADA'});
      if (slot != null && slot.data()?['reservationId'] == reservation.id) {
        transaction.update(slotRef, {
          'status': 'libre',
          'reservationId': null,
        });
      }
    });
  }

  Future<void> confirm(
    Reservation reservation, {
    required String actorUid,
    required String actorRole,
  }) async {
    if (actorRole != 'administrador') {
      throw StateError('Solo administración puede confirmar reservas.');
    }
    if (actorUid == reservation.userId) {
      throw StateError('No puedes confirmar tu propia reserva.');
    }
    if (reservation.attendees < 1 ||
        reservation.attendees > reservation.capacity) {
      throw StateError('La cantidad supera la capacidad del espacio.');
    }
    if (!reservation.startsAt.isAfter(DateTime.now())) {
      throw StateError('No se puede confirmar una franja que ya inició.');
    }
    final ref = _reservations.doc(reservation.id);
    final slotRef = firestore.collection('slots').doc(
          slotId(reservation.spaceId, reservation.date, reservation.hour),
        );
    await firestore.runTransaction((transaction) async {
      final doc = await transaction.get(ref);
      final slot = await transaction.get(slotRef);
      if (!doc.exists || doc.data()?['status'] != 'SOLICITADA') {
        throw StateError('La solicitud ya no está disponible para confirmar.');
      }
      final slotStatus = slot.data()?['status'];
      if (slotStatus == 'ocupada' || slotStatus == 'bloqueada') {
        throw StateError(slotTakenMessage);
      }
      transaction.update(ref, {'status': 'CONFIRMADA'});
      transaction.set(slotRef, {
        'spaceId': reservation.spaceId,
        'date': reservation.date,
        'hour': reservation.hour,
        'status': 'ocupada',
        'reservationId': reservation.id,
      });
    });
  }

  Future<void> reject(
    Reservation reservation,
    String reason, {
    required String actorUid,
    required String actorRole,
  }) async {
    if (actorRole != 'administrador') {
      throw StateError('Solo administración puede rechazar reservas.');
    }
    if (actorUid == reservation.userId) {
      throw StateError('No puedes rechazar tu propia reserva.');
    }
    if (reason.trim().isEmpty) {
      throw StateError('Escribe el motivo del rechazo.');
    }
    final ref = _reservations.doc(reservation.id);
    await firestore.runTransaction((transaction) async {
      final doc = await transaction.get(ref);
      if (!doc.exists || doc.data()?['status'] != 'SOLICITADA') {
        throw StateError('Solo se puede rechazar una solicitud pendiente.');
      }
      transaction.update(ref, {
        'status': 'RECHAZADA',
        'rejectReason': reason.trim(),
      });
    });
  }

  Future<void> setSlotBlocked({
    required String spaceId,
    required DateTime date,
    required int hour,
    required bool blocked,
    required String actorRole,
  }) async {
    if (actorRole != 'administrador') {
      throw StateError('Solo administración puede bloquear franjas.');
    }
    _validateSlot(date, hour);
    final ref = firestore.collection('slots').doc(
          slotId(spaceId, _dateString(date), hour),
        );
    await firestore.runTransaction((transaction) async {
      final slot = await transaction.get(ref);
      final status = slot.data()?['status'];
      if (blocked && status == 'ocupada') {
        throw StateError('No se puede bloquear una franja ocupada.');
      }
      if (!blocked && status != 'bloqueada') {
        throw StateError('La franja no está bloqueada.');
      }
      final values = <String, Object?>{
        'spaceId': spaceId,
        'date': _dateString(date),
        'hour': hour,
        'status': blocked ? 'bloqueada' : 'libre',
        'reservationId': null,
      };
      if (blocked) {
        transaction.set(ref, values, SetOptions(merge: true));
      } else {
        transaction.update(ref, values);
      }
    });
  }

  Future<String> getSlotStatus({
    required String spaceId,
    required DateTime date,
    required int hour,
  }) async {
    final slot = await firestore
        .collection('slots')
        .doc(slotId(spaceId, _dateString(date), hour))
        .get();
    return slot.data()?['status'] as String? ?? 'libre';
  }

  Future<void> checkIn(
    Reservation reservation, {
    required String actorRole,
  }) async {
    if (actorRole != 'acceso') {
      throw StateError('Solo el encargado de acceso puede registrar ingresos.');
    }
    final ref = _reservations.doc(reservation.id);
    await firestore.runTransaction((transaction) async {
      final doc = await transaction.get(ref);
      if (!doc.exists || doc.data()?['status'] != 'CONFIRMADA') {
        throw StateError(
            'Solo se admite el ingreso de una reserva confirmada.');
      }
      final start = _startFrom(doc.data()!);
      final now = DateTime.now();
      if (now.isBefore(start) ||
          !now.isBefore(start.add(const Duration(hours: 1)))) {
        throw StateError(
            'El ingreso solo se permite dentro de la franja reservada.');
      }
      transaction.update(ref, {
        'status': 'EN_USO',
        'checkIn': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> checkOut(
    Reservation reservation, {
    required String actorRole,
  }) async {
    if (actorRole != 'acceso') {
      throw StateError('Solo el encargado de acceso puede registrar salidas.');
    }
    final ref = _reservations.doc(reservation.id);
    await firestore.runTransaction((transaction) async {
      final doc = await transaction.get(ref);
      if (!doc.exists || doc.data()?['status'] != 'EN_USO') {
        throw StateError(
            'Solo se puede registrar salida de una reserva en uso.');
      }
      transaction.update(ref, {
        'status': 'FINALIZADA',
        'checkOut': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> markAbsent(
    Reservation reservation, {
    required String actorRole,
  }) async {
    if (actorRole != 'acceso') {
      throw StateError('Solo acceso puede marcar una ausencia.');
    }
    final ref = _reservations.doc(reservation.id);
    await firestore.runTransaction((transaction) async {
      final doc = await transaction.get(ref);
      if (!doc.exists || doc.data()?['status'] != 'CONFIRMADA') {
        throw StateError('Solo se puede marcar ausencia en una confirmada.');
      }
      if (DateTime.now()
          .isBefore(_startFrom(doc.data()!).add(const Duration(hours: 1)))) {
        throw StateError('La franja aún no termina.');
      }
      transaction.update(ref, {'status': 'AUSENTE'});
    });
  }

  void _validateSlot(DateTime date, int hour) {
    if (hour < 7 || hour > 19) {
      throw StateError('Las franjas disponibles van de 07:00 a 20:00.');
    }
    final now = DateTime.now();
    final day = DateTime(date.year, date.month, date.day);
    final today = DateTime(now.year, now.month, now.day);
    if (!day.isAfter(today)) {
      throw StateError('Selecciona una fecha futura.');
    }
  }

  String _dateString(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  DateTime _startFrom(Map<String, dynamic> data) {
    final date = data['date'] as String;
    return DateTime(
      int.parse(date.substring(0, 4)),
      int.parse(date.substring(5, 7)),
      int.parse(date.substring(8, 10)),
      (data['hour'] as num).toInt(),
    );
  }

  String _firebaseMessage(FirebaseException error) {
    if (error.code == 'permission-denied') {
      return 'No tienes permisos para realizar esta acción.';
    }
    if (error.code == 'unavailable' || error.code == 'network-request-failed') {
      return 'Sin conexión. El cambio queda pendiente de sincronización.';
    }
    return error.message ?? error.code;
  }
}
