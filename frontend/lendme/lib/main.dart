
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lendme/screens/proxy.dart';
import 'package:lendme/services/auth.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: const Proxy()
    );
  }
}

