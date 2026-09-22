import 'dart:math';
import 'base_generator.dart';
import '../models/math_problem.dart';
import '../models/problem_type.dart';
import '../models/difficulty_level.dart';

class DivisionGenerator extends BaseGenerator {
  @override
  MathProblem generate({required String grade, required DifficultyLevel difficulty}) {
    int divisor, quotient;

    if (grade.toUpperCase().contains('KG') || grade.contains('1')) {
      // Sharing equally between 2 or 3
      divisor = random.nextBool() ? 2 : 3;
      quotient = random.nextInt(4) + 1; // 1-4
    } else if (grade.contains('2')) {
      final divisors = [2, 3, 4, 5, 10];
      divisor = divisors[random.nextInt(divisors.length)];
      quotient = random.nextInt(8) + 2;
    } else {
      // G3: up to 12
      divisor = random.nextInt(8) + 2; // 2-9
      quotient = random.nextInt(10) + 2; // 2-11
    }

    final dividend = divisor * quotient;
    final options = generateDistinctOptions(quotient, 4, min: 1, max: quotient + 10);

    return MathProblem(
      topicId: 'division',
      grade: grade,
      difficulty: difficulty,
      problemType: ProblemType.multipleChoice,
      questionText: '$dividend ÷ $divisor = ?',
      correctAnswer: '$quotient',
      options: options,
      explanation: 'Sharing $dividend equally into $divisor groups gives $quotient in each group! ($divisor × $quotient = $dividend)',
    );
  }
}
