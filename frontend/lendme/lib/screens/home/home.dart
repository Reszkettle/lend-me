import 'package:flutter/material.dart';
import 'package:lendme/services/auth.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: const Text('Lend me'),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                  'logout',
                  style: TextStyle(color: Colors.white),
              ),
            onPressed: () async {
                await _auth.signOut();
            },
          ),
        ]
      )
    );
  }
}
