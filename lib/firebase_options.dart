import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Esta aplicación solo admite Android.');
    }
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'CONFIGURAR_CON_FLUTTERFIRE',
    appId: 'CONFIGURAR_CON_FLUTTERFIRE',
    messagingSenderId: 'CONFIGURAR_CON_FLUTTERFIRE',
    projectId: 'CONFIGURAR_CON_FLUTTERFIRE',
  );
}
