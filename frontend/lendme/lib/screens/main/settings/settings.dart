import 'package:flutter/material.dart';
import 'package:lendme/services/auth.dart';

class Settings extends StatelessWidget {
  Settings({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Settings'),
            elevation: 0.0
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/edit_profile');
                  },
                  child: const Text('Edit profile')
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/change_theme');
                  },
                  child: const Text('Change theme')
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/credits');
                  },
                  child: const Text('Credits')
              ),
              ElevatedButton(
                  onPressed: () {
                    _auth.signOut();
                  },
                  child: const Text('Log out')
              ),
            ],
          ),
        ),
    );
  }
}
