import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  bool _soundEnabled = true;

  bool get isSoundEnabled => _soundEnabled;

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  void playCorrect() {
    if (!_soundEnabled) return;
    debugPrint('[AudioService] 🎵 Chime: Ding! Correct answer!');
  }

  void playIncorrect() {
    if (!_soundEnabled) return;
    debugPrint('[AudioService] 🎵 Gentle Boing: Let us try again.');
  }

  void playCheer() {
    if (!_soundEnabled) return;
    debugPrint('[AudioService] 🎵 Fanfare: Tada! Milestone or quiz completed!');
  }

  void playTap() {
    if (!_soundEnabled) return;
    debugPrint('[AudioService] 🎵 Pop: Button tapped.');
  }

  void playStar() {
    if (!_soundEnabled) return;
    debugPrint('[AudioService] 🎵 Twinkle: Star earned!');
  }
}
