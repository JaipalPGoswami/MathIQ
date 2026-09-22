import 'dart:math';
import 'base_generator.dart';
import '../models/math_problem.dart';
import '../models/problem_type.dart';
import '../models/difficulty_level.dart';

class GeometryGenerator extends BaseGenerator {
  static const List<Map<String, dynamic>> shapes = [
    {'name': 'Triangle', 'sides': 3, 'corners': 3, 'emoji': '🔺'},
    {'name': 'Square', 'sides': 4, 'corners': 4, 'emoji': '🟩'},
    {'name': 'Rectangle', 'sides': 4, 'corners': 4, 'emoji': '▭'},
    {'name': 'Pentagon', 'sides': 5, 'corners': 5, 'emoji': '⬟'},
    {'name': 'Hexagon', 'sides': 6, 'corners': 6, 'emoji': '⬡'},
    {'name': 'Circle', 'sides': 0, 'corners': 0, 'emoji': '⚪'},
  ];

  @override
  MathProblem generate({required String grade, required DifficultyLevel difficulty}) {
    final shape = shapes[random.nextInt(shapes.length)];
    final isSidesQuestion = random.nextBool();

    String question;
    String correct;
    List<String> options;
    String explanation;

    if (isSidesQuestion && shape['name'] != 'Circle') {
      question = 'How many straight sides does a ${shape['name']} ${shape['emoji']} have?';
      correct = '${shape['sides']}';
      options = generateDistinctOptions(shape['sides'] as int, 4, min: 0, max: 8);
      explanation = 'A ${shape['name']} has ${shape['sides']} sides and ${shape['corners']} corners!';
    } else {
      question = 'Which shape has ${shape['sides']} sides? ${shape['emoji']}';
      correct = shape['name'] as String;
      final Set<String> names = {correct};
      for (final s in shapes) {
        if (names.length < 4 && s['name'] != correct) {
          names.add(s['name'] as String);
        }
      }
      options = names.toList()..shuffle(random);
      explanation = 'A ${shape['name']} has ${shape['sides']} sides!';
    }

    return MathProblem(
      topicId: 'geometry',
      grade: grade,
      difficulty: difficulty,
      problemType: ProblemType.multipleChoice,
      questionText: question,
      correctAnswer: correct,
      options: options,
      explanation: explanation,
    );
  }
}
