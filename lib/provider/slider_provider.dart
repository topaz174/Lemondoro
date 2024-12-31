import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SliderProvider with ChangeNotifier {
  late SharedPreferences _prefs;

  
  static int _studyDurationSliderValue = 25; 
  static int _shortBreakDurationSliderValue = 5; 
  static int _longBreakDurationSliderValue = 15; 
  static int _roundSliderValue = 4; 

  static int get studyDurationSliderValue => _studyDurationSliderValue;
  static int get shortBreakDurationSliderValue => _shortBreakDurationSliderValue;
  static int get longBreakDurationSliderValue => _longBreakDurationSliderValue;
  static int get roundSliderValue => _roundSliderValue;

  SliderProvider() {
    _loadSliderPref();  
  }
  
  void updateWorkDurationSliderValue(int newValue) {
    _studyDurationSliderValue = newValue;
    _saveSliderPref('studyDurationSliderValue', _studyDurationSliderValue);
    notifyListeners();
  }

  void updateShortBreakDurationSliderValue(int newValue) {
    _shortBreakDurationSliderValue = newValue;
    _saveSliderPref('shortBreakDurationSliderValue', _shortBreakDurationSliderValue);
    notifyListeners();
  }

  void updateLongBreakDurationSliderValue(int newValue) {
    _longBreakDurationSliderValue = newValue;
    _saveSliderPref('longBreakDurationSliderValue', _longBreakDurationSliderValue);
    notifyListeners();
  }

  void updateRoundSliderValue(int newValue) {
    _roundSliderValue = newValue;
    _saveSliderPref('roundSliderValue', _roundSliderValue);
    notifyListeners();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _saveSliderPref(String key, int value) {
    _prefs.setInt(key, value);
  }

  Future<void> _loadSliderPref() async {
    await _initPrefs();
    _studyDurationSliderValue = _prefs.getInt('studyDurationSliderValue') ?? 25;
    _shortBreakDurationSliderValue = _prefs.getInt('shortBreakDurationSliderValue') ?? 5;
    _longBreakDurationSliderValue = _prefs.getInt('longBreakDurationSliderValue') ?? 15;
    _roundSliderValue = _prefs.getInt('roundSliderValue') ?? 4;

    notifyListeners();
  }
}
