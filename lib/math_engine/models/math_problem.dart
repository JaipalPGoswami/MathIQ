import 'package:uuid/uuid.dart';
import 'problem_type.dart';
import 'difficulty_level.dart';
import 'visual_item.dart';

class MathProblem {
  final String id;
  final String topicId;
  final String grade;
  final DifficultyLevel difficulty;
  final ProblemType problemType;
  final String questionText;
  final String correctAnswer;
  final List<String> options;
  final String explanation;
  final VisualData? visualData;

  MathProblem({
    String? id,
    required this.topicId,
    required this.grade,
    required this.difficulty,
    required this.problemType,
    required this.questionText,
    required this.correctAnswer,
    required this.options,
    required this.explanation,
    this.visualData,
  }) : id = id ?? const Uuid().v4();

  bool isCorrect(String candidate) {
    return candidate.trim().toLowerCase() == correctAnswer.trim().toLowerCase();
  }
}
