import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lendme/main.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lend Me',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/splash': (context) => const MyHomePage(title: "Lend Me")
      },
      initialRoute: '/splash',
    );
  }
}

