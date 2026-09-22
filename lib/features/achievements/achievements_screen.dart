import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/dimensions.dart';
import '../../data/repositories/stats_repository.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final statsRepo = StatsRepository();
    final achievements = statsRepo.getAchievements();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements Shelf 🏆'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppDimensions.p20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.85,
        ),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final ach = achievements[index];
          final isUnlocked = ach.isUnlocked;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isUnlocked ? Colors.white : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(
                color: isUnlocked ? AppColors.warmAmber : Colors.grey.shade300,
                width: 2,
              ),
              boxShadow: isUnlocked
                  ? [
                      BoxShadow(
                        color: AppColors.warmAmber.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(
                  opacity: isUnlocked ? 1.0 : 0.35,
                  child: Text(ach.icon, style: const TextStyle(fontSize: 48)),
                ),
                const SizedBox(height: 10),
                Text(
                  ach.name,
                  style: AppTypography.titleMedium.copyWith(
                    fontSize: 15,
                    color: isUnlocked ? AppColors.textPrimary : Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  ach.description,
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 11,
                    color: isUnlocked ? AppColors.textSecondary : Colors.grey.shade400,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isUnlocked ? AppColors.amberLight : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isUnlocked ? 'Unlocked! ⭐' : 'Locked 🔒',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isUnlocked ? AppColors.warmAmber : Colors.grey.shade500,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
