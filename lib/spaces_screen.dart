import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';
import 'app_services.dart';

class SpacesScreen extends StatefulWidget {
  const SpacesScreen({required this.uid, super.key});

  final String uid;

  @override
  State<SpacesScreen> createState() => _SpacesScreenState();
}

class _SpacesScreenState extends State<SpacesScreen> {
  List<Space> _spaces = [];
  String? _selectedId;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await spaceRepository.load();
      final prefs = await SharedPreferences.getInstance();
      final savedId = prefs.getString('last_space_${widget.uid}');
      if (!mounted) return;
      setState(() {
        _spaces = result.spaces;
        _selectedId =
            result.spaces.any((space) => space.id == savedId) ? savedId : null;
        _loading = false;
      });
      if (result.warning != null) _show(result.warning!);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = '$error';
        _loading = false;
      });
      _show('$error');
    }
  }

  Future<void> _select(Space space) async {
    setState(() => _selectedId = space.id);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_space_${widget.uid}', space.id);
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SpaceDetailScreen(space: space, uid: widget.uid),
      ),
    );
  }

  void _show(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_spaces.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error ?? 'No hay espacios disponibles.'),
            TextButton(onPressed: _load, child: const Text('Reintentar')),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          for (final space in _spaces)
            Card(
              child: ListTile(
                selected: space.id == _selectedId,
                leading: const Icon(Icons.meeting_room),
                title: Text(space.name),
                subtitle: Text(
                  '${space.location}\nCapacidad: ${space.capacity}',
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _select(space),
              ),
            ),
        ],
      ),
    );
  }
}

class SpaceDetailScreen extends StatefulWidget {
  const SpaceDetailScreen({required this.space, required this.uid, super.key});

  final Space space;
  final String uid;

  @override
  State<SpaceDetailScreen> createState() => _SpaceDetailScreenState();
}

class _SpaceDetailScreenState extends State<SpaceDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _attendees = TextEditingController(text: '1');
  final _reason = TextEditingController();
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  int _hour = 7;
  bool _busy = false;

  @override
  void dispose() {
    _attendees.dispose();
    _reason.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final initialDate = _date.isBefore(tomorrow) ? tomorrow : _date;
    final selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: tomorrow,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selected != null) setState(() => _date = selected);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      final warning = await reservationRepository.create(
        uid: widget.uid,
        space: widget.space,
        date: _date,
        hour: _hour,
        attendees: int.parse(_attendees.text),
        reason: _reason.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(warning ?? 'Solicitud guardada y sincronizada.'),
        ),
      );
      Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$error')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.space.name)),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(widget.space.location),
            Text('Capacidad máxima: ${widget.space.capacity}'),
            Text('Características: ${widget.space.features.join(', ')}'),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_month),
                    label: Text(
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
                    onChanged: (value) =>
                        setState(() => _hour = value ?? _hour),
                  ),
                  TextFormField(
                    controller: _attendees,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Asistentes'),
                    validator: (value) {
                      final count = int.tryParse(value ?? '');
                      if (count == null ||
                          count < 1 ||
                          count > widget.space.capacity) {
                        return 'Indica entre 1 y ${widget.space.capacity}.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _reason,
                    decoration: const InputDecoration(labelText: 'Motivo'),
                    maxLines: 3,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Escribe el motivo.'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _busy ? null : _submit,
                    child: Text(_busy ? 'Guardando...' : 'Solicitar reserva'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
