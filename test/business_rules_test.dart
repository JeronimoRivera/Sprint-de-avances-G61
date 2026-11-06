import 'package:flutter_test/flutter_test.dart';
import 'package:campus_room_reservations/business_rules.dart';

void main() {
  group('franjas horarias', () {
    test('acepta las horas de inicio entre 07:00 y 20:00', () {
      expect(isValidReservationHour(7), isTrue);
      expect(isValidReservationHour(19), isTrue);
    });

    test('rechaza horas fuera del horario', () {
      expect(isValidReservationHour(6), isFalse);
      expect(isValidReservationHour(20), isFalse);
    });
  });

  group('fecha futura', () {
    final now = DateTime(2026, 11, 6, 15);

    test('acepta una fecha posterior al día actual', () {
      expect(isFutureReservationDate(DateTime(2026, 11, 7), now), isTrue);
    });

    test('rechaza hoy y fechas pasadas', () {
      expect(isFutureReservationDate(DateTime(2026, 11, 6), now), isFalse);
      expect(isFutureReservationDate(DateTime(2026, 11, 5), now), isFalse);
    });
  });

  group('capacidad', () {
    test('acepta asistentes dentro del rango', () {
      expect(isValidAttendeeCount(1, 24), isTrue);
      expect(isValidAttendeeCount(24, 24), isTrue);
    });

    test('rechaza cantidades fuera del rango', () {
      expect(isValidAttendeeCount(0, 24), isFalse);
      expect(isValidAttendeeCount(25, 24), isFalse);
    });
  });

  group('cancelación', () {
    final start = DateTime(2026, 11, 7, 10);

    test('permite cancelar con al menos una hora de anticipación', () {
      expect(
        canCancelReservation(start, DateTime(2026, 11, 7, 9)),
        isTrue,
      );
      expect(
        canCancelReservation(start, DateTime(2026, 11, 7, 8, 59)),
        isTrue,
      );
    });

    test('rechaza cancelar con menos de una hora de anticipación', () {
      expect(
        canCancelReservation(start, DateTime(2026, 11, 7, 9, 1)),
        isFalse,
      );
    });
  });

  group('ingreso', () {
    final start = DateTime(2026, 11, 7, 10);

    test('permite el ingreso dentro de la franja de una hora', () {
      expect(canCheckInReservation(start, start), isTrue);
      expect(
        canCheckInReservation(start, DateTime(2026, 11, 7, 10, 59)),
        isTrue,
      );
    });

    test('rechaza el ingreso antes y al finalizar la franja', () {
      expect(
        canCheckInReservation(start, DateTime(2026, 11, 7, 9, 59)),
        isFalse,
      );
      expect(
        canCheckInReservation(start, DateTime(2026, 11, 7, 11)),
        isFalse,
      );
    });
  });

  group('transiciones de estado', () {
    test('acepta transiciones permitidas', () {
      expect(isValidReservationTransition('SOLICITADA', 'CONFIRMADA'), isTrue);
      expect(isValidReservationTransition('SOLICITADA', 'CANCELADA'), isTrue);
      expect(isValidReservationTransition('SOLICITADA', 'RECHAZADA'), isTrue);
      expect(isValidReservationTransition('CONFIRMADA', 'CANCELADA'), isTrue);
      expect(isValidReservationTransition('CONFIRMADA', 'EN_USO'), isTrue);
      expect(isValidReservationTransition('CONFIRMADA', 'AUSENTE'), isTrue);
      expect(isValidReservationTransition('EN_USO', 'FINALIZADA'), isTrue);
    });

    test('rechaza transiciones no permitidas', () {
      expect(isValidReservationTransition('SOLICITADA', 'EN_USO'), isFalse);
      expect(isValidReservationTransition('CONFIRMADA', 'RECHAZADA'), isFalse);
      expect(isValidReservationTransition('FINALIZADA', 'CONFIRMADA'), isFalse);
    });
  });
}
