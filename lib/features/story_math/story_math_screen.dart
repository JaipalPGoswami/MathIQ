import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/dimensions.dart';
import '../../core/constants/app_constants.dart';
import '../../core/audio/tts_service.dart';
import '../../core/audio/audio_service.dart';
import '../../data/repositories/student_repository.dart';
import '../../math_engine/generators/math_engine_facade.dart';
import '../../math_engine/models/math_problem.dart';
import '../../widgets/buttons/kid_button.dart';

class StoryMathScreen extends StatefulWidget {
  const StoryMathScreen({super.key});

  @override
  State<StoryMathScreen> createState() => _StoryMathScreenState();
}

class _StoryMathScreenState extends State<StoryMathScreen> {
  final StudentRepository _studentRepo = StudentRepository();
  final MathEngineFacade _engine = MathEngineFacade();

  late MathProblem _storyProblem;
  bool _answered = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _loadNextStory();
  }

  void _loadNextStory() {
    final s = _studentRepo.getCurrentStudent();
    final grade = s?.grade ?? 'Grade 1';

    setState(() {
      _storyProblem = _engine.generateProblem(
        topicId: 'word_problems',
        grade: grade,
      );
      _answered = false;
      _isCorrect = false;
    });

    TtsService().speak(_storyProblem.questionText);
  }

  Future<void> _submitAnswer(String candidate) async {
    if (_answered) return;
    final isCorrect = _storyProblem.isCorrect(candidate);

    setState(() {
      _answered = true;
      _isCorrect = isCorrect;
    });

    if (isCorrect) {
      AudioService().playCorrect();
      await _studentRepo.addXp(AppConstants.xpCorrectAnswer);
    } else {
      AudioService().playIncorrect();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Math Adventures 📖'),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, color: AppColors.primaryBlue, size: 28),
            onPressed: () => TtsService().speak(_storyProblem.questionText),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.p20),
          child: Column(
            children: [
              // Illustration Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.greenLight, AppColors.tealLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                ),
                child: const Column(
                  children: [
                    Text('🌳 🍎 🐿️', style: TextStyle(fontSize: 48)),
                    SizedBox(height: 8),
                    Text('Real World Story Time', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Story Text
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                  border: Border.all(color: AppColors.cardBorder, width: 2),
                ),
                child: Text(
                  _storyProblem.questionText,
                  style: AppTypography.displayMedium.copyWith(fontSize: 24, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),

              // Answer Options
              if (!_answered) ...[
                Column(
                  children: _storyProblem.options.map((opt) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: KidButton(
                        text: opt,
                        fontSize: 24,
                        color: AppColors.primaryBlue,
                        onPressed: () => _submitAnswer(opt),
                      ),
                    );
                  }).toList(),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _isCorrect ? AppColors.greenLight : AppColors.pinkLight,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _isCorrect ? 'Story Solved! 🎉' : 'Good try! 💡',
                        style: AppTypography.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _storyProblem.explanation,
                        style: AppTypography.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      KidButton(
                        text: 'Next Story ➜',
                        color: AppColors.mintGreen,
                        onPressed: _loadNextStory,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
