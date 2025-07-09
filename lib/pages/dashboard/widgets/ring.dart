import 'package:flutter/material.dart';
import 'dart:math';

class ColoredRing extends StatelessWidget {
  final List<Color> colors;
  final List<double>
  percentages; // Each value is a fraction (e.g., 0.25 for 25%)

  const ColoredRing({
    super.key,
    required this.colors,
    required this.percentages,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(200, 200), // Set your desired size
      painter: RingPainter(colors: colors, percentages: percentages),
    );
  }
}

class RingPainter extends CustomPainter {
  final List<Color> colors;
  final List<double> percentages;

  RingPainter({required this.colors, required this.percentages});

  @override
  void paint(Canvas canvas, Size size) {
    double startAngle = -pi / 2; // Start at the top
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final strokeWidth = 30.0; // Thickness of the ring

    for (int i = 0; i < colors.length; i++) {
      final sweepAngle = 2 * pi * percentages[i];
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        rect.deflate(strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
