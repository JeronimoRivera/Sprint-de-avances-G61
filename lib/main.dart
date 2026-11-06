import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'app_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    unawaited(
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
    return true;
  };
  initializeAppServices();
  runApp(const ReservationsApp());
}

class ReservationsApp extends StatelessWidget {
  const ReservationsApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Reservas de espacios',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const SessionGate(),
      );
}

class SessionGate extends StatelessWidget {
  const SessionGate({super.key});

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: authRepository.authStateChanges,
        builder: (context, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          final user = authSnapshot.data;
          if (user == null) return const LoginScreen();
          return FutureBuilder<Map<String, dynamic>?>(
            future: authRepository.profile(user.uid),
            builder: (context, profileSnapshot) {
              if (profileSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (profileSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'No se pudo cargar el perfil: '
                          '${profileSnapshot.error}',
                        ),
                        TextButton(
                          onPressed: authRepository.signOut,
                          child: const Text('Cerrar sesión'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              final profile = profileSnapshot.data;
              if (profile == null) {
                return Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('No existe el perfil de este usuario.'),
                        TextButton(
                          onPressed: authRepository.signOut,
                          child: const Text('Cerrar sesión'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              final role = profile['rol'] as String?;
              if (!const ['usuario', 'administrador', 'acceso']
                  .contains(role)) {
                return const Scaffold(
                  body:
                      Center(child: Text('El perfil tiene un rol no válido.')),
                );
              }
              return HomeScreen(
                uid: user.uid,
                email: user.email ?? '',
                name: profile['nombre'] as String? ?? '',
                role: role!,
              );
            },
          );
        },
      );
}
