import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/dimensions.dart';
import '../../core/audio/audio_service.dart';

class KidButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final Color? textColor;
  final String? emoji;
  final double height;
  final bool isFullWidth;
  final double fontSize;

  const KidButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color = AppColors.primaryBlue,
    this.textColor,
    this.emoji,
    this.height = AppDimensions.kidButtonHeight,
    this.isFullWidth = true,
    this.fontSize = 20,
  });

  @override
  State<KidButton> createState() => _KidButtonState();
}

class _KidButtonState extends State<KidButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.onPressed == null ? Colors.grey.shade400 : widget.color;
    final shadowColor = HSLColor.fromColor(effectiveColor).withLightness(
      (HSLColor.fromColor(effectiveColor).lightness - 0.15).clamp(0.0, 1.0),
    ).toColor();

    Widget button = GestureDetector(
      onTapDown: widget.onPressed == null ? null : (_) => setState(() => _isPressed = true),
      onTapUp: widget.onPressed == null ? null : (_) {
        setState(() => _isPressed = false);
        AudioService().playTap();
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 70),
        height: widget.height,
        margin: EdgeInsets.only(
          top: _isPressed ? 6.0 : 0.0,
          bottom: _isPressed ? 0.0 : 6.0,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: effectiveColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: shadowColor,
                    offset: const Offset(0, 6),
                    blurRadius: 0,
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.emoji != null) ...[
              Text(
                widget.emoji!,
                style: TextStyle(fontSize: widget.fontSize + 4),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                widget.text,
                style: AppTypography.buttonText.copyWith(
                  fontSize: widget.fontSize,
                  color: widget.textColor ?? Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );

    return widget.isFullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
