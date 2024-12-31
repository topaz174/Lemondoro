import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundSelectionProvider with ChangeNotifier {
  late SharedPreferences _prefs;
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<String> _audioFiles = [];
  String _selectedAudioFile = '';
  bool _drippingSound = true; 

  String get selectedAudioFile => _selectedAudioFile;
  List<String> get audioFiles => _audioFiles;
  bool get isDrippingSoundEnabled => _drippingSound;

  static final SoundSelectionProvider _instance =
      SoundSelectionProvider._internal();

  factory SoundSelectionProvider() {
    return _instance;
  }

  SoundSelectionProvider._internal() {
    _initPrefs();
    fetchAudioFiles();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _drippingSound = _prefs.getBool('isDrippingSoundEnabled') ?? true;
  }

  Future<void> fetchAudioFiles() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final manifestMap = json.decode(manifestContent) as Map<String, dynamic>;

    _audioFiles = manifestMap.keys
        .where((String key) =>
            key.startsWith('assets/sound/alarm/') && key.endsWith('.wav'))
        .map((audioFile) {
      final fileName = audioFile.split('/').last;
      return fileName.substring(0, fileName.lastIndexOf('.'));
    }).toList();

    if (_audioFiles.isNotEmpty) {
      _selectedAudioFile =
          _prefs.getString('selectedAudioFile') ?? _audioFiles[0];
    }

    notifyListeners();
  }

  
  
  void playDrippingSound() async {
    if (_drippingSound) {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop); 
      await _audioPlayer.play(AssetSource('sound/Drip.wav')); 
    }
  }

  void stopDrippingSound() async {
    await _audioPlayer.stop(); 
    await _audioPlayer.setReleaseMode(ReleaseMode.release); 
  }

  void toggleDrippingSound(bool isEnabled) {
    _drippingSound = isEnabled;
    _prefs.setBool('isDrippingSoundEnabled', isEnabled);
    notifyListeners();
  }

  void playSlurpingSound() async {
    await _audioPlayer.play(AssetSource('sound/Slurp.wav'));
  }

  void playSqueezeSound() async {
    await _audioPlayer.play(AssetSource('sound/Squeeze.wav'));
  }

  void setSelectedAudioFile(String newValue) {
    _selectedAudioFile = newValue;
    _prefs.setString('selectedAudioFile', _selectedAudioFile);
    notifyListeners();
  }

  void playSelectedAudio() async {
    await _audioPlayer.play(AssetSource('sound/alarm/$_selectedAudioFile.wav'));
  }
}
