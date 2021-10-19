import 'package:flutter/material.dart';
import 'package:lendme/services/auth.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            title: const Text('Sign in to Lend Me')
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: ElevatedButton(
              child: const Text('Sign in anon'),
              onPressed: () async {
                dynamic result = await _auth.signInAnon();
                if(result == null) {
                  print('error signing in');
                } else {
                  print('signed in');
                  print(result);
                }
              },
            )
        )
    );
  }
}
