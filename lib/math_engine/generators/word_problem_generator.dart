import 'dart:math';
import 'base_generator.dart';
import '../models/math_problem.dart';
import '../models/problem_type.dart';
import '../models/difficulty_level.dart';

class WordProblemGenerator extends BaseGenerator {
  @override
  MathProblem generate({required String grade, required DifficultyLevel difficulty}) {
    final names = ['Leo', 'Maya', 'Aiden', 'Zara', 'Noah', 'Emma'];
    final name1 = names[random.nextInt(names.length)];
    final name2 = names[(names.indexOf(name1) + 1) % names.length];

    if (grade.toUpperCase().contains('KG') || grade.contains('1')) {
      final a = random.nextInt(5) + 2;
      final b = random.nextInt(4) + 1;
      final sum = a + b;
      final options = generateDistinctOptions(sum, 4, min: 1, max: sum + 6);

      return MathProblem(
        topicId: 'word_problems',
        grade: grade,
        difficulty: difficulty,
        problemType: ProblemType.multipleChoice,
        questionText: '$name1 has $a red apples 🍎. $name2 gives them $b more apples. How many apples does $name1 have now?',
        correctAnswer: '$sum',
        options: options,
        explanation: '$a + $b = $sum apples in total!',
      );
    } else {
      // Grade 2/3: 2-step or multiplication word problems
      final a = random.nextInt(6) + 3;
      final b = random.nextInt(4) + 2;
      final product = a * b;
      final options = generateDistinctOptions(product, 4, min: 1, max: product + 12);

      return MathProblem(
        topicId: 'word_problems',
        grade: grade,
        difficulty: difficulty,
        problemType: ProblemType.multipleChoice,
        questionText: '$name1 has $a boxes of colorful stickers. Each box contains $b stickers. How many stickers does $name1 have altogether?',
        correctAnswer: '$product',
        options: options,
        explanation: '$a boxes × $b stickers per box = $product stickers altogether!',
      );
    }
  }
}
