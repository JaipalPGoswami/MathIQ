import '../../data/models/mastery.dart';

class MasteryCalculator {
  /// Calculates mastery level based on accuracy and attempt count
  static MasteryLevel calculate({
    required int totalAttempts,
    required int correctAnswers,
  }) {
    if (totalAttempts == 0) return MasteryLevel.beginner;
    final accuracy = correctAnswers / totalAttempts;

    // Minimum 3 attempts to reach Learning, minimum 5 for Developing, 8 for Strong, 10 for Mastered
    if (accuracy >= 0.95 && totalAttempts >= 10) {
      return MasteryLevel.mastered;
    } else if (accuracy >= 0.80 && totalAttempts >= 6) {
      return MasteryLevel.strong;
    } else if (accuracy >= 0.60 && totalAttempts >= 4) {
      return MasteryLevel.developing;
    } else if (accuracy >= 0.40) {
      return MasteryLevel.learning;
    } else {
      return MasteryLevel.beginner;
    }
  }

  static double getAccuracyPercentage(int totalAttempts, int correctAnswers) {
    if (totalAttempts == 0) return 0.0;
    return (correctAnswers / totalAttempts) * 100.0;
  }
}
