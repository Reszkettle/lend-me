import 'package:flutter/material.dart';
import 'package:lendme/utils/constants.dart';
class Themes {
  static final light = ThemeData.light().copyWith(
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: lightAppBarColor,
      showUnselectedLabels: true,
    ),

  );
  static final dark = ThemeData.dark().copyWith(
    primaryColor: darkPrimaryColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    bottomAppBarColor: darkBackgroundColor,
    hintColor: darkSecondaryColor,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkPrimaryColor,
      showUnselectedLabels: true,
    ),
    textTheme: const TextTheme(

      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline2: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyText2: TextStyle(fontSize: 14.0, color: Colors.white),
    ),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: darkPrimaryColor,
      surface: darkPrimaryColor,
      background: darkBackgroundColor,
      secondary: darkSecondaryColor,
      onPrimary: textColorWhite,
      onSecondary: textColorWhite,

    ),
  );
}
