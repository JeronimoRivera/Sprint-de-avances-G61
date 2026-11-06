bool isValidReservationHour(int hour) => hour >= 7 && hour <= 19;

bool isFutureReservationDate(DateTime date, DateTime now) {
  final reservationDay = DateTime(date.year, date.month, date.day);
  final today = DateTime(now.year, now.month, now.day);
  return reservationDay.isAfter(today);
}

bool isValidAttendeeCount(int attendees, int capacity) =>
    attendees >= 1 && attendees <= capacity;

bool canCancelReservation(DateTime startsAt, DateTime now) =>
    !now.isAfter(startsAt.subtract(const Duration(hours: 1)));

bool canCheckInReservation(DateTime startsAt, DateTime now) =>
    !now.isBefore(startsAt) &&
    now.isBefore(startsAt.add(const Duration(hours: 1)));

bool isValidReservationTransition(Object? current, Object? next) =>
    (current == 'SOLICITADA' &&
        (next == 'CANCELADA' || next == 'CONFIRMADA' || next == 'RECHAZADA')) ||
    (current == 'CONFIRMADA' &&
        (next == 'CANCELADA' || next == 'EN_USO' || next == 'AUSENTE')) ||
    (current == 'EN_USO' && next == 'FINALIZADA');
