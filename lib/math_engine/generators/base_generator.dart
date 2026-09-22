import 'dart:math';
import '../models/math_problem.dart';
import '../models/difficulty_level.dart';

abstract class BaseGenerator {
  final Random random = Random();

  MathProblem generate({
    required String grade,
    required DifficultyLevel difficulty,
  });

  List<String> generateDistinctOptions(int correct, int count, {int min = 0, int max = 100}) {
    final Set<int> opts = {correct};
    int attempts = 0;
    while (opts.length < count && attempts < 50) {
      attempts++;
      final delta = random.nextInt(5) + 1;
      final candidate = random.nextBool() ? correct + delta : correct - delta;
      if (candidate >= min && candidate <= max && candidate != correct) {
        opts.add(candidate);
      }
    }

    // Fallback if not enough unique options
    while (opts.length < count) {
      final fallback = correct + opts.length;
      opts.add(fallback);
    }

    final list = opts.map((e) => e.toString()).toList();
    list.shuffle(random);
    return list;
  }
}
