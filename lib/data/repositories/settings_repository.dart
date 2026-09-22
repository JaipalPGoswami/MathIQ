import '../database/app_database.dart';
import '../models/settings.dart';

class SettingsRepository {
  final AppDatabase _db;

  SettingsRepository({AppDatabase? db}) : _db = db ?? AppDatabase();

  AppSettings getSettings() => _db.getSettings();

  Future<void> updateSettings(AppSettings settings) async {
    await _db.saveSettings(settings);
  }

  bool verifyParentPin(String pin) {
    final s = getSettings();
    return s.parentPin == pin;
  }
}
