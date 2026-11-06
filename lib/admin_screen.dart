import 'package:flutter/material.dart';

import 'business_rules.dart';
import 'models.dart';
import 'app_services.dart';
import 'error_messages.dart';

class AdminAgendaScreen extends StatefulWidget {
  const AdminAgendaScreen({
    required this.uid,
    required this.role,
    super.key,
  });

  final String uid;
  final String role;

  @override
  State<AdminAgendaScreen> createState() => _AdminAgendaScreenState();
}

class _AdminAgendaScreenState extends State<AdminAgendaScreen> {
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
      final all = await reservationRepository.remoteAll();
      if (mounted) {
        setState(() {
          _reservations = all
              .where((reservation) =>
                  reservation.status == 'SOLICITADA' ||
                  reservation.status == 'CONFIRMADA')
              .toList()
            ..sort((a, b) {
              final dateCompare = a.date.compareTo(b.date);
              return dateCompare != 0 ? dateCompare : a.hour.compareTo(b.hour);
            });
        });
      }
    } catch (error) {
      if (mounted) _show(errorMessage(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _confirm(Reservation reservation) async {
    try {
      await reservationRepository.confirm(
        reservation,
        actorUid: widget.uid,
        actorRole: widget.role,
      );
      await _load();
      if (mounted) _show('Reserva confirmada.');
    } catch (error) {
      if (mounted) _show(errorMessage(error));
    }
  }

  Future<void> _reject(Reservation reservation) async {
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rechazar solicitud'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Motivo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Rechazar'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (reason == null) return;
    try {
      await reservationRepository.reject(
        reservation,
        reason,
        actorUid: widget.uid,
        actorRole: widget.role,
      );
      await _load();
      if (mounted) _show('Solicitud rechazada.');
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
                Center(child: Text('No hay solicitudes ni reservas activas.')),
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _reservations.length,
              itemBuilder: (context, index) {
                final reservation = _reservations[index];
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
                          '${reservation.date}, '
                          '${reservation.hour.toString().padLeft(2, '0')}:00 · '
                          '${reservation.attendees}/${reservation.capacity} asistentes',
                        ),
                        Text('Estado: ${reservation.status}'),
                        Text('Motivo: ${reservation.reason}'),
                        if (isValidReservationTransition(
                          reservation.status,
                          'CONFIRMADA',
                        ))
                          Wrap(
                            spacing: 8,
                            children: [
                              FilledButton.tonal(
                                onPressed: () => _confirm(reservation),
                                child: const Text('Confirmar'),
                              ),
                              OutlinedButton(
                                onPressed: () => _reject(reservation),
                                child: const Text('Rechazar'),
                              ),
                            ],
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

class SlotManagementScreen extends StatefulWidget {
  const SlotManagementScreen({required this.role, super.key});

  final String role;

  @override
  State<SlotManagementScreen> createState() => _SlotManagementScreenState();
}

class _SlotManagementScreenState extends State<SlotManagementScreen> {
  List<Space> _spaces = [];
  Space? _space;
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  int _hour = 7;
  String _status = 'libre';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSpaces();
  }

  Future<void> _loadSpaces() async {
    try {
      final result = await spaceRepository.load();
      if (!mounted) return;
      setState(() {
        _spaces = result.spaces;
        _space = _spaces.isEmpty ? null : _spaces.first;
        _loading = false;
      });
      if (result.warning != null) _show(result.warning!);
      await _loadStatus();
    } catch (error) {
      if (mounted) {
        setState(() => _loading = false);
        _show(errorMessage(error));
      }
    }
  }

  Future<void> _loadStatus() async {
    if (_space == null) return;
    try {
      final status = await reservationRepository.getSlotStatus(
        spaceId: _space!.id,
        date: _date,
        hour: _hour,
      );
      if (mounted) setState(() => _status = status);
    } catch (error) {
      if (mounted) _show(errorMessage(error));
    }
  }

  Future<void> _chooseDate() async {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final initialDate = _date.isBefore(tomorrow) ? tomorrow : _date;
    final value = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: tomorrow,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (value != null) {
      setState(() => _date = value);
      await _loadStatus();
    }
  }

  Future<void> _toggle() async {
    final wasBlocked = _status == 'bloqueada';
    try {
      await reservationRepository.setSlotBlocked(
        spaceId: _space!.id,
        date: _date,
        hour: _hour,
        blocked: !wasBlocked,
        actorRole: widget.role,
      );
      await _loadStatus();
      if (mounted) {
        _show(wasBlocked ? 'Franja desbloqueada.' : 'Franja bloqueada.');
      }
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
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_spaces.isEmpty) return const Center(child: Text('No hay espacios.'));
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        DropdownButtonFormField<Space>(
          initialValue: _space,
          decoration: const InputDecoration(labelText: 'Espacio'),
          items: _spaces
              .map((space) => DropdownMenuItem(
                    value: space,
                    child: Text(space.name),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() => _space = value);
            _loadStatus();
          },
        ),
        OutlinedButton(
          onPressed: _chooseDate,
          child: Text(
            '${_date.day.toString().padLeft(2, '0')}/'
            '${_date.month.toString().padLeft(2, '0')}/${_date.year}',
          ),
        ),
        DropdownButtonFormField<int>(
          initialValue: _hour,
          decoration: const InputDecoration(labelText: 'Franja'),
          items: [
            for (var hour = 7; hour < 20; hour++)
              DropdownMenuItem(
                value: hour,
                child: Text(
                  '${hour.toString().padLeft(2, '0')}:00 - '
                  '${(hour + 1).toString().padLeft(2, '0')}:00',
                ),
              ),
          ],
          onChanged: (value) {
            setState(() => _hour = value ?? _hour);
            _loadStatus();
          },
        ),
        const SizedBox(height: 16),
        Text('Estado actual: $_status'),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: _status == 'ocupada' ? null : _toggle,
          child: Text(_status == 'bloqueada'
              ? 'Desbloquear franja'
              : 'Bloquear franja'),
        ),
      ],
    );
  }
}
