import 'dart:math';
import 'base_generator.dart';
import '../models/math_problem.dart';
import '../models/problem_type.dart';
import '../models/difficulty_level.dart';

class MoneyGenerator extends BaseGenerator {
  @override
  MathProblem generate({required String grade, required DifficultyLevel difficulty}) {
    if (grade.toUpperCase().contains('KG') || grade.contains('1')) {
      final coins = [
        {'name': 'Penny', 'value': 1, 'symbol': '1¢'},
        {'name': 'Nickel', 'value': 5, 'symbol': '5¢'},
        {'name': 'Dime', 'value': 10, 'symbol': '10¢'},
        {'name': 'Quarter', 'value': 25, 'symbol': '25¢'},
      ];
      final coin = coins[random.nextInt(coins.length)];
      final correct = coin['symbol'] as String;

      final Set<String> opts = {correct};
      for (final c in coins) {
        opts.add(c['symbol'] as String);
      }
      final options = opts.toList()..shuffle(random);

      return MathProblem(
        topicId: 'money',
        grade: grade,
        difficulty: difficulty,
        problemType: ProblemType.multipleChoice,
        questionText: 'How much is a ${coin['name']} worth? 🪙',
        correctAnswer: correct,
        options: options,
        explanation: 'A ${coin['name']} is worth ${coin['value']} cents ($correct)!',
      );
    } else {
      // Grade 2/3: Buying toys and calculating change
      final itemPrice = random.nextInt(15) + 5; // \$5 to \$20
      final paid = 20;
      final change = paid - itemPrice;

      final options = generateDistinctOptions(change, 4, min: 1, max: 20);

      return MathProblem(
        topicId: 'money',
        grade: grade,
        difficulty: difficulty,
        problemType: ProblemType.multipleChoice,
        questionText: 'A toy costs \$$itemPrice. You pay with a \$20 bill. How much change do you get back?',
        correctAnswer: '$change',
        options: options,
        explanation: '\$20 - \$$itemPrice = \$$change change!',
      );
    }
  }
}
