import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lendme/screens/proxy.dart';
import 'package:lendme/services/auth.dart';
import 'package:lendme/services/emulators.dart';
import 'package:provider/provider.dart';

const useEmulators = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (useEmulators) {
    await EmulatorsService().setupEmulators();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<String?>.value(
      value: AuthService().uid,
      initialData: null,
      child: const Proxy()
    );
  }
}

