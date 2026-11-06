import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'access_screen.dart';
import 'admin_screen.dart';
import 'app_services.dart';
import 'my_reservations_screen.dart';
import 'spaces_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    super.key,
  });

  final String uid;
  final String email;
  final String name;
  final String role;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  late final List<_NavigationItem> _items = switch (widget.role) {
    'usuario' => [
        _NavigationItem(
          'Espacios',
          const Icon(Icons.meeting_room_outlined),
          SpacesScreen(uid: widget.uid),
        ),
        _NavigationItem(
          'Mis reservas',
          const Icon(Icons.event_note),
          MyReservationsScreen(uid: widget.uid, role: widget.role),
        ),
      ],
    'administrador' => [
        _NavigationItem(
          'Agenda',
          const Icon(Icons.fact_check_outlined),
          AdminAgendaScreen(uid: widget.uid, role: widget.role),
        ),
        _NavigationItem(
          'Franjas',
          const Icon(Icons.block_outlined),
          SlotManagementScreen(role: widget.role),
        ),
      ],
    _ => [
        _NavigationItem(
          'Control diario',
          const Icon(Icons.door_front_door_outlined),
          AccessScreen(role: widget.role),
        ),
      ],
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await reservationRepository.synchronize(widget.uid);
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No se pudo sincronizar: $error')),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.name.isEmpty ? widget.email : widget.name;
    return Scaffold(
      appBar: AppBar(
        title: Text(_items[_index].label),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Menú',
            onSelected: (value) async {
              if (value == 'crash') {
                try {
                  throw StateError('Excepción de prueba de Crashlytics');
                } catch (error, stack) {
                  await FirebaseCrashlytics.instance.recordError(
                    error,
                    stack,
                    reason: 'Prueba manual desde el menú',
                    fatal: false,
                  );
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Excepción de prueba enviada a Crashlytics.'),
                    ),
                  );
                }
              } else {
                await authRepository.signOut();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Text('$title (${widget.role})'),
              ),
              const PopupMenuItem(
                value: 'crash',
                child: Text('Probar Crashlytics'),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Cerrar sesión'),
              ),
            ],
          ),
        ],
      ),
      body: _items[_index].screen,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: _items
            .map(
              (item) => NavigationDestination(
                icon: item.icon,
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _NavigationItem {
  const _NavigationItem(this.label, this.icon, this.screen);

  final String label;
  final Icon icon;
  final Widget screen;
}
