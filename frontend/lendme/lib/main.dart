import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lendme/services/emulators_service.dart';
import 'package:get_storage/get_storage.dart';
import 'app.dart';
const useEmulators = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (useEmulators) {
    await EmulatorsService().setupEmulators();
  }
  await GetStorage.init();
  runApp(const LentMeApp());
}
