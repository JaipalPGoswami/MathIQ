import '../models/difficulty_level.dart';
import '../../data/models/mastery.dart';

class AdaptiveEngine {
  /// Determines the next difficulty level based on recent performance
  static DifficultyLevel determineNextDifficulty({
    required TopicMastery? currentMastery,
    required List<bool> recentAttempts, // Last 3-5 attempts
  }) {
    if (recentAttempts.isEmpty) {
      return currentMastery?.level == MasteryLevel.strong ||
              currentMastery?.level == MasteryLevel.mastered
          ? DifficultyLevel.hard
          : DifficultyLevel.medium;
    }

    final recentCorrect = recentAttempts.where((c) => c).length;
    final recentAccuracy = recentCorrect / recentAttempts.length;

    // If child got 3 in a row correct, step up difficulty
    if (recentAccuracy >= 0.8) {
      return DifficultyLevel.hard;
    } else if (recentAccuracy <= 0.4) {
      // Struggling, ease difficulty to restore confidence
      return DifficultyLevel.easy;
    } else {
      return DifficultyLevel.medium;
    }
  }

  /// Whether a child requires a visual hint after mistakes
  static bool shouldOfferVisualHint(List<bool> recentAttempts) {
    if (recentAttempts.length < 2) return false;
    // Two consecutive incorrect answers
    return !recentAttempts[recentAttempts.length - 1] &&
        !recentAttempts[recentAttempts.length - 2];
  }
}
