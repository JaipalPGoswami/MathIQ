import 'package:flutter/material.dart';
import '../../math_engine/models/visual_item.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/dimensions.dart';

class MathIllustration extends StatelessWidget {
  final VisualData visualData;

  const MathIllustration({super.key, required this.visualData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.p16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlueLight.withOpacity(0.4),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2), width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Group A
              Flexible(child: _buildItemCluster(visualData.countA, visualData.type.emoji)),
              if (visualData.operation != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    visualData.operation!,
                    style: AppTypography.displayLarge.copyWith(
                      color: AppColors.primaryBlueDark,
                      fontSize: 36,
                    ),
                  ),
                ),
                // Group B
                Flexible(child: _buildItemCluster(visualData.countB, visualData.type.emoji)),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Count the ${visualData.type.label}! 👆',
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCluster(int count, String emoji) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      alignment: WrapAlignment.center,
      children: List.generate(
        count.clamp(1, 15),
        (index) => Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 26),
          ),
        ),
      ),
    );
  }
}
