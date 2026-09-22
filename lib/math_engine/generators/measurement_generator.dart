import 'dart:math';
import 'base_generator.dart';
import '../models/math_problem.dart';
import '../models/problem_type.dart';
import '../models/difficulty_level.dart';

class MeasurementGenerator extends BaseGenerator {
  @override
  MathProblem generate({required String grade, required DifficultyLevel difficulty}) {
    if (grade.toUpperCase().contains('KG') || grade.contains('1')) {
      final items = [
        {'q': 'Which animal is usually taller?', 'c': 'Giraffe 🦒', 'w': ['Mouse 🐭', 'Frog 🐸', 'Ant 🐜']},
        {'q': 'Which object is heavier?', 'c': 'Elephant 🐘', 'w': ['Feather 🪶', 'Apple 🍎', 'Pencil ✏️']},
        {'q': 'Which container holds more water?', 'c': 'Bathtub 🛁', 'w': ['Teacup ☕', 'Spoon 🥄', 'Bottle cap 🧴']},
      ];
      final item = items[random.nextInt(items.length)];
      final correct = item['c'] as String;
      final wrong = List<String>.from(item['w'] as List);
      final options = [correct, ...wrong]..shuffle(random);

      return MathProblem(
        topicId: 'measurement',
        grade: grade,
        difficulty: difficulty,
        problemType: ProblemType.multipleChoice,
        questionText: item['q'] as String,
        correctAnswer: correct,
        options: options,
        explanation: '$correct is larger and holds more weight/size!',
      );
    } else {
      // Grade 2/3: Ruler measurement in cm
      final cm = random.nextInt(12) + 2;
      final options = generateDistinctOptions(cm, 4, min: 1, max: 20);

      return MathProblem(
        topicId: 'measurement',
        grade: grade,
        difficulty: difficulty,
        problemType: ProblemType.multipleChoice,
        questionText: 'A crayon starts at 0 cm on a ruler and ends at $cm cm. How long is the crayon?',
        correctAnswer: '$cm',
        options: options,
        explanation: 'From 0 cm to $cm cm on a ruler is exactly $cm cm long! 📏',
      );
    }
  }
}
