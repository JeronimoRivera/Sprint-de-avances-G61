import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Space {
  const Space({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    required this.features,
  });

  final String id;
  final String name;
  final String location;
  final int capacity;
  final List<String> features;

  factory Space.fromJson(Map<String, dynamic> json) => Space(
        id: json['id'] as String,
        name: json['nombre'] as String,
        location: json['ubicacion'] as String,
        capacity: (json['capacidad'] as num).toInt(),
        features: List<String>.from(json['caracteristicas'] as List),
      );

  factory Space.fromCache(Map<String, Object?> row) => Space(
        id: row['id']! as String,
        name: row['name']! as String,
        location: row['location']! as String,
        capacity: row['capacity']! as int,
        features: List<String>.from(
          jsonDecode(row['features_json']! as String) as List,
        ),
      );

  Map<String, Object?> toCache() => {
        'id': id,
        'name': name,
        'location': location,
        'capacity': capacity,
        'features': features,
      };
}

class Reservation {
  const Reservation({
    required this.id,
    required this.userId,
    required this.spaceId,
    required this.spaceName,
    required this.capacity,
    required this.date,
    required this.hour,
    required this.attendees,
    required this.reason,
    required this.status,
    required this.syncStatus,
    required this.createdAt,
    this.conflictReason,
    this.rejectReason,
    this.checkIn,
    this.checkOut,
  });

  final String id;
  final String userId;
  final String spaceId;
  final String spaceName;
  final int capacity;
  final String date;
  final int hour;
  final int attendees;
  final String reason;
  final String status;
  final String syncStatus;
  final DateTime createdAt;
  final String? conflictReason;
  final String? rejectReason;
  final DateTime? checkIn;
  final DateTime? checkOut;

  DateTime get startsAt => DateTime(
        int.parse(date.substring(0, 4)),
        int.parse(date.substring(5, 7)),
        int.parse(date.substring(8, 10)),
        hour,
      );

  String get slotId =>
      '${spaceId}_${date.replaceAll('-', '')}_${hour.toString().padLeft(2, '0')}';

  Map<String, dynamic> toFirestore() => {
        'id': id,
        'userId': userId,
        'spaceId': spaceId,
        'slotId': slotId,
        'spaceName': spaceName,
        'capacity': capacity,
        'date': date,
        'hour': hour,
        'startAt': Timestamp.fromDate(startsAt),
        'attendees': attendees,
        'reason': reason,
        'status': status,
        'rejectReason': rejectReason,
        'checkIn': checkIn,
        'checkOut': checkOut,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  Map<String, Object?> toLocal() => {
        'id': id,
        'userId': userId,
        'spaceId': spaceId,
        'spaceName': spaceName,
        'capacity': capacity,
        'date': date,
        'hour': hour,
        'attendees': attendees,
        'reason': reason,
        'status': status,
        'syncStatus': syncStatus,
        'conflictReason': conflictReason,
        'rejectReason': rejectReason,
        'checkIn': checkIn?.millisecondsSinceEpoch,
        'checkOut': checkOut?.millisecondsSinceEpoch,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  factory Reservation.fromFirestore(
    Map<String, dynamic> data, {
    String syncStatus = 'sincronizada',
  }) {
    DateTime? dateFrom(Object? value) {
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      return null;
    }

    return Reservation(
      id: data['id'] as String,
      userId: data['userId'] as String,
      spaceId: data['spaceId'] as String,
      spaceName: data['spaceName'] as String,
      capacity: (data['capacity'] as num).toInt(),
      date: data['date'] as String,
      hour: (data['hour'] as num).toInt(),
      attendees: (data['attendees'] as num).toInt(),
      reason: data['reason'] as String,
      status: data['status'] as String,
      syncStatus: syncStatus,
      createdAt: dateFrom(data['createdAt']) ?? DateTime.now(),
      rejectReason: data['rejectReason'] as String?,
      checkIn: dateFrom(data['checkIn']),
      checkOut: dateFrom(data['checkOut']),
    );
  }

  factory Reservation.fromLocal(Map<String, Object?> row) => Reservation(
        id: row['id']! as String,
        userId: row['user_id']! as String,
        spaceId: row['space_id']! as String,
        spaceName: row['space_name']! as String,
        capacity: row['capacity']! as int,
        date: row['date']! as String,
        hour: row['hour']! as int,
        attendees: row['attendees']! as int,
        reason: row['reason']! as String,
        status: row['status']! as String,
        syncStatus: row['sync_status']! as String,
        conflictReason: row['conflict_reason'] as String?,
        rejectReason: row['reject_reason'] as String?,
        checkIn: _dateFromEpoch(row['check_in']),
        checkOut: _dateFromEpoch(row['check_out']),
        createdAt: _dateFromEpoch(row['created_at']) ?? DateTime.now(),
      );
}

DateTime? _dateFromEpoch(Object? value) =>
    value is int ? DateTime.fromMillisecondsSinceEpoch(value) : null;
