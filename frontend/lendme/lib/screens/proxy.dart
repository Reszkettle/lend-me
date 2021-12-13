import 'package:flutter/material.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/routes/auth_routes.dart';
import 'package:lendme/routes/main_routes.dart';
import 'package:lendme/screens/settings/edit_profile.dart';
import 'package:lendme/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'other/splash.dart';

// Enum representing parts of application which may be visible
enum _Screen { splash, auth, main, fillProfile }

// Top widget showing proper part of application based on current user state. Actively listening
class Proxy extends StatefulWidget {
  const Proxy({Key? key}) : super(key: key);

  @override
  State<Proxy> createState() => _ProxyState();
}

class _ProxyState extends State<Proxy> {
  final AuthService _authRepository = AuthService();

  late _Screen _screen;
  late Widget _screenView;

  final Map<_Screen, Widget> _screenViews = {
    _Screen.splash: const Splash(),
    _Screen.auth: PreMadeNavigator(
      GlobalKey(),
      routes: authRoutes,
      key: UniqueKey(),
    ),
    _Screen.main: PreMadeNavigator(mainNavigator, routes: mainRoutes, key: UniqueKey()),
    _Screen.fillProfile: const EditProfile(afterLoginVariant: true),
  };

  @override
  void initState() {
    super.initState();
    _screen = _Screen.splash;
    _screenView = _screenViews[_screen]!;
  }

  @override
  Widget build(BuildContext context) {
    final uid = _authRepository.getUid();
    final user = Provider.of<User?>(context);
    _Screen newScreen = _getScreen(uid, user);
    if (_screen != newScreen) {
      setState(() {
        _screen = newScreen;
        _screenView = _screenViews[_screen]!;
      });
    }
    return _screenView;
  }

  _Screen _getScreen(String? uid, User? user) {
    if (uid == null) {
      return _Screen.auth;
    } else {
      if (user == null) {
        return _Screen.auth;
      } else if (!user.info.isFilled()) {
        return _Screen.fillProfile;
      } else {
        return _Screen.main;
      }
    }
  }
}

// Generally just a navigator, but with added support to hardware back button
class PreMadeNavigator extends StatelessWidget {
  const PreMadeNavigator(this._navigator, {required this.routes, this.initialRoute = '/', Key? key})
      : super(key: key);

  final GlobalKey<NavigatorState> _navigator;
  final String initialRoute;
  final Route<dynamic>? Function(RouteSettings) routes;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navigator.currentState?.maybePop();
        return false;
      },
      child: Navigator(
        key: _navigator,
        initialRoute: initialRoute,
        onGenerateRoute: routes,
      ),
    );
  }
}
