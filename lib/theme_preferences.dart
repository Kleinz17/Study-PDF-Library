import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const _darkModeKey = 'dark_mode_enabled';

  static Future<ThemeMode> loadThemeMode() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_darkModeKey) == true
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  static Future<bool> saveThemeMode(ThemeMode mode) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setBool(_darkModeKey, mode == ThemeMode.dark);
  }
}
