import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmProvider with ChangeNotifier {
  late SharedPreferences _prefs;

  static late bool _isActive;

  static get isActive => _isActive;

  AlarmProvider() {
    _loadNotifPref();
  }

  void switchMode() {
    _isActive = !_isActive;
    _saveNotifPref(_isActive);
    notifyListeners();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _saveNotifPref(bool value) {
    _prefs.setBool('isActive', value);
  }

  Future<void> _loadNotifPref() async {
    await _initPrefs();
    _isActive = _prefs.getBool('isActive') ?? true;
    notifyListeners();
  }
}
