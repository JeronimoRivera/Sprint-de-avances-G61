import 'package:flutter/material.dart';

import 'models.dart';
import 'app_services.dart';
import 'business_rules.dart';
import 'error_messages.dart';

class AccessScreen extends StatefulWidget {
  const AccessScreen({required this.role, super.key});

  final String role;

  @override
  State<AccessScreen> createState() => _AccessScreenState();
}

class _AccessScreenState extends State<AccessScreen> {
  List<Reservation> _reservations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final today = DateTime.now();
      final date = '${today.year.toString().padLeft(4, '0')}-'
          '${today.month.toString().padLeft(2, '0')}-'
          '${today.day.toString().padLeft(2, '0')}';
      final reservations = await reservationRepository.remoteAll();
      if (mounted) {
        setState(() {
          _reservations = reservations
              .where((reservation) =>
                  reservation.date == date &&
                  (reservation.status == 'CONFIRMADA' ||
                      reservation.status == 'EN_USO'))
              .toList()
            ..sort((a, b) => a.hour.compareTo(b.hour));
        });
      }
    } catch (error) {
      if (mounted) _show(errorMessage(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _run(Future<void> Function() action, String message) async {
    try {
      await action();
      await _load();
      if (mounted) _show(message);
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
      onRefresh: _load,
      child: _reservations.isEmpty
          ? ListView(
              children: const [
                SizedBox(height: 120),
                Center(child: Text('No hay reservas confirmadas para hoy.')),
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _reservations.length,
              itemBuilder: (context, index) {
                final reservation = _reservations[index];
                final start = reservation.startsAt;
                final now = DateTime.now();
                final inSlot = canCheckInReservation(start, now);
                final ended =
                    !now.isBefore(start.add(const Duration(hours: 1)));
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reservation.spaceName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '${reservation.hour.toString().padLeft(2, '0')}:00 · '
                          '${reservation.attendees} asistentes · ${reservation.status}',
                        ),
                        Text('Usuario: ${reservation.userId}'),
                        if (reservation.status == 'CONFIRMADA')
                          Wrap(
                            spacing: 8,
                            children: [
                              FilledButton.tonal(
                                onPressed: inSlot
                                    ? () => _run(
                                          () => reservationRepository.checkIn(
                                            reservation,
                                            actorRole: widget.role,
                                          ),
                                          'Ingreso registrado.',
                                        )
                                    : null,
                                child: const Text('Ingreso'),
                              ),
                              OutlinedButton(
                                onPressed: ended
                                    ? () => _run(
                                          () =>
                                              reservationRepository.markAbsent(
                                            reservation,
                                            actorRole: widget.role,
                                          ),
                                          'Ausencia registrada.',
                                        )
                                    : null,
                                child: const Text('Ausente'),
                              ),
                            ],
                          ),
                        if (reservation.status == 'EN_USO')
                          FilledButton(
                            onPressed: () => _run(
                              () => reservationRepository.checkOut(
                                reservation,
                                actorRole: widget.role,
                              ),
                              'Salida registrada.',
                            ),
                            child: const Text('Salida'),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
