import 'dart:math';
import 'base_generator.dart';
import '../models/math_problem.dart';
import '../models/problem_type.dart';
import '../models/difficulty_level.dart';
import '../models/visual_item.dart';

class SubtractionGenerator extends BaseGenerator {
  @override
  MathProblem generate({required String grade, required DifficultyLevel difficulty}) {
    int a, b;
    bool showVisuals = false;

    if (grade.toUpperCase().contains('KG')) {
      showVisuals = true;
      if (difficulty == DifficultyLevel.easy) {
        a = random.nextInt(4) + 2; // 2-5
        b = random.nextInt(a - 1) + 1; // 1 to a-1
      } else {
        a = random.nextInt(6) + 4; // 4-9
        b = random.nextInt(a - 1) + 1;
      }
    } else if (grade.contains('1')) {
      if (difficulty == DifficultyLevel.easy) {
        a = random.nextInt(9) + 5;
        b = random.nextInt(a);
      } else {
        a = random.nextInt(30) + 15;
        b = random.nextInt(15) + 1;
      }
    } else if (grade.contains('2')) {
      if (difficulty == DifficultyLevel.easy) {
        a = random.nextInt(50) + 30;
        b = random.nextInt(25) + 5;
      } else {
        a = random.nextInt(200) + 100;
        b = random.nextInt(80) + 20;
      }
    } else {
      // Grade 3
      a = random.nextInt(800) + 200;
      b = random.nextInt(a - 50) + 20;
    }

    final diff = a - b;
    final options = generateDistinctOptions(diff, 4, min: 0, max: a);

    return MathProblem(
      topicId: 'subtraction',
      grade: grade,
      difficulty: difficulty,
      problemType: showVisuals ? ProblemType.visualCount : ProblemType.multipleChoice,
      questionText: '$a - $b = ?',
      correctAnswer: '$diff',
      options: options,
      explanation: 'Start with $a items and take away $b of them. That leaves $diff!',
      visualData: showVisuals
          ? VisualData(
              type: VisualType.cookie,
              countA: a,
              countB: b,
              operation: '-',
            )
          : null,
    );
  }
}
