import 'package:flutter_test/flutter_test.dart';
import 'package:math_facts_ai/math_engine/adaptive/mastery_calculator.dart';
import 'package:math_facts_ai/math_engine/adaptive/adaptive_engine.dart';
import 'package:math_facts_ai/math_engine/adaptive/xp_system.dart';
import 'package:math_facts_ai/data/models/mastery.dart';
import 'package:math_facts_ai/math_engine/models/difficulty_level.dart';
import 'package:math_facts_ai/ai/safety/child_safety_filter.dart';

void main() {
  group('Adaptive Engine & Progression Tests', () {
    test('Mastery calculation tiers', () {
      expect(MasteryCalculator.calculate(totalAttempts: 1, correctAnswers: 0), equals(MasteryLevel.beginner));
      expect(MasteryCalculator.calculate(totalAttempts: 5, correctAnswers: 2), equals(MasteryLevel.learning));
      expect(MasteryCalculator.calculate(totalAttempts: 6, correctAnswers: 4), equals(MasteryLevel.developing));
      expect(MasteryCalculator.calculate(totalAttempts: 8, correctAnswers: 7), equals(MasteryLevel.strong));
      expect(MasteryCalculator.calculate(totalAttempts: 12, correctAnswers: 12), equals(MasteryLevel.mastered));
    });

    test('Adaptive Difficulty Stepping', () {
      // 3 correct in a row -> Hard
      final highAcc = AdaptiveEngine.determineNextDifficulty(
        currentMastery: null,
        recentAttempts: [true, true, true],
      );
      expect(highAcc, equals(DifficultyLevel.hard));

      // Struggling -> Easy
      final lowAcc = AdaptiveEngine.determineNextDifficulty(
        currentMastery: null,
        recentAttempts: [false, false, true, false],
      );
      expect(lowAcc, equals(DifficultyLevel.easy));
    });

    test('XP and Level Calculation', () {
      expect(XpSystem.levelForXp(0), equals(1));
      expect(XpSystem.levelForXp(99), equals(1));
      expect(XpSystem.levelForXp(100), equals(2));
      expect(XpSystem.levelForXp(350), equals(4));

      final quizXp = XpSystem.forQuizCompleted(totalQuestions: 10, correctAnswers: 10);
      expect(quizXp, greaterThan(50));
    });

    test('Child Safety Filter blocks PII and unsafe prompts', () {
      expect(ChildSafetyFilter.isInputSafe('What is 2 + 2?'), isTrue);
      expect(ChildSafetyFilter.isInputSafe('My email is test@example.com'), isFalse);
      expect(ChildSafetyFilter.isInputSafe('My phone is 555-123-4567'), isFalse);
      expect(ChildSafetyFilter.isInputSafe('Tell me your password'), isFalse);
    });
  });
}
