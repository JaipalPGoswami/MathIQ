import 'dart:math';
import 'base_generator.dart';
import '../models/math_problem.dart';
import '../models/problem_type.dart';
import '../models/difficulty_level.dart';
import '../models/visual_item.dart';

class MultiplicationGenerator extends BaseGenerator {
  @override
  MathProblem generate({required String grade, required DifficultyLevel difficulty}) {
    int a, b;
    bool isArrayQuestion = false;

    if (grade.toUpperCase().contains('KG') || grade.contains('1')) {
      // G1: 2, 5, 10 tables or equal groups
      final tables = [2, 5, 10];
      a = tables[random.nextInt(tables.length)];
      b = random.nextInt(5) + 1;
      isArrayQuestion = true;
    } else if (grade.contains('2')) {
      // G2: 2 to 10
      a = random.nextInt(9) + 2; // 2-10
      b = random.nextInt(9) + 2; // 2-10
    } else {
      // G3: 2 to 12
      a = random.nextInt(11) + 2; // 2-12
      b = random.nextInt(11) + 2; // 2-12
    }

    final product = a * b;
    final options = generateDistinctOptions(product, 4, min: 1, max: product + 24);

    return MathProblem(
      topicId: 'multiplication',
      grade: grade,
      difficulty: difficulty,
      problemType: ProblemType.multipleChoice,
      questionText: '$a × $b = ?',
      correctAnswer: '$product',
      options: options,
      explanation: '$a × $b means $a groups of $b! When we multiply, $a groups of $b make $product.',
      visualData: isArrayQuestion
          ? VisualData(
              type: VisualType.star,
              countA: a,
              countB: b,
              operation: '×',
            )
          : null,
    );
  }
}
