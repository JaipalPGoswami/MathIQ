import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';

class AnalogClockWidget extends StatelessWidget {
  final int hour;
  final int minute;
  final double size;

  const AnalogClockWidget({
    super.key,
    required this.hour,
    required this.minute,
    this.size = 180.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ClockPainter(hour: hour, minute: minute),
      ),
    );
  }
}

class _ClockPainter extends CustomPainter {
  final int hour;
  final int minute;

  _ClockPainter({required this.hour, required this.minute});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer Rim
    final rimPaint = Paint()
      ..color = AppColors.warmAmber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    canvas.drawCircle(center, radius - 5, rimPaint);

    // Clock Face
    final facePaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius - 10, facePaint);

    // Draw Numbers 1 to 12
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 1; i <= 12; i++) {
      final angle = (i * 30 - 90) * pi / 180;
      final numOffset = Offset(
        center.dx + (radius - 30) * cos(angle),
        center.dy + (radius - 30) * sin(angle),
      );
      textPainter.text = TextSpan(
        text: '$i',
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(numOffset.dx - textPainter.width / 2, numOffset.dy - textPainter.height / 2),
      );
    }

    // Hour Hand
    final hourAngle = ((hour % 12 + minute / 60.0) * 30 - 90) * pi / 180;
    final hourHandPaint = Paint()
      ..color = AppColors.coralPink
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    final hourEnd = Offset(
      center.dx + (radius * 0.45) * cos(hourAngle),
      center.dy + (radius * 0.45) * sin(hourAngle),
    );
    canvas.drawLine(center, hourEnd, hourHandPaint);

    // Minute Hand
    final minAngle = (minute * 6 - 90) * pi / 180;
    final minHandPaint = Paint()
      ..color = AppColors.primaryBlue
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final minEnd = Offset(
      center.dx + (radius * 0.7) * cos(minAngle),
      center.dy + (radius * 0.7) * sin(minAngle),
    );
    canvas.drawLine(center, minEnd, minHandPaint);

    // Center pin
    canvas.drawCircle(center, 7, Paint()..color = AppColors.textPrimary);
  }

  @override
  bool shouldRepaint(covariant _ClockPainter oldDelegate) {
    return oldDelegate.hour != hour || oldDelegate.minute != minute;
  }
}
