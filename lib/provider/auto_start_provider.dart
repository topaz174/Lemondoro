import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutoStartProvider with ChangeNotifier {
  late SharedPreferences _prefs;

  static late bool _autoStart;

  static bool get autoStart => _autoStart;

  AutoStartProvider() {
    _loadAutoStartPref();
  }

  void switchMode() {
    _autoStart = !_autoStart;
    _saveAutoStartPref(_autoStart);
    notifyListeners();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _saveAutoStartPref(bool value) {
    _prefs.setBool('autoStart', value);
  }

  Future<void> _loadAutoStartPref() async {
    await _initPrefs();
    _autoStart = _prefs.getBool('autoStart') ?? true;
    notifyListeners();
  }
}