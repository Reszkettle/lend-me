import 'package:flutter/material.dart';
import 'package:lendme/models/user.dart';
import 'package:provider/provider.dart';

import 'package:lendme/screens/main/routes.dart' as main;

class Proxy extends StatelessWidget {
  const Proxy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    return MaterialApp(
      key: Key(user.toString()),
      title: 'Lend Me',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: (user == null) ? main.routes : main.routes,
    );
  }
}
