import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'local_database.g.dart';

class Spaces extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get location => text()();
  IntColumn get capacity => integer()();
  TextColumn get featuresJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Reservations extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get spaceId => text()();
  TextColumn get spaceName => text()();
  IntColumn get capacity => integer()();
  TextColumn get date => text()();
  IntColumn get hour => integer()();
  IntColumn get attendees => integer()();
  TextColumn get reason => text()();
  TextColumn get status => text()();
  TextColumn get syncStatus => text()();
  TextColumn get conflictReason => text().nullable()();
  TextColumn get rejectReason => text().nullable()();
  IntColumn get checkIn => integer().nullable()();
  IntColumn get checkOut => integer().nullable()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Spaces, Reservations])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> cacheSpaces(List<Map<String, Object?>> rows) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(
        spaces,
        rows.map(
          (row) => SpacesCompanion.insert(
            id: row['id']! as String,
            name: row['name']! as String,
            location: row['location']! as String,
            capacity: row['capacity']! as int,
            featuresJson: jsonEncode(row['features']!),
          ),
        ),
      );
    });
  }

  Future<void> saveReservation(Map<String, Object?> r) async {
    await customStatement(
      'INSERT OR REPLACE INTO reservations '
      '(id,user_id,space_id,space_name,capacity,date,hour,attendees,reason,status,'
      'sync_status,conflict_reason,reject_reason,check_in,check_out,created_at) '
      'VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
      [
        r['id'],
        r['userId'],
        r['spaceId'],
        r['spaceName'],
        r['capacity'],
        r['date'],
        r['hour'],
        r['attendees'],
        r['reason'],
        r['status'],
        r['syncStatus'],
        r['conflictReason'],
        r['rejectReason'],
        r['checkIn'],
        r['checkOut'],
        r['createdAt'],
      ],
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'reservations.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
