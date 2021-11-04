import 'package:flutter/material.dart';
import 'package:lendme/exceptions/general.dart';
import 'package:lendme/models/resource.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/screens/main/other/error.dart';
import 'package:lendme/screens/main/other/splash.dart';
import 'package:provider/provider.dart';

import 'auth/auth.dart';
import 'main/main.dart';
import 'main/settings/edit_profile.dart';

class Proxy extends StatefulWidget {
  const Proxy({Key? key}) : super(key: key);

  @override
  State<Proxy> createState() => _ProxyState();
}

class _ProxyState extends State<Proxy> {

  late _Screen _screen;
  late Widget _view;

  final Map<_Screen, Widget> _screenViews = {
    _Screen.splash: const Splash(),
    _Screen.auth: Auth(),
    _Screen.main: Main(),
    _Screen.fillProfile: const EditProfile(afterLoginVariant: true),
    _Screen.error: const ErrorScreen(),
  };

  @override
  void initState() {
    _screen = _getScreenForUser(Resource<User>.loading());
    _view = _screenViews[_screen]!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userResource = Provider.of<Resource<User>>(context);

    var newScreen = _getScreenForUser(userResource);
    if(_screen != newScreen) {
      setState(() {
        _screen = newScreen;
        _view = _screenViews[_screen]!;
      });
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 700),
      transitionBuilder: (Widget child, Animation<double> animation) =>
        SlideTransition(
          position: Tween<Offset>(
              begin: const Offset(1.2, 0),
              end: const Offset(0, 0)
          ).animate(animation),
          child: child,
        ),
      child: _view,
    );
  }

  _Screen _getScreenForUser(Resource<User> userResource) {
    if(userResource.isError) {
      if(userResource.error is ResourceNotFoundException) {
        return _Screen.auth;
      }
      else {
        return _Screen.error;
      }
    }
    else if(userResource.isSuccess) {
      if(userResource.data?.info.phone != null) {
        return _Screen.main;
      }
      else {
        return _Screen.fillProfile;
      }
    }

    return _Screen.splash;
  }
}

enum _Screen {
  splash, auth, main, fillProfile, error
}