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

class Proxy extends StatelessWidget {
  const Proxy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final userResource = Provider.of<Resource<User?>>(context);
    print('User changed to $userResource');

    Widget widget = Splash();
    if(userResource.isError) {
      if(userResource.error is UserNotAuthenticatedException) {
        widget = Auth();
      }
      else {
        widget = ErrorScreen();
      }
    }
    else if(userResource.isSuccess) {
      if(userResource.data?.info.phone != null) {
        widget = Main();
      }
      else {
        widget = Info();
      }
    }

    return widget;
  }
}
