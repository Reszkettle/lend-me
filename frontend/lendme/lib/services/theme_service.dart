import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }

  void switchToDark() {
    if (_loadThemeFromBox() == false) {
      Get.changeThemeMode(ThemeMode.dark); //change to dark mode dynamically
      _saveThemeToBox(true); //set Dark Mode in storage
    }
  }

  void switchToLight() {
    if (_loadThemeFromBox() == true) {
      Get.changeThemeMode(ThemeMode.light); //change to light mode dynamically
      _saveThemeToBox(false); //set Light Mode in storage
    }
  }
}
