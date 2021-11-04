import 'package:flutter/material.dart';
import 'package:lendme/routes/main_routes.dart';

class Main extends StatelessWidget {
  Main({Key? key}) : super(key: key);

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
        onGenerateRoute: mainRoutes,
      ),
    );
  }
}
