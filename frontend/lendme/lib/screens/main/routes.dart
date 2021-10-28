import 'package:flutter/material.dart';
import 'package:lendme/screens/main/settings/change_theme.dart';
import 'package:lendme/screens/main/settings/credits.dart';
import 'package:lendme/screens/main/settings/edit_profile.dart';
import 'package:lendme/screens/main/settings/settings.dart';

import 'add_item.dart';
import 'home/home.dart';

Map<String, WidgetBuilder> routes = {
  '/': (context) => const Home(),
  '/settings': (context) => Settings(),
  '/credits': (context) => const Credits(),
  '/edit_profile': (context) => const EditProfile(),
  '/change_theme': (context) => const ChangeTheme(),
  '/add_item': (context) => const AddItem(),
};
