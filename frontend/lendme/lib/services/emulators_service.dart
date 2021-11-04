import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EmulatorsService {

  final _host = Platform.isAndroid ? '10.0.2.2' : 'localhost';

  final _firestorePort = 8080;
  final _authPort = 9099;
  final _storagePort = 9199;
  final _functionsPort = 5001;

  Future setupEmulators() async {
    FirebaseFirestore.instance.useFirestoreEmulator(_host, _firestorePort);
    await FirebaseAuth.instance.useAuthEmulator(_host, _authPort);
    await FirebaseStorage.instance.useStorageEmulator(_host, _storagePort);
    FirebaseFunctions.instance.useFunctionsEmulator(_host, _functionsPort);
  }

}
