import '../database/app_database.dart';
import '../models/mastery.dart';
import '../models/achievement.dart';

class StatsRepository {
  final AppDatabase _db;

  StatsRepository({AppDatabase? db}) : _db = db ?? AppDatabase();

  List<TopicMastery> getAllMasteries() => _db.getAllMasteries();

  List<Achievement> getAchievements() => _db.getAchievements();

  int getTotalQuestionsSolved() {
    return _db.getAttempts().length;
  }

  int getCorrectQuestionsSolved() {
    return _db.getAttempts().where((a) => a.isCorrect).length;
  }

  double getOverallAccuracy() {
    final total = getTotalQuestionsSolved();
    if (total == 0) return 0.0;
    return getCorrectQuestionsSolved() / total;
  }

  Future<void> checkAndUnlockAchievements({
    required int totalCorrect,
    required int streak,
    required int completedQuizzes,
    double? lastQuizAccuracy,
  }) async {
    final achievements = _db.getAchievements();
    for (final ach in achievements) {
      if (ach.isUnlocked) continue;

      bool shouldUnlock = false;
      if (ach.conditionType == 'correct_count' && totalCorrect >= ach.conditionValue) {
        shouldUnlock = true;
      } else if (ach.conditionType == 'streak' && streak >= ach.conditionValue) {
        shouldUnlock = true;
      } else if (ach.conditionType == 'quiz_count' && completedQuizzes >= ach.conditionValue) {
        shouldUnlock = true;
      } else if (ach.conditionType == 'accuracy_quiz' &&
          lastQuizAccuracy != null &&
          (lastQuizAccuracy * 100) >= ach.conditionValue) {
        shouldUnlock = true;
      }

      if (shouldUnlock) {
        await _db.unlockAchievement(ach.id);
      }
    }
  }
}
