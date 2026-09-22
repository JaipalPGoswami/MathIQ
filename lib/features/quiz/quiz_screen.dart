import 'dart:async';
import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/dimensions.dart';
import '../../core/audio/audio_service.dart';
import '../../data/repositories/student_repository.dart';
import '../../math_engine/models/math_problem.dart';
import '../../math_engine/generators/math_engine_facade.dart';
import '../../widgets/buttons/kid_button.dart';
import 'quiz_results_screen.dart';

class QuizScreen extends StatefulWidget {
  final String? topicId;
  final String? topicName;

  const QuizScreen({super.key, this.topicId, this.topicName});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final StudentRepository _studentRepo = StudentRepository();
  final MathEngineFacade _engine = MathEngineFacade();

  int _selectedCount = 5;
  bool _quizStarted = false;
  List<MathProblem> _problems = [];
  int _currentIndex = 0;
  int _score = 0;
  final List<Map<String, dynamic>> _mistakes = [];

  Timer? _timer;
  int _secondsElapsed = 0;

  void _startQuiz() {
    final s = _studentRepo.getCurrentStudent();
    final grade = s?.grade ?? 'Grade 1';

    _problems = _engine.generateQuiz(
      grade: grade,
      count: _selectedCount,
      topicId: widget.topicId,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _secondsElapsed++);
    });

    setState(() {
      _quizStarted = true;
      _currentIndex = 0;
      _score = 0;
      _mistakes.clear();
      _secondsElapsed = 0;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _answerQuestion(String candidate) {
    final problem = _problems[_currentIndex];
    final isCorrect = problem.isCorrect(candidate);

    if (isCorrect) {
      _score++;
      AudioService().playCorrect();
    } else {
      AudioService().playIncorrect();
      _mistakes.add({
        'question': problem.questionText,
        'yourAnswer': candidate,
        'correctAnswer': problem.correctAnswer,
        'explanation': problem.explanation,
      });
    }

    if (_currentIndex < _problems.length - 1) {
      setState(() => _currentIndex++);
    } else {
      _timer?.cancel();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => QuizResultsScreen(
            totalQuestions: _problems.length,
            correctAnswers: _score,
            mistakes: _mistakes,
            secondsElapsed: _secondsElapsed,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_quizStarted) {
      return _buildQuizSetup();
    }

    final problem = _problems[_currentIndex];
    final progress = (_currentIndex + 1) / _problems.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topicName ?? 'Math Quiz 🏆'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '⏱️ ${_secondsElapsed}s',
                style: AppTypography.titleMedium.copyWith(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.p20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Question ${_currentIndex + 1} of ${_problems.length}', style: AppTypography.titleMedium),
                  Text('Score: $_score ⭐', style: AppTypography.titleMedium.copyWith(color: AppColors.warmAmber)),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
                ),
              ),
              const SizedBox(height: 32),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                  border: Border.all(color: AppColors.cardBorder, width: 2),
                ),
                child: Text(
                  problem.questionText,
                  style: AppTypography.displayMedium.copyWith(fontSize: 32),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),

              Column(
                children: problem.options.map((opt) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: KidButton(
                      text: opt,
                      fontSize: 26,
                      color: AppColors.primaryBlue,
                      onPressed: () => _answerQuestion(opt),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizSetup() {
    return Scaffold(
      appBar: AppBar(title: const Text('Start Quiz 🏆')),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🏆', style: TextStyle(fontSize: 70)),
            const SizedBox(height: 16),
            Text('Ready for a Math Challenge?', style: AppTypography.displayMedium, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text('How many questions would you like to solve?', style: AppTypography.bodyLarge, textAlign: TextAlign.center),
            const SizedBox(height: 28),

            Row(
              children: [5, 10, 20].map((count) {
                final isSelected = count == _selectedCount;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedCount = count),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.warmAmber : Colors.white,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                          border: Border.all(
                            color: isSelected ? AppColors.warmAmber : AppColors.cardBorder,
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$count Qs',
                          style: AppTypography.titleMedium.copyWith(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),

            KidButton(
              text: 'Start Quiz! 🚀',
              color: AppColors.mintGreen,
              onPressed: _startQuiz,
            ),
          ],
        ),
      ),
    );
  }
}
