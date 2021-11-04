import 'package:flutter/material.dart';
import 'package:lendme/routes/auth_routes.dart';

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
        onGenerateRoute: authRoutes,
      ),
    );
  }
}
