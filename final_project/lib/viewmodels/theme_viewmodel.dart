import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeViewModel extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  final SharedPreferences _prefs;
  ThemeMode _themeMode;

  ThemeViewModel(this._prefs) : _themeMode = _loadThemeMode(_prefs);

  ThemeMode get themeMode => _themeMode;

  static ThemeMode _loadThemeMode(SharedPreferences prefs) {
    final String? themeModeString = prefs.getString(_themeKey);
    if (themeModeString == null) return ThemeMode.system;
    return ThemeMode.values.firstWhere(
      (mode) => mode.toString() == themeModeString,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    await _prefs.setString(_themeKey, mode.toString());
    notifyListeners();
  }

  bool get isDarkMode => _themeMode == ThemeMode.dark;
} 