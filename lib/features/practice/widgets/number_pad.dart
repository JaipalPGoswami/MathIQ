import 'package:flutter/material.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/typography.dart';
import '../../../core/audio/audio_service.dart';

class NumberPad extends StatelessWidget {
  final ValueChanged<String> onKeyPressed;
  final VoidCallback onClear;
  final VoidCallback onSubmit;

  const NumberPad({
    super.key,
    required this.onKeyPressed,
    required this.onClear,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [_buildKey('1'), _buildKey('2'), _buildKey('3')],
          ),
          const SizedBox(height: 8),
          Row(
            children: [_buildKey('4'), _buildKey('5'), _buildKey('6')],
          ),
          const SizedBox(height: 8),
          Row(
            children: [_buildKey('7'), _buildKey('8'), _buildKey('9')],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildSpecialKey('⌫', onClear, color: AppColors.coralPink),
              _buildKey('0'),
              _buildSpecialKey('OK ✔️', onSubmit, color: AppColors.mintGreen),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String val) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: () {
            AudioService().playTap();
            onKeyPressed(val);
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              val,
              style: AppTypography.titleLarge.copyWith(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialKey(String label, VoidCallback onTap, {required Color color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: () {
            AudioService().playTap();
            onTap();
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: AppTypography.titleMedium.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
