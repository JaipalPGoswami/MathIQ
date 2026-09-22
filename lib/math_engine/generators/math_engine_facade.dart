import 'dart:math';
import '../models/math_problem.dart';
import '../models/difficulty_level.dart';
import '../validators/question_validator.dart';
import 'addition_generator.dart';
import 'subtraction_generator.dart';
import 'multiplication_generator.dart';
import 'division_generator.dart';
import 'fraction_generator.dart';
import 'geometry_generator.dart';
import 'measurement_generator.dart';
import 'time_generator.dart';
import 'money_generator.dart';
import 'pattern_generator.dart';
import 'word_problem_generator.dart';
import 'base_generator.dart';

class MathEngineFacade {
  static final MathEngineFacade _instance = MathEngineFacade._internal();
  factory MathEngineFacade() => _instance;
  MathEngineFacade._internal();

  final AdditionGenerator _addition = AdditionGenerator();
  final SubtractionGenerator _subtraction = SubtractionGenerator();
  final MultiplicationGenerator _multiplication = MultiplicationGenerator();
  final DivisionGenerator _division = DivisionGenerator();
  final FractionGenerator _fraction = FractionGenerator();
  final GeometryGenerator _geometry = GeometryGenerator();
  final MeasurementGenerator _measurement = MeasurementGenerator();
  final TimeGenerator _time = TimeGenerator();
  final MoneyGenerator _money = MoneyGenerator();
  final PatternGenerator _pattern = PatternGenerator();
  final WordProblemGenerator _wordProblem = WordProblemGenerator();

  BaseGenerator _getGenerator(String topicId) {
    final t = topicId.toLowerCase();
    if (t.contains('add')) return _addition;
    if (t.contains('sub')) return _subtraction;
    if (t.contains('mult')) return _multiplication;
    if (t.contains('div')) return _division;
    if (t.contains('fract')) return _fraction;
    if (t.contains('geom') || t.contains('shape')) return _geometry;
    if (t.contains('meas') || t.contains('perim')) return _measurement;
    if (t.contains('time')) return _time;
    if (t.contains('money')) return _money;
    if (t.contains('pattern')) return _pattern;
    if (t.contains('word') || t.contains('story')) return _wordProblem;
    // Default fallback to addition
    return _addition;
  }

  MathProblem generateProblem({
    required String topicId,
    required String grade,
    DifficultyLevel difficulty = DifficultyLevel.medium,
  }) {
    final generator = _getGenerator(topicId);

    // Validate generated problem with retry loop if needed
    for (int i = 0; i < 5; i++) {
      final problem = generator.generate(grade: grade, difficulty: difficulty);
      if (QuestionValidator.validate(problem)) {
        return problem;
      }
    }

    // Fallback safe problem
    return _addition.generate(grade: grade, difficulty: difficulty);
  }

  List<MathProblem> generateQuiz({
    required String grade,
    required int count,
    DifficultyLevel difficulty = DifficultyLevel.medium,
    String? topicId,
  }) {
    final List<MathProblem> list = [];
    final topics = [
      'addition',
      'subtraction',
      if (!grade.toUpperCase().contains('KG')) 'multiplication',
      if (grade.contains('2') || grade.contains('3')) 'division',
      if (grade.contains('2') || grade.contains('3')) 'fractions',
      'geometry',
      'time',
      'patterns',
      'word_problems',
    ];

    final random = Random();
    for (int i = 0; i < count; i++) {
      final targetTopic = topicId ?? topics[random.nextInt(topics.length)];
      list.add(generateProblem(topicId: targetTopic, grade: grade, difficulty: difficulty));
    }
    return list;
  }
}
