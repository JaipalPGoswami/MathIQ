import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/dimensions.dart';
import '../../data/models/topic.dart';
import '../../data/models/mastery.dart';
import '../../data/repositories/curriculum_repository.dart';
import '../learning/learn_screen.dart';
import '../practice/practice_screen.dart';
import '../quiz/quiz_screen.dart';
import '../games/games_hub_screen.dart';

class TopicDetailScreen extends StatefulWidget {
  final Topic topic;

  const TopicDetailScreen({super.key, required this.topic});

  @override
  State<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  final CurriculumRepository _currRepo = CurriculumRepository();

  @override
  Widget build(BuildContext context) {
    final mastery = _currRepo.getMastery(widget.topic.id);
    final accuracy = mastery?.accuracy ?? 0.0;
    final level = mastery?.level ?? MasteryLevel.beginner;
    final percent = (accuracy * 100).toInt();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Topic Card
            Container(
              padding: const EdgeInsets.all(AppDimensions.p20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                border: Border.all(color: AppColors.cardBorder, width: 2),
              ),
              child: Column(
                children: [
                  Text(widget.topic.icon, style: const TextStyle(fontSize: 64)),
                  const SizedBox(height: 12),
                  Text(widget.topic.name, style: AppTypography.displayMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 6),
                  Text(widget.topic.description, style: AppTypography.bodyMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mastery: $percent%', style: AppTypography.titleMedium.copyWith(color: AppColors.primaryBlueDark)),
                      Text(level.badge, style: AppTypography.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
                    child: LinearProgressIndicator(
                      value: accuracy.clamp(0.05, 1.0),
                      minHeight: 12,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        accuracy >= 0.8 ? AppColors.mintGreen : AppColors.warmAmber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text('Choose Your Mode ⭐', style: AppTypography.titleMedium),
            const SizedBox(height: 14),

            // Mode 1: Learn Visually
            _buildModeCard(
              title: 'Learn Visually 🎓',
              description: 'Step-by-step illustrations with voice narration.',
              color: AppColors.primaryBlueLight,
              borderColor: AppColors.primaryBlue,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => LearnScreen(topic: widget.topic)),
                );
              },
            ),
            const SizedBox(height: 12),

            // Mode 2: Practice Questions
            _buildModeCard(
              title: 'Practice Questions ✏️',
              description: 'Adaptive math practice with cheerful hints.',
              color: AppColors.greenLight,
              borderColor: AppColors.mintGreen,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PracticeScreen(
                      topicId: widget.topic.id,
                      topicName: widget.topic.name,
                    ),
                  ),
                ).then((_) => setState(() {}));
              },
            ),
            const SizedBox(height: 12),

            // Mode 3: Take Quiz
            _buildModeCard(
              title: 'Take a Quiz 🏆',
              description: '5, 10, or 20 questions to test your skills!',
              color: AppColors.amberLight,
              borderColor: AppColors.warmAmber,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => QuizScreen(topicId: widget.topic.id, topicName: widget.topic.name),
                  ),
                ).then((_) => setState(() {}));
              },
            ),
            const SizedBox(height: 12),

            // Mode 4: Themed Game
            _buildModeCard(
              title: 'Play Math Games 🎮',
              description: 'Race against time and play themed mini-games.',
              color: AppColors.orangeLight,
              borderColor: AppColors.orangeTangerine,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const GamesHubScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard({
    required String title,
    required String description,
    required Color color,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.p16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.5),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.titleMedium),
                  const SizedBox(height: 2),
                  Text(description, style: AppTypography.bodyMedium.copyWith(fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}
