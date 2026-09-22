import 'package:flutter/material.dart';
import '../../data/models/topic.dart';
import '../../data/models/mastery.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/dimensions.dart';
import '../../core/audio/audio_service.dart';

class TopicCard extends StatelessWidget {
  final Topic topic;
  final TopicMastery? mastery;
  final VoidCallback onTap;

  const TopicCard({
    super.key,
    required this.topic,
    this.mastery,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accuracy = mastery?.accuracy ?? 0.0;
    final level = mastery?.level ?? MasteryLevel.beginner;
    final percentInt = (accuracy * 100).toInt();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        onTap: () {
          AudioService().playTap();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.p16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            border: Border.all(color: AppColors.cardBorder, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.amberLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      topic.icon,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic.name,
                          style: AppTypography.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          level.badge,
                          style: AppTypography.bodyMedium.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                topic.description,
                style: AppTypography.bodyMedium.copyWith(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mastery: $percentInt%',
                    style: AppTypography.titleMedium.copyWith(
                      fontSize: 14,
                      color: AppColors.primaryBlueDark,
                    ),
                  ),
                  Text(
                    '${mastery?.attempts ?? 0} solved',
                    style: AppTypography.bodyMedium.copyWith(fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
                child: LinearProgressIndicator(
                  value: accuracy.clamp(0.05, 1.0),
                  minHeight: 10,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    accuracy >= 0.8 ? AppColors.mintGreen : AppColors.warmAmber,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
