import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';

class StarRatingBar extends StatelessWidget {
  final int starCount; // 1 to 3
  final double starSize;

  const StarRatingBar({
    super.key,
    required this.starCount,
    this.starSize = 52.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isLit = index < starCount;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: AnimatedScale(
            scale: isLit ? 1.15 : 0.9,
            duration: Duration(milliseconds: 300 + index * 100),
            curve: Curves.elasticOut,
            child: Icon(
              Icons.star_rounded,
              size: starSize,
              color: isLit ? AppColors.sunnyYellow : Colors.grey.shade300,
              shadows: isLit
                  ? [
                      BoxShadow(
                        color: AppColors.warmAmber.withOpacity(0.5),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
          ),
        );
      }),
    );
  }
}
