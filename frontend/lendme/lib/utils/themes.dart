import 'package:flutter/material.dart';
import 'package:lendme/utils/constants.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    highlightColor: Colors.green.shade200,
    errorColor: Colors.red.shade200,
    dividerColor: Colors.yellow.shade200,
    cardColor: Colors.black12,

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: lightAppBarColor,
      showUnselectedLabels: true,
    ),
  );
  static final dark = ThemeData.dark().copyWith(
    canvasColor: Colors.black.withOpacity(0.7), // Background
    highlightColor: Colors.green,
    errorColor: Colors.red,
    dividerColor: Colors.orange,
    cardColor: Colors.white12,

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
