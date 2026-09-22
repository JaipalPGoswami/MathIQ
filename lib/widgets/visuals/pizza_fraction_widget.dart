import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';

class PizzaFractionWidget extends StatelessWidget {
  final int highlightedSlices;
  final int totalSlices;
  final double size;

  const PizzaFractionWidget({
    super.key,
    required this.highlightedSlices,
    required this.totalSlices,
    this.size = 180.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PizzaPainter(
          highlighted: highlightedSlices,
          total: totalSlices,
        ),
      ),
    );
  }
}

class _PizzaPainter extends CustomPainter {
  final int highlighted;
  final int total;

  _PizzaPainter({required this.highlighted, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Crust
    final crustPaint = Paint()
      ..color = const Color(0xFFD97706)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawCircle(center, radius, crustPaint);

    final sweepAngle = (2 * pi) / total;

    for (int i = 0; i < total; i++) {
      final startAngle = i * sweepAngle - (pi / 2);
      final isSelected = i < highlighted;

      final slicePaint = Paint()
        ..color = isSelected ? const Color(0xFFFBBF24) : Colors.grey.shade200
        ..style = PaintingStyle.fill;

      canvas.drawArc(rect, startAngle, sweepAngle, true, slicePaint);

      // Slice border line
      final linePaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 3;
      final lineEnd = Offset(
        center.dx + radius * cos(startAngle),
        center.dy + radius * sin(startAngle),
      );
      canvas.drawLine(center, lineEnd, linePaint);

      // Pepperoni on selected slices
      if (isSelected) {
        final pepAngle = startAngle + sweepAngle / 2;
        final pepCenter = Offset(
          center.dx + (radius * 0.6) * cos(pepAngle),
          center.dy + (radius * 0.6) * sin(pepAngle),
        );
        canvas.drawCircle(pepCenter, radius * 0.12, Paint()..color = AppColors.coralPink);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PizzaPainter oldDelegate) {
    return oldDelegate.highlighted != highlighted || oldDelegate.total != total;
  }
}
