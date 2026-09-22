import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/dimensions.dart';
import '../../core/audio/audio_service.dart';
import '../../core/utils/confetti_helper.dart';
import '../../data/repositories/student_repository.dart';
import '../../data/repositories/stats_repository.dart';
import '../../math_engine/adaptive/xp_system.dart';
import '../../widgets/visuals/star_rating_bar.dart';
import '../../widgets/buttons/kid_button.dart';

class QuizResultsScreen extends StatefulWidget {
  final int totalQuestions;
  final int correctAnswers;
  final List<Map<String, dynamic>> mistakes;
  final int secondsElapsed;

  const QuizResultsScreen({
    super.key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.mistakes,
    required this.secondsElapsed,
  });

  @override
  State<QuizResultsScreen> createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends State<QuizResultsScreen> {
  final StudentRepository _studentRepo = StudentRepository();
  final StatsRepository _statsRepo = StatsRepository();
  late ConfettiController _confetti;
  int _xpEarned = 0;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiHelper.createController();
    _confetti.play();
    AudioService().playCheer();

    _calculateAndAwardXp();
  }

  Future<void> _calculateAndAwardXp() async {
    _xpEarned = XpSystem.forQuizCompleted(
      totalQuestions: widget.totalQuestions,
      correctAnswers: widget.correctAnswers,
    );
    await _studentRepo.addXp(_xpEarned);

    final s = _studentRepo.getCurrentStudent();
    if (s != null) {
      final accuracy = widget.totalQuestions > 0 ? (widget.correctAnswers / widget.totalQuestions) : 0.0;
      await _statsRepo.checkAndUnlockAchievements(
        totalCorrect: _statsRepo.getCorrectQuestionsSolved(),
        streak: s.streak,
        completedQuizzes: 1,
        lastQuizAccuracy: accuracy,
      );
    }
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accuracy = widget.totalQuestions > 0
        ? (widget.correctAnswers / widget.totalQuestions)
        : 0.0;
    final stars = accuracy >= 0.9 ? 3 : (accuracy >= 0.6 ? 2 : 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results 🎉'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.p24),
            child: Column(
              children: [
                StarRatingBar(starCount: stars),
                const SizedBox(height: 18),
                Text(
                  stars == 3 ? 'Incredible Job! 🌟' : 'Great Effort! 👏',
                  style: AppTypography.displayMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  'You solved ${widget.correctAnswers} out of ${widget.totalQuestions} correctly in ${widget.secondsElapsed}s!',
                  style: AppTypography.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.amberLight,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
                  ),
                  child: Text(
                    '+$_xpEarned XP ⭐',
                    style: AppTypography.titleLarge.copyWith(color: AppColors.warmAmber),
                  ),
                ),
                const SizedBox(height: 24),

                if (widget.mistakes.isNotEmpty) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Review Mistakes 💡', style: AppTypography.titleMedium),
                  ),
                  const SizedBox(height: 8),
                  ...widget.mistakes.map((m) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m['question'] as String, style: AppTypography.titleMedium.copyWith(fontSize: 16)),
                          const SizedBox(height: 4),
                          Text('Your answer: ${m['yourAnswer']} ❌', style: const TextStyle(color: AppColors.coralPink)),
                          Text('Correct answer: ${m['correctAnswer']} ✔️', style: const TextStyle(color: AppColors.mintGreen, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(m['explanation'] as String, style: AppTypography.bodyMedium.copyWith(fontSize: 13)),
                        ],
                      ),
                    );
                  }),
                ],
                const SizedBox(height: 24),

                KidButton(
                  text: 'Back to Home 🏠',
                  color: AppColors.primaryBlue,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          ConfettiHelper.buildCelebrationConfetti(controller: _confetti),
        ],
      ),
    );
  }
}
