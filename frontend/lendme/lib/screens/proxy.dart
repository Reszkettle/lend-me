import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lendme/screens/auth/routes.dart' as auth;
import 'package:lendme/screens/main/routes.dart' as main;

class Proxy extends StatelessWidget {
  const Proxy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final uid = Provider.of<String?>(context);

    return MaterialApp(
      key: Key(uid.toString()),
      title: 'Lend Me',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: (uid == null) ? auth.routes : main.routes,
    );
  }
}
