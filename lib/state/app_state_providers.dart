import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/student.dart';
import '../data/models/topic.dart';
import '../data/models/mastery.dart';
import '../data/models/achievement.dart';
import '../data/models/settings.dart';
import '../data/repositories/student_repository.dart';
import '../data/repositories/curriculum_repository.dart';
import '../data/repositories/stats_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../ai/gemini_ai_service.dart';

// Repositories
final studentRepositoryProvider = Provider((ref) => StudentRepository());
final curriculumRepositoryProvider = Provider((ref) => CurriculumRepository());
final statsRepositoryProvider = Provider((ref) => StatsRepository());
final settingsRepositoryProvider = Provider((ref) => SettingsRepository());
final aiServiceProvider = Provider((ref) => GeminiAiService());

// Student State
class StudentNotifier extends StateNotifier<Student?> {
  final StudentRepository _repo;

  StudentNotifier(this._repo) : super(_repo.getCurrentStudent());

  Future<void> createStudent({
    required String name,
    required String grade,
    required int age,
    required String avatar,
  }) async {
    final s = await _repo.createStudent(
      name: name,
      grade: grade,
      age: age,
      avatar: avatar,
    );
    state = s;
  }

  Future<void> addXp(int xp) async {
    final s = await _repo.addXp(xp);
    state = s;
  }

  Future<void> setGrade(String grade) async {
    if (state != null) {
      final updated = state!.copyWith(grade: grade);
      await _repo.updateStudent(updated);
      state = updated;
    }
  }

  void refresh() {
    state = _repo.getCurrentStudent();
  }
}

final studentProvider = StateNotifierProvider<StudentNotifier, Student?>((ref) {
  return StudentNotifier(ref.watch(studentRepositoryProvider));
});

// Settings State
class SettingsNotifier extends StateNotifier<AppSettings> {
  final SettingsRepository _repo;

  SettingsNotifier(this._repo) : super(_repo.getSettings());

  Future<void> updateSettings(AppSettings settings) async {
    await _repo.updateSettings(settings);
    state = settings;
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier(ref.watch(settingsRepositoryProvider));
});

// Curriculum Provider
final curriculumProvider = Provider.family<List<Topic>, String>((ref, grade) {
  final repo = ref.watch(curriculumRepositoryProvider);
  return repo.getTopicsForGrade(grade);
});

// Mastery Provider
final masteryProvider = Provider<List<TopicMastery>>((ref) {
  final stats = ref.watch(statsRepositoryProvider);
  return stats.getAllMasteries();
});

// Achievements Provider
final achievementProvider = Provider<List<Achievement>>((ref) {
  final stats = ref.watch(statsRepositoryProvider);
  return stats.getAchievements();
});
