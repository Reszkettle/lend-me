import 'package:flutter/material.dart';
import 'package:lendme/exceptions/general.dart';
import 'package:lendme/models/resource.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/screens/error/error.dart';
import 'package:lendme/screens/info/info.dart';
import 'package:lendme/screens/splash/splash.dart';
import 'package:provider/provider.dart';

import 'auth/auth.dart';
import 'main/main.dart';

class Proxy extends StatefulWidget {
  const Proxy({Key? key}) : super(key: key);

  @override
  State<Proxy> createState() => _ProxyState();
}

class _ProxyState extends State<Proxy> {

  late Widget _view;

  @override
  void initState() {
    _view = _getProperScreen(Resource<User?>.loading());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userResource = Provider.of<Resource<User?>>(context);
    setState(() {
      _view = _getProperScreen(userResource);
    });
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 700),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1.2, 0), end: const Offset(0, 0))
              .animate(animation),
          child: child,
        );
      },
      child: _view,
    );
  }

  Widget _getProperScreen(Resource<User?> userResource) {
    if(userResource.isError) {
      if(userResource.error is UserNotAuthenticatedException) {
        return Auth();
      }
      else {
        return const ErrorScreen();
      }
    }
    else if(userResource.isSuccess) {
      if(userResource.data?.info.phone != null) {
        return Main();
      }
      else {
        return const Info();
      }
    }

    return const Splash();
  }
}
