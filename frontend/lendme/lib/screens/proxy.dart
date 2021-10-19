import 'package:flutter/material.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/screens/authenticate/authenticate.dart';
import 'package:lendme/screens/home/home.dart';
import 'package:provider/provider.dart';

class Proxy extends StatelessWidget {
  const Proxy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser?>(context);

    // Show authentication screens
    if(user == null) {
      return MaterialApp(
          title: 'Lend Me',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const Authenticate()
      );
    }

    // Show main content
    else {
      return MaterialApp(
          title: 'Lend Me',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const Home()
      );
    }
  }
}
