import 'package:flutter/material.dart';
import 'package:lendme/screens/home/home.dart';
import 'package:lendme/screens/other/add_item.dart';
import 'package:lendme/screens/settings/change_theme.dart';
import 'package:lendme/screens/settings/credits.dart';
import 'package:lendme/screens/settings/edit_profile.dart';
import 'package:lendme/screens/settings/settings.dart';

Route? mainRoutes(settings) {
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
}