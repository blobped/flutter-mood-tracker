import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'mood_entry.dart';

class MoodFace extends StatelessWidget {
  const MoodFace({
    super.key,
    required this.mood,
    this.size = 96,
  });

  final MoodType mood;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: MoodFacePainter(mood),
    );
  }
}

class MoodFacePainter extends CustomPainter {
  const MoodFacePainter(this.mood);

  final MoodType mood;

  @override
  void paint(Canvas canvas, Size size) {
    final shortest = math.min(size.width, size.height);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = shortest * 0.44;
    final accent = mood.accent;

    final facePaint = Paint()
      ..color = accent.withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;
    final outlinePaint = Paint()
      ..color = accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = shortest * 0.045
      ..strokeCap = StrokeCap.round;
    final featurePaint = Paint()
      ..color = const Color(0xFF263238)
      ..style = PaintingStyle.stroke
      ..strokeWidth = shortest * 0.052
      ..strokeCap = StrokeCap.round;
    final eyePaint = Paint()
      ..color = const Color(0xFF263238)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, facePaint);
    canvas.drawCircle(center, radius, outlinePaint);

    switch (mood) {
      case MoodType.happy:
        _paintHappy(canvas, size, center, featurePaint, eyePaint);
      case MoodType.calm:
        _paintCalm(canvas, size, center, featurePaint);
      case MoodType.sad:
        _paintSad(canvas, size, center, featurePaint, eyePaint);
    }
  }

  void _paintHappy(
    Canvas canvas,
    Size size,
    Offset center,
    Paint featurePaint,
  ) {
    final eyeRadius = size.shortestSide * 0.048;
    canvas.drawCircle(
      center.translate(-size.width * 0.16, -size.height * 0.12),
      eyeRadius,
      eyePaint,
    );
    canvas.drawCircle(
      center.translate(size.width * 0.16, -size.height * 0.12),
      eyeRadius,
      eyePaint,
    );

    final browPaint = featurePaint..strokeWidth = size.shortestSide * 0.032;
    canvas.drawLine(
      center.translate(-size.width * 0.26, -size.height * 0.24),
      center.translate(-size.width * 0.08, -size.height * 0.28),
      browPaint,
    );
    canvas.drawLine(
      center.translate(size.width * 0.08, -size.height * 0.28),
      center.translate(size.width * 0.26, -size.height * 0.24),
      browPaint,
    );

    canvas.drawArc(
      Rect.fromCenter(
        center: center.translate(0, size.height * 0.04),
        width: size.width * 0.42,
        height: size.height * 0.34,
      ),
      0.15,
      math.pi - 0.3,
      false,
      featurePaint..strokeWidth = size.shortestSide * 0.052,
    );
  }

  void _paintCalm(
    Canvas canvas,
    Size size,
    Offset center,
    Paint featurePaint,
    Paint eyePaint,
  ) {
    final eyePaintStroke = featurePaint..strokeWidth = size.shortestSide * 0.04;
    canvas.drawArc(
      Rect.fromCenter(
        center: center.translate(-size.width * 0.16, -size.height * 0.12),
        width: size.width * 0.14,
        height: size.height * 0.08,
      ),
      0,
      math.pi,
      false,
      eyePaintStroke,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: center.translate(size.width * 0.16, -size.height * 0.12),
        width: size.width * 0.14,
        height: size.height * 0.08,
      ),
      0,
      math.pi,
      false,
      eyePaintStroke,
    );

    canvas.drawLine(
      center.translate(-size.width * 0.19, size.height * 0.14),
      center.translate(size.width * 0.19, size.height * 0.14),
      featurePaint..strokeWidth = size.shortestSide * 0.048,
    );
  }

  void _paintSad(
    Canvas canvas,
    Size size,
    Offset center,
    Paint featurePaint,
    Paint eyePaint,
  ) {
    final eyeRadius = size.shortestSide * 0.042;
    canvas.drawCircle(
      center.translate(-size.width * 0.16, -size.height * 0.1),
      eyeRadius,
      eyePaint,
    );
    canvas.drawCircle(
      center.translate(size.width * 0.16, -size.height * 0.1),
      eyeRadius,
      eyePaint,
    );

    final browPaint = featurePaint..strokeWidth = size.shortestSide * 0.034;
    canvas.drawLine(
      center.translate(-size.width * 0.26, -size.height * 0.25),
      center.translate(-size.width * 0.08, -size.height * 0.2),
      browPaint,
    );
    canvas.drawLine(
      center.translate(size.width * 0.08, -size.height * 0.2),
      center.translate(size.width * 0.26, -size.height * 0.25),
      browPaint,
    );

    final mouth = Path()
      ..moveTo(center.dx - size.width * 0.22, center.dy + size.height * 0.2)
      ..quadraticBezierTo(
        center.dx,
        center.dy + size.height * 0.04,
        center.dx + size.width * 0.22,
        center.dy + size.height * 0.2,
      );
    canvas.drawPath(mouth, featurePaint..strokeWidth = size.shortestSide * 0.052);
  }

  @override
  bool shouldRepaint(covariant MoodFacePainter oldDelegate) {
    return oldDelegate.mood != mood;
  }
}
