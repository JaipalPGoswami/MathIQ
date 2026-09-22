import '../../core/constants/app_constants.dart';

class XpSystem {
  /// Anti-exploit: Cap max XP earned within a single minute to avoid rapid auto-clicking
  static int sanitizeXpReward({
    required int rawXp,
    required int sessionMinutes,
    required int alreadyEarnedInSession,
  }) {
    final maxAllowedInSession = (sessionMinutes + 1) * 150;
    if (alreadyEarnedInSession + rawXp > maxAllowedInSession) {
      return 1; // Minimum symbolic token
    }
    return rawXp;
  }

  /// XP for answering a practice question
  static int forPracticeAnswer({required bool isCorrect}) {
    return isCorrect ? AppConstants.xpCorrectAnswer : 1;
  }

  /// XP for completing a quiz
  static int forQuizCompleted({
    required int totalQuestions,
    required int correctAnswers,
  }) {
    final accuracy = totalQuestions > 0 ? (correctAnswers / totalQuestions) : 0.0;
    int base = correctAnswers * AppConstants.xpCorrectAnswer;
    if (accuracy >= 1.0) {
      base += AppConstants.xpPerfectQuiz;
    } else if (accuracy >= 0.8) {
      base += 15;
    }
    return base;
  }

  /// Level calculation
  static int levelForXp(int xp) {
    return (xp / 100).floor() + 1;
  }

  static double levelProgress(int xp) {
    return (xp % 100) / 100.0;
  }
}
