import 'dart:math';
import 'base_generator.dart';
import '../models/math_problem.dart';
import '../models/problem_type.dart';
import '../models/difficulty_level.dart';
import '../models/visual_item.dart';

class TimeGenerator extends BaseGenerator {
  @override
  MathProblem generate({required String grade, required DifficultyLevel difficulty}) {
    int hour = random.nextInt(12) + 1; // 1-12
    int minute = 0;

    if (grade.toUpperCase().contains('KG') || grade.contains('1')) {
      // Only o'clock or half past
      minute = random.nextBool() ? 0 : 30;
    } else if (grade.contains('2')) {
      // 0, 15, 30, 45
      final minutes = [0, 15, 30, 45];
      minute = minutes[random.nextInt(minutes.length)];
    } else {
      // Multiples of 5
      minute = (random.nextInt(12)) * 5;
    }

    final minStr = minute.toString().padLeft(2, '0');
    final correct = '$hour:$minStr';

    final Set<String> opts = {correct};
    while (opts.length < 4) {
      final fakeHour = random.nextInt(12) + 1;
      final fakeMin = (random.nextInt(4) * 15).toString().padLeft(2, '0');
      final fake = '$fakeHour:$fakeMin';
      if (fake != correct) opts.add(fake);
    }
    final options = opts.toList()..shuffle(random);

    return MathProblem(
      topicId: 'time',
      grade: grade,
      difficulty: difficulty,
      problemType: ProblemType.multipleChoice,
      questionText: 'What time does the clock show? ⏰',
      correctAnswer: correct,
      options: options,
      explanation: 'The short hand points towards $hour and the long hand points to $minute minutes, so it is $correct!',
      visualData: VisualData(
        type: VisualType.clock,
        countA: hour,
        countB: minute,
        extraData: {'hour': hour, 'minute': minute},
      ),
    );
  }
}
