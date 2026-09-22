import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/dimensions.dart';
import '../../data/repositories/student_repository.dart';
import '../../data/repositories/stats_repository.dart';
import '../../data/repositories/curriculum_repository.dart';
import '../achievements/achievements_screen.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final studentRepo = StudentRepository();
    final statsRepo = StatsRepository();
    final currRepo = CurriculumRepository();

    final student = studentRepo.getCurrentStudent();
    final totalSolved = statsRepo.getTotalQuestionsSolved();
    final correctSolved = statsRepo.getCorrectQuestionsSolved();
    final accuracy = totalSolved > 0 ? (correctSolved / totalSolved * 100).toInt() : 100;
    final masteries = statsRepo.getAllMasteries();
    final achievements = statsRepo.getAchievements();
    final unlockedCount = achievements.where((a) => a.isUnlocked).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Math Progress 📈'),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events_rounded, color: AppColors.warmAmber, size: 28),
            tooltip: 'Badges',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AchievementsScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Stats Card
            Container(
              padding: const EdgeInsets.all(AppDimensions.p20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                border: Border.all(color: AppColors.cardBorder, width: 2),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem('Total Solved', '$totalSolved', '🧮', AppColors.primaryBlue),
                      _buildSummaryItem('Accuracy', '$accuracy%', '🎯', AppColors.mintGreen),
                      _buildSummaryItem('Daily Streak', '${student?.streak ?? 1} Days', '🔥', AppColors.coralPink),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Badges Shortcut Card
            InkWell(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AchievementsScreen()),
              ),
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.p16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.amberLight, Color(0xFFFEF9C3)],
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                  border: Border.all(color: AppColors.warmAmber.withOpacity(0.4), width: 2),
                ),
                child: Row(
                  children: [
                    const Text('🏆', style: TextStyle(fontSize: 40)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Achievements Showcase', style: AppTypography.titleMedium),
                          Text('$unlockedCount / ${achievements.length} Badges Unlocked! ⭐', style: AppTypography.bodyMedium),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Topic Mastery List
            Text('Topic Mastery Breakdown 📚', style: AppTypography.titleMedium),
            const SizedBox(height: 12),
            if (masteries.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: Column(
                  children: [
                    const Text('🌱', style: TextStyle(fontSize: 40)),
                    const SizedBox(height: 8),
                    Text('Start practicing to see topic mastery growth!', style: AppTypography.bodyMedium),
                  ],
                ),
              )
            else
              ...masteries.map((m) {
                final topic = currRepo.getTopicById(m.topicId);
                final topicName = topic?.name ?? m.topicId;
                final icon = topic?.icon ?? '⭐';
                final accPercent = (m.accuracy * 100).toInt();

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    border: Border.all(color: AppColors.cardBorder, width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(icon, style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(topicName, style: AppTypography.titleMedium.copyWith(fontSize: 16)),
                          ),
                          Text(m.level.badge, style: AppTypography.titleMedium.copyWith(fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Accuracy: $accPercent%', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          Text('${m.attempts} questions solved', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: m.accuracy.clamp(0.05, 1.0),
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            m.accuracy >= 0.8 ? AppColors.mintGreen : AppColors.warmAmber,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String val, String emoji, Color color) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 6),
        Text(val, style: AppTypography.titleLarge.copyWith(color: color, fontSize: 20)),
        Text(title, style: AppTypography.bodyMedium.copyWith(fontSize: 13)),
      ],
    );
  }
}
