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
