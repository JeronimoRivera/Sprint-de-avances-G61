import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_repository.dart';
import 'local_database.dart';
import 'repositories.dart';

late final AuthRepository authRepository;
late final LocalDatabase localDatabase;
late final ReservationRepository reservationRepository;
late final SpaceRepository spaceRepository;

void initializeAppServices() {
  authRepository = AuthRepository(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  );
  localDatabase = LocalDatabase();
  reservationRepository = ReservationRepository(
    localDatabase,
    FirebaseFirestore.instance,
  );
  spaceRepository = SpaceRepository(localDatabase);
}
