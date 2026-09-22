import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/dimensions.dart';
import '../../core/constants/app_constants.dart';
import '../../core/audio/audio_service.dart';
import '../../core/audio/tts_service.dart';
import '../../core/utils/confetti_helper.dart';
import '../../data/repositories/student_repository.dart';
import '../../data/repositories/practice_repository.dart';
import '../../data/repositories/stats_repository.dart';
import '../../math_engine/models/math_problem.dart';
import '../../math_engine/models/problem_type.dart';
import '../../math_engine/models/difficulty_level.dart';
import '../../math_engine/generators/math_engine_facade.dart';
import '../../math_engine/adaptive/adaptive_engine.dart';
import '../../widgets/visuals/math_illustration.dart';
import '../../widgets/visuals/analog_clock_widget.dart';
import '../../widgets/visuals/pizza_fraction_widget.dart';
import '../../widgets/buttons/kid_button.dart';
import 'widgets/number_pad.dart';

class PracticeScreen extends StatefulWidget {
  final String topicId;
  final String topicName;

  const PracticeScreen({
    super.key,
    required this.topicId,
    required this.topicName,
  });

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final StudentRepository _studentRepo = StudentRepository();
  final PracticeRepository _practiceRepo = PracticeRepository();
  final StatsRepository _statsRepo = StatsRepository();
  final MathEngineFacade _engine = MathEngineFacade();

  late ConfettiController _confetti;
  late MathProblem _currentProblem;
  String _typedAnswer = '';
  final List<bool> _recentAttempts = [];
  DifficultyLevel _currentDifficulty = DifficultyLevel.medium;
  bool _answered = false;
  bool _isCorrect = false;
  String? _hintText;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiHelper.createController();
    _loadNextQuestion();
  }

  @override
  void dispose() {
    _confetti.dispose();
    TtsService().stop();
    super.dispose();
  }

  void _loadNextQuestion() {
    final student = _studentRepo.getCurrentStudent();
    final grade = student?.grade ?? 'Grade 1';

    _currentDifficulty = AdaptiveEngine.determineNextDifficulty(
      currentMastery: null,
      recentAttempts: _recentAttempts,
    );

    setState(() {
      _currentProblem = _engine.generateProblem(
        topicId: widget.topicId,
        grade: grade,
        difficulty: _currentDifficulty,
      );
      _typedAnswer = '';
      _answered = false;
      _isCorrect = false;
      _hintText = null;
    });

    TtsService().speak(_currentProblem.questionText);
  }

  Future<void> _submitAnswer(String answer) async {
    if (_answered) return;

    final student = _studentRepo.getCurrentStudent();
    if (student == null) return;

    final isCorrect = _currentProblem.isCorrect(answer);
    _recentAttempts.add(isCorrect);
    if (_recentAttempts.length > 5) _recentAttempts.removeAt(0);

    setState(() {
      _answered = true;
      _isCorrect = isCorrect;
    });

    if (isCorrect) {
      AudioService().playCorrect();
      _confetti.play();
      await _studentRepo.addXp(AppConstants.xpCorrectAnswer);
    } else {
      AudioService().playIncorrect();
    }

    await _practiceRepo.recordAnswer(
      studentId: student.id,
      questionId: _currentProblem.id,
      topicId: widget.topicId,
      answer: answer,
      isCorrect: isCorrect,
      responseTimeMs: 2500,
    );

    // Check achievement unlock
    final totalCorrect = _statsRepo.getCorrectQuestionsSolved();
    await _statsRepo.checkAndUnlockAchievements(
      totalCorrect: totalCorrect,
      streak: student.streak,
      completedQuizzes: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topicName),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, color: AppColors.primaryBlue, size: 28),
            onPressed: () => TtsService().speak(_currentProblem.questionText),
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.p20),
              child: Column(
                children: [
                  // Visual illustration (if present)
                  if (_currentProblem.visualData != null) ...[
                    if (_currentProblem.visualData!.type == VisualType.clock)
                      AnalogClockWidget(
                        hour: _currentProblem.visualData!.countA,
                        minute: _currentProblem.visualData!.countB,
                      )
                    else if (_currentProblem.visualData!.type == VisualType.pizza)
                      PizzaFractionWidget(
                        highlightedSlices: _currentProblem.visualData!.countA,
                        totalSlices: _currentProblem.visualData!.countB,
                      )
                    else
                      MathIllustration(visualData: _currentProblem.visualData!),
                    const SizedBox(height: 18),
                  ],

                  // Question Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                      border: Border.all(color: AppColors.cardBorder, width: 2),
                    ),
                    child: Text(
                      _currentProblem.questionText,
                      style: AppTypography.displayMedium.copyWith(
                        fontSize: 32,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Hint Button / Hint Display
                  if (_hintText != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.amberLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _hintText!,
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.warmAmber),
                      ),
                    )
                  else if (!_answered)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        icon: const Icon(Icons.lightbulb_outline_rounded, color: AppColors.warmAmber),
                        label: Text('Need a hint? 💡', style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                        onPressed: () {
                          setState(() {
                            _hintText = _currentProblem.explanation;
                          });
                          TtsService().speak(_currentProblem.explanation);
                        },
                      ),
                    ),

                  // Options or Keypad Input
                  if (!_answered) ...[
                    Column(
                      children: _currentProblem.options.map((opt) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: KidButton(
                            text: opt,
                            fontSize: 26,
                            color: AppColors.primaryBlue,
                            onPressed: () => _submitAnswer(opt),
                          ),
                        );
                      }).toList(),
                    ),
                  ] else ...[
                    // Post-answer Feedback Card
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.p20),
                      decoration: BoxDecoration(
                        color: _isCorrect ? AppColors.greenLight : AppColors.pinkLight,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                        border: Border.all(
                          color: _isCorrect ? AppColors.mintGreen : AppColors.coralPink,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _isCorrect
                                ? AppConstants.praiseCorrect[0]
                                : AppConstants.encouragingIncorrect[0],
                            style: AppTypography.titleLarge.copyWith(
                              color: _isCorrect ? AppColors.emeraldGreen : AppColors.coralPink,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _currentProblem.explanation,
                            style: AppTypography.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 18),
                          KidButton(
                            text: 'Next Question ➜',
                            color: _isCorrect ? AppColors.mintGreen : AppColors.primaryBlue,
                            onPressed: _loadNextQuestion,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          ConfettiHelper.buildCelebrationConfetti(controller: _confetti),
        ],
      ),
    );
  }
}
