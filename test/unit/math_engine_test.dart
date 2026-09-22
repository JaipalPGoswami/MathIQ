import 'package:flutter_test/flutter_test.dart';
import 'package:math_facts_ai/math_engine/generators/math_engine_facade.dart';
import 'package:math_facts_ai/math_engine/models/difficulty_level.dart';
import 'package:math_facts_ai/math_engine/validators/question_validator.dart';

void main() {
  group('Math Engine Generators Test Suite', () {
    final engine = MathEngineFacade();

    test('AdditionGenerator generates valid math problems with options containing correct answer', () {
      for (int i = 0; i < 20; i++) {
        final problem = engine.generateProblem(
          topicId: 'addition',
          grade: 'KG',
          difficulty: DifficultyLevel.easy,
        );

        expect(QuestionValidator.validate(problem), isTrue);
        expect(problem.options.contains(problem.correctAnswer), isTrue);
        expect(problem.options.toSet().length, equals(problem.options.length));
        expect(problem.visualData, isNotNull);
      }
    });

    test('SubtractionGenerator produces non-negative results and distinct options', () {
      for (int i = 0; i < 20; i++) {
        final problem = engine.generateProblem(
          topicId: 'subtraction',
          grade: 'Grade 1',
          difficulty: DifficultyLevel.medium,
        );

        expect(QuestionValidator.validate(problem), isTrue);
        final ans = int.parse(problem.correctAnswer);
        expect(ans, greaterThanOrEqualTo(0));
      }
    });

    test('MultiplicationGenerator generates valid products across grades', () {
      for (int i = 0; i < 20; i++) {
        final problem = engine.generateProblem(
          topicId: 'multiplication',
          grade: 'Grade 2',
          difficulty: DifficultyLevel.medium,
        );

        expect(QuestionValidator.validate(problem), isTrue);
        final ans = int.parse(problem.correctAnswer);
        expect(ans, greaterThan(0));
      }
    });

    test('DivisionGenerator produces clean quotients without fractional remainders in basic mode', () {
      for (int i = 0; i < 20; i++) {
        final problem = engine.generateProblem(
          topicId: 'division',
          grade: 'Grade 3',
          difficulty: DifficultyLevel.medium,
        );

        expect(QuestionValidator.validate(problem), isTrue);
        final ans = int.parse(problem.correctAnswer);
        expect(ans, greaterThan(0));
      }
    });

    test('FractionGenerator generates valid pizza fractions and correct options', () {
      for (int i = 0; i < 15; i++) {
        final problem = engine.generateProblem(
          topicId: 'fractions',
          grade: 'Grade 2',
          difficulty: DifficultyLevel.easy,
        );

        expect(QuestionValidator.validate(problem), isTrue);
        expect(problem.correctAnswer.contains('/'), isTrue);
      }
    });

    test('Quiz generator produces expected number of valid problems', () {
      final quiz = engine.generateQuiz(grade: 'Grade 2', count: 10);
      expect(quiz.length, equals(10));
      for (final p in quiz) {
        expect(QuestionValidator.validate(p), isTrue);
      }
    });
  });
}
