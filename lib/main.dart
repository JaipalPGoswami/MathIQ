import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'data/database/app_database.dart';
import 'core/audio/tts_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations for phones and tablets
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize offline local database
  await AppDatabase().init();

  // Pre-initialize TTS service
  await TtsService().init();

  runApp(
    const ProviderScope(
      child: MathFactsApp(),
    ),
  );
}
