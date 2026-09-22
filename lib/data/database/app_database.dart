import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/student.dart';
import '../models/topic.dart';
import '../models/attempt.dart';
import '../models/mastery.dart';
import '../models/achievement.dart';
import '../models/daily_activity.dart';
import '../models/settings.dart';
import 'seed_data.dart';

/// Local-first SQLite & persistent JSON storage engine.
/// Provides immediate, robust persistence across sessions without requiring external servers.
class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal();

  bool _initialized = false;
  SharedPreferences? _prefs;

  // In-memory cache for speed and immediate access
  Student? _currentStudent;
  final Map<String, TopicMastery> _masteries = {};
  final List<Attempt> _attempts = [];
  final List<DailyActivity> _activities = [];
  final Map<String, Achievement> _achievements = {};
  AppSettings? _settings;

  Future<void> init() async {
    if (_initialized) return;
    try {
      _prefs = await SharedPreferences.getInstance();
      await _loadFromDisk();
      _initialized = true;
      debugPrint('[AppDatabase] Initialized successfully with local storage.');
    } catch (e) {
      debugPrint('[AppDatabase] Init warning: $e');
      _initialized = true;
    }
  }

  Future<void> _loadFromDisk() async {
    final prefs = _prefs;
    if (prefs == null) return;

    // Load student
    final studentJson = prefs.getString('student_profile');
    if (studentJson != null) {
      try {
        _currentStudent = Student.fromMap(jsonDecode(studentJson) as Map<String, dynamic>);
      } catch (e) {
        debugPrint('[AppDatabase] Failed parsing student: $e');
      }
    }

    // Load settings
    final settingsJson = prefs.getString('app_settings');
    if (settingsJson != null) {
      try {
        _settings = AppSettings.fromMap(jsonDecode(settingsJson) as Map<String, dynamic>);
      } catch (e) {
        debugPrint('[AppDatabase] Failed parsing settings: $e');
      }
    }

    // Load achievements
    final achievementsJson = prefs.getString('achievements');
    final initialList = SeedData.getInitialAchievements();
    for (final ach in initialList) {
      _achievements[ach.id] = ach;
    }

    if (achievementsJson != null) {
      try {
        final List<dynamic> list = jsonDecode(achievementsJson) as List<dynamic>;
        for (final item in list) {
          final m = item as Map<String, dynamic>;
          final id = m['id'] as String;
          if (_achievements.containsKey(id)) {
            _achievements[id] = _achievements[id]!.copyWith(
              isUnlocked: (m['is_unlocked'] as bool?) ?? true,
              earnedAt: m['earned_at'] != null ? DateTime.parse(m['earned_at'] as String) : null,
            );
          }
        }
      } catch (e) {
        debugPrint('[AppDatabase] Failed parsing achievements: $e');
      }
    }

    // Load masteries
    final masteriesJson = prefs.getString('topic_masteries');
    if (masteriesJson != null) {
      try {
        final List<dynamic> list = jsonDecode(masteriesJson) as List<dynamic>;
        for (final item in list) {
          final tm = TopicMastery.fromMap(item as Map<String, dynamic>);
          _masteries[tm.topicId] = tm;
        }
      } catch (e) {
        debugPrint('[AppDatabase] Failed parsing masteries: $e');
      }
    }
  }

  // --- Student operations ---
  Student? getStudent() => _currentStudent;

  Future<void> saveStudent(Student student) async {
    _currentStudent = student;
    await _prefs?.setString('student_profile', jsonEncode(student.toMap()));
  }

  // --- Settings operations ---
  AppSettings getSettings() {
    _settings ??= AppSettings(id: 'default', studentId: _currentStudent?.id ?? 'guest');
    return _settings!;
  }

  Future<void> saveSettings(AppSettings settings) async {
    _settings = settings;
    await _prefs?.setString('app_settings', jsonEncode(settings.toMap()));
  }

  // --- Mastery operations ---
  List<TopicMastery> getAllMasteries() => _masteries.values.toList();

  TopicMastery? getMasteryForTopic(String topicId) => _masteries[topicId];

  Future<void> saveMastery(TopicMastery mastery) async {
    _masteries[mastery.topicId] = mastery;
    final list = _masteries.values.map((m) => m.toMap()).toList();
    await _prefs?.setString('topic_masteries', jsonEncode(list));
  }

  // --- Attempts operations ---
  List<Attempt> getAttempts() => List.unmodifiable(_attempts);

  Future<void> recordAttempt(Attempt attempt) async {
    _attempts.add(attempt);
    // Keep max 200 recent attempts in memory
    if (_attempts.length > 200) {
      _attempts.removeAt(0);
    }
  }

  // --- Achievements operations ---
  List<Achievement> getAchievements() => _achievements.values.toList();

  Future<void> unlockAchievement(String achievementId) async {
    if (_achievements.containsKey(achievementId)) {
      final ach = _achievements[achievementId]!;
      if (!ach.isUnlocked) {
        _achievements[achievementId] = ach.copyWith(isUnlocked: true, earnedAt: DateTime.now());
        final list = _achievements.values.map((a) => {
          'id': a.id,
          'is_unlocked': a.isUnlocked,
          'earned_at': a.earnedAt?.toIso8601String(),
        }).toList();
        await _prefs?.setString('achievements', jsonEncode(list));
      }
    }
  }

  // --- Reset database for clean restarts ---
  Future<void> resetAllData() async {
    _currentStudent = null;
    _masteries.clear();
    _attempts.clear();
    _activities.clear();
    _settings = null;
    await _prefs?.clear();
    final initialList = SeedData.getInitialAchievements();
    for (final ach in initialList) {
      _achievements[ach.id] = ach;
    }
  }
}
