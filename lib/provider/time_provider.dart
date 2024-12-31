import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:lemondoro/provider/auto_start_provider.dart';
import 'package:lemondoro/provider/alarm_provider.dart';
import 'audio_provider.dart';
import 'slider_provider.dart';

class TimerProvider with ChangeNotifier {
  final SoundSelectionProvider _audioProvider = SoundSelectionProvider();

  late Timer _timer;
  int _currentRound = 1;
  late int _currentTimeInSeconds;

  bool _isRunning = false;
  bool _isBreakTime = false;
  bool _showLemonade = false;

  TimerProvider() {
    resetTimer();
  }

  bool get isRunning => _isRunning;
  bool get isBreakTime => _isBreakTime;
  bool get showLemonade => _showLemonade;

  int get currentTimeInSeconds => _currentTimeInSeconds;

  int get maxTimeInSeconds =>
      (_isBreakTime
          ? (_currentRound == SliderProvider.roundSliderValue
              ? SliderProvider.longBreakDurationSliderValue
              : SliderProvider.shortBreakDurationSliderValue)
          : SliderProvider.studyDurationSliderValue) *
      60;

  double get progress => !_isBreakTime
      ? 1 - (_currentTimeInSeconds / maxTimeInSeconds)
      : (_currentTimeInSeconds / maxTimeInSeconds);

  bool get isEqual => currentTimeInSeconds == maxTimeInSeconds;

  String get currentTimeDisplay {
    final minutes = _currentTimeInSeconds ~/ 60;
    final seconds = _currentTimeInSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String get currentRoundDisplay =>
      'Round $_currentRound of ${SliderProvider.roundSliderValue}';

  void toggleTimer({bool isFromPlayButton = false}) {
    if (_isRunning) {
      _pauseTimer();
    } else {
      _startTimer(isFromPlayButton);
    }
  }

  void nextRound() {
    if (_isRunning) _pauseTimer();
    _setTime();
    if (!AutoStartProvider.autoStart) _pauseTimer();
  }

  void resetTimer() {
    _currentTimeInSeconds = maxTimeInSeconds;
    _handleLemonadeVisibility();
    _handleDrippingSound();
    notifyListeners();
  }

  void _startTimer(bool isFromPlayButton) {
    _isRunning = true;

    if (_isBreakTime) {
      _audioProvider.playSlurpingSound();
    } else if (isFromPlayButton) {
      _audioProvider.playSqueezeSound();
    }

    _handleDrippingSound();

    _handleLemonadeVisibility();

    _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
    notifyListeners();
  }

  void _pauseTimer() {
    _timer.cancel();
    _isRunning = false;
    _audioProvider.stopDrippingSound();
    notifyListeners();
  }

  void _setTime() {
    _isBreakTime = !_isBreakTime;

    _currentTimeInSeconds = _isBreakTime
        ? (_currentRound == SliderProvider.roundSliderValue
                ? SliderProvider.longBreakDurationSliderValue
                : SliderProvider.shortBreakDurationSliderValue) *
            60
        : SliderProvider.studyDurationSliderValue * 60;

    if (!_isBreakTime) _addRound();

    if (!_isBreakTime && progress == 0.0) _showLemonade = false;

    toggleTimer();
  }

  void _updateTimer(Timer timer) {
    if (_currentTimeInSeconds > 0) {
      _currentTimeInSeconds--;
      notifyListeners();
    } else {
      _timer.cancel();
      _isRunning = false;
      _setTime();

      if (!AutoStartProvider.autoStart) _pauseTimer();
      if (AlarmProvider.isActive) _audioProvider.playSelectedAudio();
    }
  }

  void _addRound() {
    if (_currentRound < SliderProvider.roundSliderValue) {
      _currentRound++;
    } else {
      _currentRound = 1;
    }
  }

  void _handleLemonadeVisibility() {
    if (progress == 0.0 && !_isBreakTime) {
      _showLemonade = false;
      notifyListeners();

      Future.delayed(const Duration(seconds: 3), () {
        if (_isRunning && !_isBreakTime) {
          _showLemonade = true;
          notifyListeners();
        }
      });
    } else {
      _showLemonade = true;
      notifyListeners();
    }
  }

  void _handleDrippingSound() {
    if (!_isBreakTime) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (_isRunning && !_isBreakTime && !_showLemonade) {
          _audioProvider.playDrippingSound();

          Timer.periodic(const Duration(milliseconds: 100), (timer) {
            if (_showLemonade || !_isRunning || _isBreakTime) {
              _audioProvider.stopDrippingSound();
              timer.cancel();
            }
          });
        }
      });
    }
  }
}
