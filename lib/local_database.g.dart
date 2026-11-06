// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $SpacesTable extends Spaces with TableInfo<$SpacesTable, Space> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _locationMeta =
      const VerificationMeta('location');
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
      'location', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _capacityMeta =
      const VerificationMeta('capacity');
  @override
  late final GeneratedColumn<int> capacity = GeneratedColumn<int>(
      'capacity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _featuresJsonMeta =
      const VerificationMeta('featuresJson');
  @override
  late final GeneratedColumn<String> featuresJson = GeneratedColumn<String>(
      'features_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, location, capacity, featuresJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'spaces';
  @override
  VerificationContext validateIntegrity(Insertable<Space> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('location')) {
      context.handle(_locationMeta,
          location.isAcceptableOrUnknown(data['location']!, _locationMeta));
    } else if (isInserting) {
      context.missing(_locationMeta);
    }
    if (data.containsKey('capacity')) {
      context.handle(_capacityMeta,
          capacity.isAcceptableOrUnknown(data['capacity']!, _capacityMeta));
    } else if (isInserting) {
      context.missing(_capacityMeta);
    }
    if (data.containsKey('features_json')) {
      context.handle(
          _featuresJsonMeta,
          featuresJson.isAcceptableOrUnknown(
              data['features_json']!, _featuresJsonMeta));
    } else if (isInserting) {
      context.missing(_featuresJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Space map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Space(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location'])!,
      capacity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}capacity'])!,
      featuresJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}features_json'])!,
    );
  }

  @override
  $SpacesTable createAlias(String alias) {
    return $SpacesTable(attachedDatabase, alias);
  }
}

class Space extends DataClass implements Insertable<Space> {
  final String id;
  final String name;
  final String location;
  final int capacity;
  final String featuresJson;
  const Space(
      {required this.id,
      required this.name,
      required this.location,
      required this.capacity,
      required this.featuresJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['location'] = Variable<String>(location);
    map['capacity'] = Variable<int>(capacity);
    map['features_json'] = Variable<String>(featuresJson);
    return map;
  }

  SpacesCompanion toCompanion(bool nullToAbsent) {
    return SpacesCompanion(
      id: Value(id),
      name: Value(name),
      location: Value(location),
      capacity: Value(capacity),
      featuresJson: Value(featuresJson),
    );
  }

  factory Space.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Space(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      location: serializer.fromJson<String>(json['location']),
      capacity: serializer.fromJson<int>(json['capacity']),
      featuresJson: serializer.fromJson<String>(json['featuresJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'location': serializer.toJson<String>(location),
      'capacity': serializer.toJson<int>(capacity),
      'featuresJson': serializer.toJson<String>(featuresJson),
    };
  }

  Space copyWith(
          {String? id,
          String? name,
          String? location,
          int? capacity,
          String? featuresJson}) =>
      Space(
        id: id ?? this.id,
        name: name ?? this.name,
        location: location ?? this.location,
        capacity: capacity ?? this.capacity,
        featuresJson: featuresJson ?? this.featuresJson,
      );
  Space copyWithCompanion(SpacesCompanion data) {
    return Space(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      location: data.location.present ? data.location.value : this.location,
      capacity: data.capacity.present ? data.capacity.value : this.capacity,
      featuresJson: data.featuresJson.present
          ? data.featuresJson.value
          : this.featuresJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Space(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('location: $location, ')
          ..write('capacity: $capacity, ')
          ..write('featuresJson: $featuresJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, location, capacity, featuresJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Space &&
          other.id == this.id &&
          other.name == this.name &&
          other.location == this.location &&
          other.capacity == this.capacity &&
          other.featuresJson == this.featuresJson);
}

class SpacesCompanion extends UpdateCompanion<Space> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> location;
  final Value<int> capacity;
  final Value<String> featuresJson;
  final Value<int> rowid;
  const SpacesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.location = const Value.absent(),
    this.capacity = const Value.absent(),
    this.featuresJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SpacesCompanion.insert({
    required String id,
    required String name,
    required String location,
    required int capacity,
    required String featuresJson,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        location = Value(location),
        capacity = Value(capacity),
        featuresJson = Value(featuresJson);
  static Insertable<Space> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? location,
    Expression<int>? capacity,
    Expression<String>? featuresJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (location != null) 'location': location,
      if (capacity != null) 'capacity': capacity,
      if (featuresJson != null) 'features_json': featuresJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SpacesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? location,
      Value<int>? capacity,
      Value<String>? featuresJson,
      Value<int>? rowid}) {
    return SpacesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      capacity: capacity ?? this.capacity,
      featuresJson: featuresJson ?? this.featuresJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (capacity.present) {
      map['capacity'] = Variable<int>(capacity.value);
    }
    if (featuresJson.present) {
      map['features_json'] = Variable<String>(featuresJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpacesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('location: $location, ')
          ..write('capacity: $capacity, ')
          ..write('featuresJson: $featuresJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReservationsTable extends Reservations
    with TableInfo<$ReservationsTable, Reservation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReservationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _spaceIdMeta =
      const VerificationMeta('spaceId');
  @override
  late final GeneratedColumn<String> spaceId = GeneratedColumn<String>(
      'space_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _spaceNameMeta =
      const VerificationMeta('spaceName');
  @override
  late final GeneratedColumn<String> spaceName = GeneratedColumn<String>(
      'space_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _capacityMeta =
      const VerificationMeta('capacity');
  @override
  late final GeneratedColumn<int> capacity = GeneratedColumn<int>(
      'capacity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hourMeta = const VerificationMeta('hour');
  @override
  late final GeneratedColumn<int> hour = GeneratedColumn<int>(
      'hour', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _attendeesMeta =
      const VerificationMeta('attendees');
  @override
  late final GeneratedColumn<int> attendees = GeneratedColumn<int>(
      'attendees', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _conflictReasonMeta =
      const VerificationMeta('conflictReason');
  @override
  late final GeneratedColumn<String> conflictReason = GeneratedColumn<String>(
      'conflict_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rejectReasonMeta =
      const VerificationMeta('rejectReason');
  @override
  late final GeneratedColumn<String> rejectReason = GeneratedColumn<String>(
      'reject_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _checkInMeta =
      const VerificationMeta('checkIn');
  @override
  late final GeneratedColumn<int> checkIn = GeneratedColumn<int>(
      'check_in', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _checkOutMeta =
      const VerificationMeta('checkOut');
  @override
  late final GeneratedColumn<int> checkOut = GeneratedColumn<int>(
      'check_out', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        spaceId,
        spaceName,
        capacity,
        date,
        hour,
        attendees,
        reason,
        status,
        syncStatus,
        conflictReason,
        rejectReason,
        checkIn,
        checkOut,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reservations';
  @override
  VerificationContext validateIntegrity(Insertable<Reservation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('space_id')) {
      context.handle(_spaceIdMeta,
          spaceId.isAcceptableOrUnknown(data['space_id']!, _spaceIdMeta));
    } else if (isInserting) {
      context.missing(_spaceIdMeta);
    }
    if (data.containsKey('space_name')) {
      context.handle(_spaceNameMeta,
          spaceName.isAcceptableOrUnknown(data['space_name']!, _spaceNameMeta));
    } else if (isInserting) {
      context.missing(_spaceNameMeta);
    }
    if (data.containsKey('capacity')) {
      context.handle(_capacityMeta,
          capacity.isAcceptableOrUnknown(data['capacity']!, _capacityMeta));
    } else if (isInserting) {
      context.missing(_capacityMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('hour')) {
      context.handle(
          _hourMeta, hour.isAcceptableOrUnknown(data['hour']!, _hourMeta));
    } else if (isInserting) {
      context.missing(_hourMeta);
    }
    if (data.containsKey('attendees')) {
      context.handle(_attendeesMeta,
          attendees.isAcceptableOrUnknown(data['attendees']!, _attendeesMeta));
    } else if (isInserting) {
      context.missing(_attendeesMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('conflict_reason')) {
      context.handle(
          _conflictReasonMeta,
          conflictReason.isAcceptableOrUnknown(
              data['conflict_reason']!, _conflictReasonMeta));
    }
    if (data.containsKey('reject_reason')) {
      context.handle(
          _rejectReasonMeta,
          rejectReason.isAcceptableOrUnknown(
              data['reject_reason']!, _rejectReasonMeta));
    }
    if (data.containsKey('check_in')) {
      context.handle(_checkInMeta,
          checkIn.isAcceptableOrUnknown(data['check_in']!, _checkInMeta));
    }
    if (data.containsKey('check_out')) {
      context.handle(_checkOutMeta,
          checkOut.isAcceptableOrUnknown(data['check_out']!, _checkOutMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reservation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reservation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      spaceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}space_id'])!,
      spaceName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}space_name'])!,
      capacity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}capacity'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      hour: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hour'])!,
      attendees: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attendees'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      conflictReason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}conflict_reason']),
      rejectReason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reject_reason']),
      checkIn: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}check_in']),
      checkOut: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}check_out']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ReservationsTable createAlias(String alias) {
    return $ReservationsTable(attachedDatabase, alias);
  }
}

class Reservation extends DataClass implements Insertable<Reservation> {
  final String id;
  final String userId;
  final String spaceId;
  final String spaceName;
  final int capacity;
  final String date;
  final int hour;
  final int attendees;
  final String reason;
  final String status;
  final String syncStatus;
  final String? conflictReason;
  final String? rejectReason;
  final int? checkIn;
  final int? checkOut;
  final int createdAt;
  const Reservation(
      {required this.id,
      required this.userId,
      required this.spaceId,
      required this.spaceName,
      required this.capacity,
      required this.date,
      required this.hour,
      required this.attendees,
      required this.reason,
      required this.status,
      required this.syncStatus,
      this.conflictReason,
      this.rejectReason,
      this.checkIn,
      this.checkOut,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['space_id'] = Variable<String>(spaceId);
    map['space_name'] = Variable<String>(spaceName);
    map['capacity'] = Variable<int>(capacity);
    map['date'] = Variable<String>(date);
    map['hour'] = Variable<int>(hour);
    map['attendees'] = Variable<int>(attendees);
    map['reason'] = Variable<String>(reason);
    map['status'] = Variable<String>(status);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || conflictReason != null) {
      map['conflict_reason'] = Variable<String>(conflictReason);
    }
    if (!nullToAbsent || rejectReason != null) {
      map['reject_reason'] = Variable<String>(rejectReason);
    }
    if (!nullToAbsent || checkIn != null) {
      map['check_in'] = Variable<int>(checkIn);
    }
    if (!nullToAbsent || checkOut != null) {
      map['check_out'] = Variable<int>(checkOut);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  ReservationsCompanion toCompanion(bool nullToAbsent) {
    return ReservationsCompanion(
      id: Value(id),
      userId: Value(userId),
      spaceId: Value(spaceId),
      spaceName: Value(spaceName),
      capacity: Value(capacity),
      date: Value(date),
      hour: Value(hour),
      attendees: Value(attendees),
      reason: Value(reason),
      status: Value(status),
      syncStatus: Value(syncStatus),
      conflictReason: conflictReason == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictReason),
      rejectReason: rejectReason == null && nullToAbsent
          ? const Value.absent()
          : Value(rejectReason),
      checkIn: checkIn == null && nullToAbsent
          ? const Value.absent()
          : Value(checkIn),
      checkOut: checkOut == null && nullToAbsent
          ? const Value.absent()
          : Value(checkOut),
      createdAt: Value(createdAt),
    );
  }

  factory Reservation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reservation(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      spaceId: serializer.fromJson<String>(json['spaceId']),
      spaceName: serializer.fromJson<String>(json['spaceName']),
      capacity: serializer.fromJson<int>(json['capacity']),
      date: serializer.fromJson<String>(json['date']),
      hour: serializer.fromJson<int>(json['hour']),
      attendees: serializer.fromJson<int>(json['attendees']),
      reason: serializer.fromJson<String>(json['reason']),
      status: serializer.fromJson<String>(json['status']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      conflictReason: serializer.fromJson<String?>(json['conflictReason']),
      rejectReason: serializer.fromJson<String?>(json['rejectReason']),
      checkIn: serializer.fromJson<int?>(json['checkIn']),
      checkOut: serializer.fromJson<int?>(json['checkOut']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'spaceId': serializer.toJson<String>(spaceId),
      'spaceName': serializer.toJson<String>(spaceName),
      'capacity': serializer.toJson<int>(capacity),
      'date': serializer.toJson<String>(date),
      'hour': serializer.toJson<int>(hour),
      'attendees': serializer.toJson<int>(attendees),
      'reason': serializer.toJson<String>(reason),
      'status': serializer.toJson<String>(status),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'conflictReason': serializer.toJson<String?>(conflictReason),
      'rejectReason': serializer.toJson<String?>(rejectReason),
      'checkIn': serializer.toJson<int?>(checkIn),
      'checkOut': serializer.toJson<int?>(checkOut),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  Reservation copyWith(
          {String? id,
          String? userId,
          String? spaceId,
          String? spaceName,
          int? capacity,
          String? date,
          int? hour,
          int? attendees,
          String? reason,
          String? status,
          String? syncStatus,
          Value<String?> conflictReason = const Value.absent(),
          Value<String?> rejectReason = const Value.absent(),
          Value<int?> checkIn = const Value.absent(),
          Value<int?> checkOut = const Value.absent(),
          int? createdAt}) =>
      Reservation(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        spaceId: spaceId ?? this.spaceId,
        spaceName: spaceName ?? this.spaceName,
        capacity: capacity ?? this.capacity,
        date: date ?? this.date,
        hour: hour ?? this.hour,
        attendees: attendees ?? this.attendees,
        reason: reason ?? this.reason,
        status: status ?? this.status,
        syncStatus: syncStatus ?? this.syncStatus,
        conflictReason:
            conflictReason.present ? conflictReason.value : this.conflictReason,
        rejectReason:
            rejectReason.present ? rejectReason.value : this.rejectReason,
        checkIn: checkIn.present ? checkIn.value : this.checkIn,
        checkOut: checkOut.present ? checkOut.value : this.checkOut,
        createdAt: createdAt ?? this.createdAt,
      );
  Reservation copyWithCompanion(ReservationsCompanion data) {
    return Reservation(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      spaceId: data.spaceId.present ? data.spaceId.value : this.spaceId,
      spaceName: data.spaceName.present ? data.spaceName.value : this.spaceName,
      capacity: data.capacity.present ? data.capacity.value : this.capacity,
      date: data.date.present ? data.date.value : this.date,
      hour: data.hour.present ? data.hour.value : this.hour,
      attendees: data.attendees.present ? data.attendees.value : this.attendees,
      reason: data.reason.present ? data.reason.value : this.reason,
      status: data.status.present ? data.status.value : this.status,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      conflictReason: data.conflictReason.present
          ? data.conflictReason.value
          : this.conflictReason,
      rejectReason: data.rejectReason.present
          ? data.rejectReason.value
          : this.rejectReason,
      checkIn: data.checkIn.present ? data.checkIn.value : this.checkIn,
      checkOut: data.checkOut.present ? data.checkOut.value : this.checkOut,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reservation(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('spaceId: $spaceId, ')
          ..write('spaceName: $spaceName, ')
          ..write('capacity: $capacity, ')
          ..write('date: $date, ')
          ..write('hour: $hour, ')
          ..write('attendees: $attendees, ')
          ..write('reason: $reason, ')
          ..write('status: $status, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('conflictReason: $conflictReason, ')
          ..write('rejectReason: $rejectReason, ')
          ..write('checkIn: $checkIn, ')
          ..write('checkOut: $checkOut, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      spaceId,
      spaceName,
      capacity,
      date,
      hour,
      attendees,
      reason,
      status,
      syncStatus,
      conflictReason,
      rejectReason,
      checkIn,
      checkOut,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reservation &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.spaceId == this.spaceId &&
          other.spaceName == this.spaceName &&
          other.capacity == this.capacity &&
          other.date == this.date &&
          other.hour == this.hour &&
          other.attendees == this.attendees &&
          other.reason == this.reason &&
          other.status == this.status &&
          other.syncStatus == this.syncStatus &&
          other.conflictReason == this.conflictReason &&
          other.rejectReason == this.rejectReason &&
          other.checkIn == this.checkIn &&
          other.checkOut == this.checkOut &&
          other.createdAt == this.createdAt);
}

class ReservationsCompanion extends UpdateCompanion<Reservation> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> spaceId;
  final Value<String> spaceName;
  final Value<int> capacity;
  final Value<String> date;
  final Value<int> hour;
  final Value<int> attendees;
  final Value<String> reason;
  final Value<String> status;
  final Value<String> syncStatus;
  final Value<String?> conflictReason;
  final Value<String?> rejectReason;
  final Value<int?> checkIn;
  final Value<int?> checkOut;
  final Value<int> createdAt;
  final Value<int> rowid;
  const ReservationsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.spaceId = const Value.absent(),
    this.spaceName = const Value.absent(),
    this.capacity = const Value.absent(),
    this.date = const Value.absent(),
    this.hour = const Value.absent(),
    this.attendees = const Value.absent(),
    this.reason = const Value.absent(),
    this.status = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.conflictReason = const Value.absent(),
    this.rejectReason = const Value.absent(),
    this.checkIn = const Value.absent(),
    this.checkOut = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReservationsCompanion.insert({
    required String id,
    required String userId,
    required String spaceId,
    required String spaceName,
    required int capacity,
    required String date,
    required int hour,
    required int attendees,
    required String reason,
    required String status,
    required String syncStatus,
    this.conflictReason = const Value.absent(),
    this.rejectReason = const Value.absent(),
    this.checkIn = const Value.absent(),
    this.checkOut = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        spaceId = Value(spaceId),
        spaceName = Value(spaceName),
        capacity = Value(capacity),
        date = Value(date),
        hour = Value(hour),
        attendees = Value(attendees),
        reason = Value(reason),
        status = Value(status),
        syncStatus = Value(syncStatus),
        createdAt = Value(createdAt);
  static Insertable<Reservation> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? spaceId,
    Expression<String>? spaceName,
    Expression<int>? capacity,
    Expression<String>? date,
    Expression<int>? hour,
    Expression<int>? attendees,
    Expression<String>? reason,
    Expression<String>? status,
    Expression<String>? syncStatus,
    Expression<String>? conflictReason,
    Expression<String>? rejectReason,
    Expression<int>? checkIn,
    Expression<int>? checkOut,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (spaceId != null) 'space_id': spaceId,
      if (spaceName != null) 'space_name': spaceName,
      if (capacity != null) 'capacity': capacity,
      if (date != null) 'date': date,
      if (hour != null) 'hour': hour,
      if (attendees != null) 'attendees': attendees,
      if (reason != null) 'reason': reason,
      if (status != null) 'status': status,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (conflictReason != null) 'conflict_reason': conflictReason,
      if (rejectReason != null) 'reject_reason': rejectReason,
      if (checkIn != null) 'check_in': checkIn,
      if (checkOut != null) 'check_out': checkOut,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReservationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? spaceId,
      Value<String>? spaceName,
      Value<int>? capacity,
      Value<String>? date,
      Value<int>? hour,
      Value<int>? attendees,
      Value<String>? reason,
      Value<String>? status,
      Value<String>? syncStatus,
      Value<String?>? conflictReason,
      Value<String?>? rejectReason,
      Value<int?>? checkIn,
      Value<int?>? checkOut,
      Value<int>? createdAt,
      Value<int>? rowid}) {
    return ReservationsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      spaceId: spaceId ?? this.spaceId,
      spaceName: spaceName ?? this.spaceName,
      capacity: capacity ?? this.capacity,
      date: date ?? this.date,
      hour: hour ?? this.hour,
      attendees: attendees ?? this.attendees,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      syncStatus: syncStatus ?? this.syncStatus,
      conflictReason: conflictReason ?? this.conflictReason,
      rejectReason: rejectReason ?? this.rejectReason,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (spaceId.present) {
      map['space_id'] = Variable<String>(spaceId.value);
    }
    if (spaceName.present) {
      map['space_name'] = Variable<String>(spaceName.value);
    }
    if (capacity.present) {
      map['capacity'] = Variable<int>(capacity.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (hour.present) {
      map['hour'] = Variable<int>(hour.value);
    }
    if (attendees.present) {
      map['attendees'] = Variable<int>(attendees.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (conflictReason.present) {
      map['conflict_reason'] = Variable<String>(conflictReason.value);
    }
    if (rejectReason.present) {
      map['reject_reason'] = Variable<String>(rejectReason.value);
    }
    if (checkIn.present) {
      map['check_in'] = Variable<int>(checkIn.value);
    }
    if (checkOut.present) {
      map['check_out'] = Variable<int>(checkOut.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReservationsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('spaceId: $spaceId, ')
          ..write('spaceName: $spaceName, ')
          ..write('capacity: $capacity, ')
          ..write('date: $date, ')
          ..write('hour: $hour, ')
          ..write('attendees: $attendees, ')
          ..write('reason: $reason, ')
          ..write('status: $status, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('conflictReason: $conflictReason, ')
          ..write('rejectReason: $rejectReason, ')
          ..write('checkIn: $checkIn, ')
          ..write('checkOut: $checkOut, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $SpacesTable spaces = $SpacesTable(this);
  late final $ReservationsTable reservations = $ReservationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [spaces, reservations];
}

typedef $$SpacesTableCreateCompanionBuilder = SpacesCompanion Function({
  required String id,
  required String name,
  required String location,
  required int capacity,
  required String featuresJson,
  Value<int> rowid,
});
typedef $$SpacesTableUpdateCompanionBuilder = SpacesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> location,
  Value<int> capacity,
  Value<String> featuresJson,
  Value<int> rowid,
});

class $$SpacesTableFilterComposer
    extends Composer<_$LocalDatabase, $SpacesTable> {
  $$SpacesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get capacity => $composableBuilder(
      column: $table.capacity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get featuresJson => $composableBuilder(
      column: $table.featuresJson, builder: (column) => ColumnFilters(column));
}

class $$SpacesTableOrderingComposer
    extends Composer<_$LocalDatabase, $SpacesTable> {
  $$SpacesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get capacity => $composableBuilder(
      column: $table.capacity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get featuresJson => $composableBuilder(
      column: $table.featuresJson,
      builder: (column) => ColumnOrderings(column));
}

class $$SpacesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $SpacesTable> {
  $$SpacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<int> get capacity =>
      $composableBuilder(column: $table.capacity, builder: (column) => column);

  GeneratedColumn<String> get featuresJson => $composableBuilder(
      column: $table.featuresJson, builder: (column) => column);
}

class $$SpacesTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $SpacesTable,
    Space,
    $$SpacesTableFilterComposer,
    $$SpacesTableOrderingComposer,
    $$SpacesTableAnnotationComposer,
    $$SpacesTableCreateCompanionBuilder,
    $$SpacesTableUpdateCompanionBuilder,
    (Space, BaseReferences<_$LocalDatabase, $SpacesTable, Space>),
    Space,
    PrefetchHooks Function()> {
  $$SpacesTableTableManager(_$LocalDatabase db, $SpacesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> location = const Value.absent(),
            Value<int> capacity = const Value.absent(),
            Value<String> featuresJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SpacesCompanion(
            id: id,
            name: name,
            location: location,
            capacity: capacity,
            featuresJson: featuresJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String location,
            required int capacity,
            required String featuresJson,
            Value<int> rowid = const Value.absent(),
          }) =>
              SpacesCompanion.insert(
            id: id,
            name: name,
            location: location,
            capacity: capacity,
            featuresJson: featuresJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SpacesTable, Space>(table),
                    BaseReferences<_$LocalDatabase, $SpacesTable, Space>(
                        db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SpacesTableProcessedTableManager = ProcessedTableManager<
    _$LocalDatabase,
    $SpacesTable,
    Space,
    $$SpacesTableFilterComposer,
    $$SpacesTableOrderingComposer,
    $$SpacesTableAnnotationComposer,
    $$SpacesTableCreateCompanionBuilder,
    $$SpacesTableUpdateCompanionBuilder,
    (Space, BaseReferences<_$LocalDatabase, $SpacesTable, Space>),
    Space,
    PrefetchHooks Function()>;
typedef $$ReservationsTableCreateCompanionBuilder = ReservationsCompanion
    Function({
  required String id,
  required String userId,
  required String spaceId,
  required String spaceName,
  required int capacity,
  required String date,
  required int hour,
  required int attendees,
  required String reason,
  required String status,
  required String syncStatus,
  Value<String?> conflictReason,
  Value<String?> rejectReason,
  Value<int?> checkIn,
  Value<int?> checkOut,
  required int createdAt,
  Value<int> rowid,
});
typedef $$ReservationsTableUpdateCompanionBuilder = ReservationsCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<String> spaceId,
  Value<String> spaceName,
  Value<int> capacity,
  Value<String> date,
  Value<int> hour,
  Value<int> attendees,
  Value<String> reason,
  Value<String> status,
  Value<String> syncStatus,
  Value<String?> conflictReason,
  Value<String?> rejectReason,
  Value<int?> checkIn,
  Value<int?> checkOut,
  Value<int> createdAt,
  Value<int> rowid,
});

class $$ReservationsTableFilterComposer
    extends Composer<_$LocalDatabase, $ReservationsTable> {
  $$ReservationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get spaceId => $composableBuilder(
      column: $table.spaceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get spaceName => $composableBuilder(
      column: $table.spaceName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get capacity => $composableBuilder(
      column: $table.capacity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hour => $composableBuilder(
      column: $table.hour, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attendees => $composableBuilder(
      column: $table.attendees, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conflictReason => $composableBuilder(
      column: $table.conflictReason,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rejectReason => $composableBuilder(
      column: $table.rejectReason, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get checkIn => $composableBuilder(
      column: $table.checkIn, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get checkOut => $composableBuilder(
      column: $table.checkOut, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ReservationsTableOrderingComposer
    extends Composer<_$LocalDatabase, $ReservationsTable> {
  $$ReservationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get spaceId => $composableBuilder(
      column: $table.spaceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get spaceName => $composableBuilder(
      column: $table.spaceName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get capacity => $composableBuilder(
      column: $table.capacity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hour => $composableBuilder(
      column: $table.hour, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attendees => $composableBuilder(
      column: $table.attendees, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conflictReason => $composableBuilder(
      column: $table.conflictReason,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rejectReason => $composableBuilder(
      column: $table.rejectReason,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get checkIn => $composableBuilder(
      column: $table.checkIn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get checkOut => $composableBuilder(
      column: $table.checkOut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ReservationsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $ReservationsTable> {
  $$ReservationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get spaceId =>
      $composableBuilder(column: $table.spaceId, builder: (column) => column);

  GeneratedColumn<String> get spaceName =>
      $composableBuilder(column: $table.spaceName, builder: (column) => column);

  GeneratedColumn<int> get capacity =>
      $composableBuilder(column: $table.capacity, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get hour =>
      $composableBuilder(column: $table.hour, builder: (column) => column);

  GeneratedColumn<int> get attendees =>
      $composableBuilder(column: $table.attendees, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<String> get conflictReason => $composableBuilder(
      column: $table.conflictReason, builder: (column) => column);

  GeneratedColumn<String> get rejectReason => $composableBuilder(
      column: $table.rejectReason, builder: (column) => column);

  GeneratedColumn<int> get checkIn =>
      $composableBuilder(column: $table.checkIn, builder: (column) => column);

  GeneratedColumn<int> get checkOut =>
      $composableBuilder(column: $table.checkOut, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ReservationsTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $ReservationsTable,
    Reservation,
    $$ReservationsTableFilterComposer,
    $$ReservationsTableOrderingComposer,
    $$ReservationsTableAnnotationComposer,
    $$ReservationsTableCreateCompanionBuilder,
    $$ReservationsTableUpdateCompanionBuilder,
    (
      Reservation,
      BaseReferences<_$LocalDatabase, $ReservationsTable, Reservation>
    ),
    Reservation,
    PrefetchHooks Function()> {
  $$ReservationsTableTableManager(_$LocalDatabase db, $ReservationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReservationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReservationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReservationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> spaceId = const Value.absent(),
            Value<String> spaceName = const Value.absent(),
            Value<int> capacity = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<int> hour = const Value.absent(),
            Value<int> attendees = const Value.absent(),
            Value<String> reason = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<String?> conflictReason = const Value.absent(),
            Value<String?> rejectReason = const Value.absent(),
            Value<int?> checkIn = const Value.absent(),
            Value<int?> checkOut = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReservationsCompanion(
            id: id,
            userId: userId,
            spaceId: spaceId,
            spaceName: spaceName,
            capacity: capacity,
            date: date,
            hour: hour,
            attendees: attendees,
            reason: reason,
            status: status,
            syncStatus: syncStatus,
            conflictReason: conflictReason,
            rejectReason: rejectReason,
            checkIn: checkIn,
            checkOut: checkOut,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String spaceId,
            required String spaceName,
            required int capacity,
            required String date,
            required int hour,
            required int attendees,
            required String reason,
            required String status,
            required String syncStatus,
            Value<String?> conflictReason = const Value.absent(),
            Value<String?> rejectReason = const Value.absent(),
            Value<int?> checkIn = const Value.absent(),
            Value<int?> checkOut = const Value.absent(),
            required int createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ReservationsCompanion.insert(
            id: id,
            userId: userId,
            spaceId: spaceId,
            spaceName: spaceName,
            capacity: capacity,
            date: date,
            hour: hour,
            attendees: attendees,
            reason: reason,
            status: status,
            syncStatus: syncStatus,
            conflictReason: conflictReason,
            rejectReason: rejectReason,
            checkIn: checkIn,
            checkOut: checkOut,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ReservationsTable, Reservation>(table),
                    BaseReferences<_$LocalDatabase, $ReservationsTable,
                        Reservation>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReservationsTableProcessedTableManager = ProcessedTableManager<
    _$LocalDatabase,
    $ReservationsTable,
    Reservation,
    $$ReservationsTableFilterComposer,
    $$ReservationsTableOrderingComposer,
    $$ReservationsTableAnnotationComposer,
    $$ReservationsTableCreateCompanionBuilder,
    $$ReservationsTableUpdateCompanionBuilder,
    (
      Reservation,
      BaseReferences<_$LocalDatabase, $ReservationsTable, Reservation>
    ),
    Reservation,
    PrefetchHooks Function()>;

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$SpacesTableTableManager get spaces =>
      $$SpacesTableTableManager(_db, _db.spaces);
  $$ReservationsTableTableManager get reservations =>
      $$ReservationsTableTableManager(_db, _db.reservations);
}
