import 'package:flutter/material.dart';
import 'package:lendme/components/confirm_dialog.dart';
import 'package:lendme/services/auth_service.dart';

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
                    Navigator.of(context).pushNamed('/edit_profile');
                  },
                  child: const Text('Edit profile')
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/change_theme');
                  },
                  child: const Text('Change theme')
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/credits');
                  },
                  child: const Text('Credits')
              ),
              ElevatedButton(
                  onPressed: () => _showLogOutConfirmDialog(context),
                  child: const Text('Log out')
              ),
            ],
          ),
        ),
    );
  }

  void _showLogOutConfirmDialog(BuildContext context) {
    showConfirmDialog(
        context: context,
        message: 'Are you sure that you want to log out?',
        yesCallback: () => _auth.signOut()
    );
  }

}
