import 'package:flutter/material.dart';

import 'models.dart';
import 'app_services.dart';
import 'business_rules.dart';
import 'error_messages.dart';

class MyReservationsScreen extends StatefulWidget {
  const MyReservationsScreen({
    required this.uid,
    required this.role,
    super.key,
  });

  final String uid;
  final String role;

  @override
  State<MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen> {
  List<Reservation> _reservations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    try {
      try {
        await reservationRepository.synchronize(widget.uid);
        await reservationRepository.refreshMine(widget.uid);
      } catch (error) {
        if (mounted) {
          _show('Actualización remota pendiente: ${errorMessage(error)}');
        }
      }
      final rows = await reservationRepository.localForUser(widget.uid);
      if (mounted) setState(() => _reservations = rows);
    } catch (error) {
      if (mounted) _show(errorMessage(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _cancel(Reservation reservation) async {
    try {
      await reservationRepository.cancel(
        reservation,
        widget.uid,
        widget.role,
      );
      await _refresh();
      if (mounted) _show('Reserva cancelada.');
    } catch (error) {
      if (mounted) _show(errorMessage(error));
    }
  }

  void _show(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && _reservations.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: _refresh,
      child: _reservations.isEmpty
          ? ListView(
              children: const [
                SizedBox(height: 120),
                Center(child: Text('Aún no tienes reservas.')),
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _reservations.length,
              itemBuilder: (context, index) {
                final reservation = _reservations[index];
                final canCancel = isValidReservationTransition(
                  reservation.status,
                  'CANCELADA',
                );
                return Card(
                  child: ListTile(
                    title: Text(reservation.spaceName),
                    subtitle: Text(
                      '${reservation.date} a las '
                      '${reservation.hour.toString().padLeft(2, '0')}:00\n'
                      '${reservation.status} · ${reservation.attendees} asistentes'
                      '${reservation.syncStatus == 'pendiente' ? ' · PENDIENTE DE SINCRONIZAR' : ''}'
                      '${reservation.syncStatus == 'conflicto' ? ' · CONFLICTO: ${reservation.conflictReason}' : ''}'
                      '${reservation.rejectReason == null ? '' : '\nMotivo de rechazo: ${reservation.rejectReason}'}',
                    ),
                    isThreeLine: true,
                    trailing: canCancel
                        ? IconButton(
                            tooltip: 'Cancelar',
                            icon: const Icon(Icons.cancel_outlined),
                            onPressed: () => _cancel(reservation),
                          )
                        : null,
                  ),
                );
              },
            ),
    );
  }
}
