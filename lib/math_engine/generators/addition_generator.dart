import 'dart:math';
import 'base_generator.dart';
import '../models/math_problem.dart';
import '../models/problem_type.dart';
import '../models/difficulty_level.dart';
import '../models/visual_item.dart';

class AdditionGenerator extends BaseGenerator {
  @override
  MathProblem generate({required String grade, required DifficultyLevel difficulty}) {
    int a, b;
    bool showVisuals = false;
    VisualType vType = VisualType.apple;

    if (grade.toUpperCase().contains('KG')) {
      showVisuals = true;
      if (difficulty == DifficultyLevel.easy) {
        a = random.nextInt(3) + 1; // 1-3
        b = random.nextInt(3) + 1; // 1-3
      } else {
        a = random.nextInt(5) + 1; // 1-5
        b = random.nextInt(5) + 1; // 1-5
      }
      final types = [VisualType.apple, VisualType.star, VisualType.balloon];
      vType = types[random.nextInt(types.length)];
    } else if (grade.contains('1')) {
      if (difficulty == DifficultyLevel.easy) {
        a = random.nextInt(9) + 1;
        b = random.nextInt(9) + 1;
      } else if (difficulty == DifficultyLevel.medium) {
        a = random.nextInt(15) + 5;
        b = random.nextInt(15) + 5;
      } else {
        a = random.nextInt(40) + 10;
        b = random.nextInt(40) + 10;
      }
    } else if (grade.contains('2')) {
      if (difficulty == DifficultyLevel.easy) {
        a = random.nextInt(40) + 10;
        b = random.nextInt(40) + 10;
      } else if (difficulty == DifficultyLevel.medium) {
        a = random.nextInt(80) + 20;
        b = random.nextInt(80) + 20;
      } else {
        a = random.nextInt(200) + 100;
        b = random.nextInt(200) + 100;
      }
    } else {
      // Grade 3
      if (difficulty == DifficultyLevel.easy) {
        a = random.nextInt(200) + 100;
        b = random.nextInt(200) + 100;
      } else if (difficulty == DifficultyLevel.medium) {
        a = random.nextInt(500) + 200;
        b = random.nextInt(500) + 200;
      } else {
        a = random.nextInt(2000) + 1000;
        b = random.nextInt(2000) + 1000;
      }
    }

    final sum = a + b;
    final options = generateDistinctOptions(sum, 4, min: 0, max: sum + 20);

    return MathProblem(
      topicId: 'addition',
      grade: grade,
      difficulty: difficulty,
      problemType: showVisuals ? ProblemType.visualCount : ProblemType.multipleChoice,
      questionText: '$a + $b = ?',
      correctAnswer: '$sum',
      options: options,
      explanation: 'When we add $a and $b together, we get $sum! You can count: start at $a and add $b more.',
      visualData: showVisuals
          ? VisualData(
              type: vType,
              countA: a,
              countB: b,
              operation: '+',
            )
          : null,
    );
  }
}
