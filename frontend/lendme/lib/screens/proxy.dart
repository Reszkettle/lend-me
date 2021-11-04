import 'package:flutter/material.dart';
import 'package:lendme/exceptions/general.dart';
import 'package:lendme/models/resource.dart';
import 'package:lendme/models/user.dart';
import 'package:lendme/routes/auth_routes.dart';
import 'package:lendme/routes/main_routes.dart';
import 'package:lendme/screens/settings/edit_profile.dart';
import 'package:provider/provider.dart';

import 'other/error.dart';
import 'other/splash.dart';

// Enum representing parts of application which may be visible
enum _Screen {
  splash, auth, main, fillProfile, error
}

// Top widget showing proper part of application based on current user state. Actively listening
class Proxy extends StatelessWidget {
  Proxy({Key? key}) : super(key: key);

  final Map<_Screen, Widget> _screenViews = {
    _Screen.splash: const Splash(),
    _Screen.auth: PreMadeNavigator(routes: authRoutes, key: UniqueKey(),),
    _Screen.main: PreMadeNavigator(routes: mainRoutes, key: UniqueKey()),
    _Screen.fillProfile: const EditProfile(afterLoginVariant: true),
    _Screen.error: const ErrorScreen(),
  };

  @override
  Widget build(BuildContext context) {
    final userResource = Provider.of<Resource<User>>(context);
    _Screen screen = _getScreenForUser(userResource);
    return _screenViews[screen]!;
  }

  // Return which part of application should be visible for given user state
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
      if(userResource.data!.info.isFilled()) {
        return _Screen.main;
      }
      else {
        return _Screen.fillProfile;
      }
    }
    return _Screen.splash;
  }

}


// Generally just a navigator, but with added support to hardware back button
class PreMadeNavigator extends StatelessWidget {
  PreMadeNavigator({required this.routes, this.initialRoute='/', Key? key}) : super(key: key);

  final GlobalKey<NavigatorState> _navigator = GlobalKey();
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
