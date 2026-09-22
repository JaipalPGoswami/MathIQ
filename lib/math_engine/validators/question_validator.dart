import '../models/math_problem.dart';

class QuestionValidator {
  static bool validate(MathProblem problem) {
    if (problem.questionText.trim().isEmpty) return false;
    if (problem.correctAnswer.trim().isEmpty) return false;

    // Validate options exist and contain the correct answer
    if (problem.options.isEmpty) return false;
    if (!problem.options.contains(problem.correctAnswer)) return false;

    // Validate distinct options
    final unique = problem.options.toSet();
    if (unique.length != problem.options.length) return false;

    // Visual data count checks (if present)
    if (problem.visualData != null) {
      if (problem.visualData!.countA < 0 || problem.visualData!.countB < 0) {
        return false;
      }
    }

    return true;
  }
}
