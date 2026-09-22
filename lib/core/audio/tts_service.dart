import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  FlutterTts? _flutterTts;
  bool _voiceEnabled = true;
  bool _isSpeaking = false;
  bool _isInitialized = false;

  bool get isVoiceEnabled => _voiceEnabled;
  bool get isSpeaking => _isSpeaking;

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      _flutterTts = FlutterTts();
      await _flutterTts?.setLanguage('en-US');
      await _flutterTts?.setSpeechRate(0.42); // Slightly slower for young children
      await _flutterTts?.setVolume(1.0);
      await _flutterTts?.setPitch(1.1); // Friendly, higher pitch

      _flutterTts?.setStartHandler(() {
        _isSpeaking = true;
      });

      _flutterTts?.setCompletionHandler(() {
        _isSpeaking = false;
      });

      _flutterTts?.setErrorHandler((msg) {
        _isSpeaking = false;
        debugPrint('[TtsService] Error: $msg');
      });

      _isInitialized = true;
    } catch (e) {
      debugPrint('[TtsService] Initialization fallback: $e');
    }
  }

  void setVoiceEnabled(bool enabled) {
    _voiceEnabled = enabled;
    if (!enabled) stop();
  }

  Future<void> speak(String text) async {
    if (!_voiceEnabled) return;
    try {
      if (!_isInitialized) await init();
      await stop();
      await _flutterTts?.speak(text);
    } catch (e) {
      debugPrint('[TtsService] Speak fallback: $text');
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts?.stop();
      _isSpeaking = false;
    } catch (e) {
      _isSpeaking = false;
    }
  }
}
