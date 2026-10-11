import 'package:final_project/theme_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('defaults to light mode when no preference is saved', () async {
    expect(await ThemePreferences.loadThemeMode(), ThemeMode.light);
  });

  test('loads the saved dark mode preference', () async {
    await ThemePreferences.saveThemeMode(ThemeMode.dark);

    expect(await ThemePreferences.loadThemeMode(), ThemeMode.dark);
  });

  test('loads light mode after saving light mode', () async {
    await ThemePreferences.saveThemeMode(ThemeMode.dark);
    await ThemePreferences.saveThemeMode(ThemeMode.light);

    expect(await ThemePreferences.loadThemeMode(), ThemeMode.light);
  });
}
