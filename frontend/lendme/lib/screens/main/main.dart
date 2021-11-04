import 'package:flutter/material.dart';
import 'package:lendme/screens/main/settings/edit_profile.dart';
import 'package:lendme/screens/main/home/home.dart';
import 'package:lendme/screens/main/other/add_item.dart';
import 'package:lendme/screens/main/settings/change_theme.dart';
import 'package:lendme/screens/main/settings/credits.dart';
import 'package:lendme/screens/main/settings/settings.dart';

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
        onGenerateRoute: (settings) {
          if(settings.name == '/') {
            return MaterialPageRoute(builder: (context) {return const Home();});
          }
          else if(settings.name == '/settings') {
            return MaterialPageRoute(builder: (context) {return Settings();});
          }
          else if(settings.name == '/edit_profile') {
            return MaterialPageRoute(builder: (context) {return const EditProfile();});
          }
          else if(settings.name == '/credits') {
            return MaterialPageRoute(builder: (context) {return const Credits();});
          }
          else if(settings.name == '/change_theme') {
            return MaterialPageRoute(builder: (context) {return const ChangeTheme();});
          }
          else if(settings.name == '/add_item') {
            return MaterialPageRoute(builder: (context) {return const AddItem();});
          }
        },
      ),
    );
  }
}
