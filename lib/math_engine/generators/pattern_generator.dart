import 'dart:math';
import 'base_generator.dart';
import '../models/math_problem.dart';
import '../models/problem_type.dart';
import '../models/difficulty_level.dart';

class PatternGenerator extends BaseGenerator {
  @override
  MathProblem generate({required String grade, required DifficultyLevel difficulty}) {
    if (grade.toUpperCase().contains('KG')) {
      // Visual shape / color pattern: Red, Blue, Red, Blue, ?
      final patterns = [
        {'seq': '🔴, 🔵, 🔴, 🔵, ?', 'c': '🔴', 'opts': ['🔴', '🔵', '⭐', '🟩']},
        {'seq': '⭐, 🌙, ⭐, 🌙, ?', 'c': '⭐', 'opts': ['⭐', '🌙', '☀️', '☁️']},
        {'seq': '🍎, 🍌, 🍎, 🍌, ?', 'c': '🍎', 'opts': ['🍎', '🍌', '🍇', '🍊']},
        {'seq': '🔺, 🟩, 🔺, 🟩, ?', 'c': '🔺', 'opts': ['🔺', '🟩', '⚪', '🔷']},
      ];
      final p = patterns[random.nextInt(patterns.length)];
      final seq = p['seq'] as String;
      final correct = p['c'] as String;
      final options = List<String>.from(p['opts'] as List)..shuffle(random);

      return MathProblem(
        topicId: 'patterns',
        grade: grade,
        difficulty: difficulty,
        problemType: ProblemType.multipleChoice,
        questionText: 'What comes next in the pattern? $seq',
        correctAnswer: correct,
        options: options,
        explanation: 'The pattern repeats! After ${seq.split(', ')[3]} comes $correct.',
      );
    } else {
      // Number sequence pattern
      final step = random.nextBool() ? 2 : (random.nextBool() ? 5 : 10);
      final start = random.nextInt(10) + 1;
      final s1 = start;
      final s2 = s1 + step;
      final s3 = s2 + step;
      final s4 = s3 + step; // target
      final s5 = s4 + step;

      final correct = '$s4';
      final options = generateDistinctOptions(s4, 4, min: 1, max: s5 + 20);

      return MathProblem(
        topicId: 'patterns',
        grade: grade,
        difficulty: difficulty,
        problemType: ProblemType.missingNumber,
        questionText: 'Find the missing number in the pattern: $s1, $s2, $s3, __, $s5',
        correctAnswer: correct,
        options: options,
        explanation: 'We are counting by $step! $s3 + $step = $s4.',
      );
    }
  }
}
