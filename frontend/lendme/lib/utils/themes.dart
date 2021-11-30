import 'package:flutter/material.dart';
import 'package:lendme/utils/constants.dart';

class Themes {
  static final light = ThemeData.light().copyWith();
  static final dark = ThemeData.dark().copyWith(
    primaryColor: iconColor,
    scaffoldBackgroundColor: backgroundColor,
    bottomAppBarColor: backgroundColor,
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline2: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyText2: TextStyle(fontSize: 14.0),
    ),
    colorScheme: ColorScheme.dark().copyWith(
      primary: iconColor,
      surface: iconColor,
      background: iconColor,
      secondary: floatingButtonColor,
      onPrimary: iconColor,
      onSecondary: iconColor,
    ),
  );
}

final appBarTheme = AppBarTheme(centerTitle: false, elevation: 0);
