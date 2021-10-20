import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:lendme/services/auth.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            title: const Text('Sign in to Lend Me')
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
            child: OrientationBuilder(
                builder: (context, orientation) {
                  if(orientation == Orientation.portrait) {
                    return Column(
                      children: [
                        const Image(image: AssetImage("assets/images/logo.png")),
                        Expanded(child: AuthButtons())
                      ],
                    );
                  }
                  else {
                    return Row(
                      children: [
                        const Expanded(
                          child: Image(image: AssetImage("assets/images/logo.png")),
                        ),
                        const Spacer(),
                        Expanded(child: AuthButtons()),
                      ],
                    );
                  }
                }
            )
        )
    );
  }
}


class AuthButtons extends StatelessWidget {
  AuthButtons({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return Colors.blueGrey;
                }),
          ),
          child: const Text('Sign in anonymously'),
          onPressed: () async {
            dynamic result = await _auth.signInAnon();
            if(result == null) {
              print('error signing in');
            } else {
              print('signed in');
              print(result);
            }
          },
        ),
        SignInButton(
          Buttons.Google,
          onPressed: () async {
            dynamic result = await _auth.signInWithGoogle();
            if(result == null) {
              print('error signing in');
            } else {
              print('signed in');
              print(result);
            }
          },
        ),
        SignInButton(
          Buttons.Facebook,
          onPressed: () async {
            dynamic result = await _auth.signInWithFacebook();
            if(result == null) {
              print('error signing in');
            } else {
              print('signed in');
              print(result);
            }
          },
        ),
      ],
    );
  }
}
