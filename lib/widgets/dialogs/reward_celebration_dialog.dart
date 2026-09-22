import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/dimensions.dart';
import '../buttons/kid_button.dart';
import '../../core/audio/audio_service.dart';

class RewardCelebrationDialog extends StatelessWidget {
  final String title;
  final String message;
  final int xpEarned;
  final String badgeEmoji;
  final VoidCallback onContinue;

  const RewardCelebrationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.xpEarned,
    this.badgeEmoji = '⭐',
    required this.onContinue,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    required int xpEarned,
    String badgeEmoji = '⭐',
    required VoidCallback onContinue,
  }) {
    AudioService().playCheer();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => RewardCelebrationDialog(
        title: title,
        message: message,
        xpEarned: xpEarned,
        badgeEmoji: badgeEmoji,
        onContinue: onContinue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.p24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              badgeEmoji,
              style: const TextStyle(fontSize: 70),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTypography.displayMedium.copyWith(fontSize: 26),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTypography.bodyMedium,
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
                '+$xpEarned XP ⭐',
                style: AppTypography.titleLarge.copyWith(color: AppColors.warmAmber),
              ),
            ),
            const SizedBox(height: 24),
            KidButton(
              text: 'Keep Going! 🚀',
              color: AppColors.mintGreen,
              onPressed: () {
                Navigator.of(context).pop();
                onContinue();
              },
            ),
          ],
        ),
      ),
    );
  }
}
