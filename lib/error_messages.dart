import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

String errorMessage(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'wrong-password':
      case 'user-not-found':
      case 'invalid-credential':
        return 'Correo o contraseña incorrectos.';
      case 'email-already-in-use':
        return 'Este correo ya está registrado.';
      case 'weak-password':
        return 'La contraseña es demasiado débil.';
      case 'invalid-email':
        return 'El correo no tiene un formato válido.';
      case 'network-request-failed':
        return 'Sin conexión. Comprueba tu conexión e inténtalo de nuevo.';
    }
  }
  if (error is FirebaseException) {
    switch (error.code) {
      case 'permission-denied':
        return 'No tienes permiso para realizar esta acción.';
      case 'unavailable':
      case 'network-request-failed':
        return 'Sin conexión. Comprueba tu conexión e inténtalo de nuevo.';
      case 'deadline-exceeded':
        return 'La solicitud tardó demasiado. Inténtalo de nuevo.';
    }
  }
  if (error is TimeoutException) {
    return 'La solicitud tardó demasiado. Inténtalo de nuevo.';
  }
  if (error is SocketException ||
      error is HttpException ||
      error is http.ClientException) {
    return 'Sin conexión. Comprueba tu conexión e inténtalo de nuevo.';
  }
  if (error is StateError) {
    final message = error.message;
    const businessMessages = {
      'No se pudo cargar el catálogo.',
      'Indica el motivo de la reserva.',
      'La franja ya fue tomada',
      'Solo un usuario puede cancelar reservas.',
      'Solo el propietario puede cancelar la reserva.',
      'Esta reserva ya no se puede cancelar.',
      'No se puede cancelar con menos de una hora de anticipación.',
      'La reserva no existe en el servidor.',
      'Solo administración puede confirmar reservas.',
      'No puedes confirmar tu propia reserva.',
      'La cantidad supera la capacidad del espacio.',
      'No se puede confirmar una franja que ya inició.',
      'La solicitud ya no está disponible para confirmar.',
      'Solo administración puede rechazar reservas.',
      'No puedes rechazar tu propia reserva.',
      'Escribe el motivo del rechazo.',
      'Solo se puede rechazar una solicitud pendiente.',
      'Solo administración puede bloquear franjas.',
      'No se puede bloquear una franja ocupada.',
      'La franja no está bloqueada.',
      'Solo el encargado de acceso puede registrar ingresos.',
      'Solo se admite el ingreso de una reserva confirmada.',
      'El ingreso solo se permite dentro de la franja reservada.',
      'Solo el encargado de acceso puede registrar salidas.',
      'Solo se puede registrar salida de una reserva en uso.',
      'Solo acceso puede marcar una ausencia.',
      'Solo se puede marcar ausencia en una confirmada.',
      'La franja aún no termina.',
      'Las franjas disponibles van de 07:00 a 20:00.',
      'Selecciona una fecha futura.',
    };
    if (businessMessages.contains(message) ||
        message.startsWith('Los asistentes deben estar entre 1 y ')) {
      return message;
    }
  }
  return 'Ocurrió un error inesperado. Inténtalo de nuevo.';
}
