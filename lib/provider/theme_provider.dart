import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  late SharedPreferences _prefs;
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _initPrefs();
    await _loadThemePref();
  }

  void switchTheme() {
    _isDarkMode = !_isDarkMode;
    _saveThemePref(_isDarkMode);
    notifyListeners();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _saveThemePref(bool value) {
    _prefs.setBool('isDarkMode', value);
  }

  Future<void> _loadThemePref() async {
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }
}
