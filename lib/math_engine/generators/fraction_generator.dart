import 'dart:math';
import 'base_generator.dart';
import '../models/math_problem.dart';
import '../models/problem_type.dart';
import '../models/difficulty_level.dart';
import '../models/visual_item.dart';

class FractionGenerator extends BaseGenerator {
  @override
  MathProblem generate({required String grade, required DifficultyLevel difficulty}) {
    final denominators = (grade.contains('3')) ? [2, 3, 4, 6, 8] : [2, 3, 4];
    final den = denominators[random.nextInt(denominators.length)];
    final num = random.nextInt(den - 1) + 1;

    final correct = '$num/$den';
    final Set<String> opts = {correct};

    while (opts.length < 4) {
      final fakeDen = denominators[random.nextInt(denominators.length)];
      final fakeNum = random.nextInt(fakeDen) + 1;
      final fake = '$fakeNum/$fakeDen';
      if (fake != correct) {
        opts.add(fake);
      }
    }

    final optionsList = opts.toList()..shuffle(random);

    return MathProblem(
      topicId: 'fractions',
      grade: grade,
      difficulty: difficulty,
      problemType: ProblemType.multipleChoice,
      questionText: 'What fraction of the pizza is highlighted? ($num out of $den parts)',
      correctAnswer: correct,
      options: optionsList,
      explanation: 'The pizza has $den equal parts and $num parts are highlighted, so the fraction is $num/$den!',
      visualData: VisualData(
        type: VisualType.pizza,
        countA: num,
        countB: den,
        operation: '/',
      ),
    );
  }
}
