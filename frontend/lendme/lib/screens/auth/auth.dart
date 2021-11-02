import 'package:flutter/material.dart';
import 'package:lendme/screens/auth/auth_main.dart';
import 'package:lendme/screens/auth/email_auth.dart';

class Auth extends StatelessWidget {
  Auth({Key? key}) : super(key: key);

  final _navigator = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navigator.currentState?.maybePop();
        return false;
      },
      child: Navigator(
        key: _navigator,
        onGenerateRoute: (settings) {
          if(settings.name == '/') {
            return MaterialPageRoute(builder: (context) {return const AuthMain();});
          }
          if(settings.name == '/email') {
            return MaterialPageRoute(builder: (context) {return EmailAuth();});
          }
        },
      ),
    );
  }
}
