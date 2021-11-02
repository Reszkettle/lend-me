import 'package:flutter/material.dart';
import 'package:lendme/models/user_info.dart';
import 'package:lendme/repositories/user_repository.dart';
import 'package:lendme/services/auth.dart';

class Settings extends StatelessWidget {
  Settings({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();
  final UserRepository _userRepository = UserRepository();

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
                    _userRepository.setUserInfo('lrhIii20OubCmi5KnkA0ymVemy7n',
                    UserInfo(
                        firstName: 'Julia',
                        lastName: 'Marciniak',
                        phone: '666563933',
                        email: 'jmarciniak@gmail.com'));
                    // Navigator.pushNamed(context, '/change_theme');
                  },
                  child: const Text('Change theme')
              ),
              ElevatedButton(
                  onPressed: () {
                    _userRepository.getUser('lrhIii20OubCmi5KnkA0ymVemy7n');
                    // Navigator.pushNamed(context, '/credits');
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
