import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf_reader/theme/themes.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode;

  ThemeProvider() : isDarkMode = false {
    _loadThemeFromPreferences();
  }

  ThemeData get currentTheme => isDarkMode ? darkMode : lightMode;

  void changeTheme() {
    isDarkMode = !isDarkMode;
    _saveThemeToPreferences();
    notifyListeners();
  }

  Future<void> _loadThemeFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  Future<void> _saveThemeToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }

  void updateThemeBasedOnSystem() {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    isDarkMode = brightness == Brightness.dark;
    _saveThemeToPreferences();
    notifyListeners();
  }
}
