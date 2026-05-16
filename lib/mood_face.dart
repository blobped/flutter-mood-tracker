import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'mood_entry.dart';

class MoodFace extends StatelessWidget {
  const MoodFace({
    super.key,
    required this.mood,
    this.size = 96,
    this.animationValue = 0,
  });

  final MoodType mood;
  final double size;
  final double animationValue;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: MoodFacePainter(mood: mood, animationValue: animationValue),
    );
  }
}

class MoodFacePainter extends CustomPainter {
  const MoodFacePainter({required this.mood, required this.animationValue});

  final MoodType mood;
  final double animationValue;

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
        _paintHappy(
          canvas,
          size,
          center,
          featurePaint,
          eyePaint,
          animationValue,
        );
      case MoodType.calm:
        _paintCalm(
          canvas,
          size,
          center,
          featurePaint,
          eyePaint,
          animationValue,
        );
      case MoodType.sad:
        _paintSad(canvas, size, center, featurePaint, animationValue);
      case MoodType.angry:
        _paintAngry(
          canvas,
          size,
          center,
          featurePaint,
          eyePaint,
          animationValue,
        );
    }
  }

  void _paintHappy(
    Canvas canvas,
    Size size,
    Offset center,
    Paint featurePaint,
    Paint eyePaint,
    double pulse,
  ) {
    final eyeRadius = size.shortestSide * (0.048 + pulse * 0.008);
    canvas.drawCircle(
      center.translate(
        -size.width * 0.16,
        -size.height * (0.12 + pulse * 0.02),
      ),
      eyeRadius,
      eyePaint,
    );
    canvas.drawCircle(
      center.translate(size.width * 0.16, -size.height * (0.12 + pulse * 0.02)),
      eyeRadius,
      eyePaint,
    );

    canvas.drawArc(
      Rect.fromCenter(
        center: center.translate(0, size.height * 0.04),
        width: size.width * (0.42 + pulse * 0.08),
        height: size.height * (0.34 + pulse * 0.08),
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
    double pulse,
  ) {
    final eyeRadius = size.shortestSide * (0.04 + pulse * 0.006);
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

    final mouth = Path()
      ..moveTo(center.dx - size.width * 0.19, center.dy + size.height * 0.14)
      ..quadraticBezierTo(
        center.dx,
        center.dy + size.height * (0.14 + pulse * 0.05),
        center.dx + size.width * 0.19,
        center.dy + size.height * 0.14,
      );
    canvas.drawPath(
      mouth,
      featurePaint..strokeWidth = size.shortestSide * 0.048,
    );
  }

  void _paintSad(
    Canvas canvas,
    Size size,
    Offset center,
    Paint featurePaint,
    double pulse,
  ) {
    final browPaint = featurePaint..strokeWidth = size.shortestSide * 0.036;
    _drawCurvedBrow(
      canvas,
      start: center.translate(
        -size.width * 0.23,
        -size.height * (0.2 + pulse * 0.02),
      ),
      control: center.translate(-size.width * 0.17, -size.height * 0.17),
      end: center.translate(
        -size.width * 0.09,
        -size.height * (0.24 + pulse * 0.03),
      ),
      paint: browPaint,
    );
    _drawCurvedBrow(
      canvas,
      start: center.translate(
        size.width * 0.09,
        -size.height * (0.24 + pulse * 0.03),
      ),
      control: center.translate(size.width * 0.17, -size.height * 0.17),
      end: center.translate(
        size.width * 0.23,
        -size.height * (0.2 + pulse * 0.02),
      ),
      paint: browPaint,
    );

    final eyePaintStroke = featurePaint..strokeWidth = size.shortestSide * 0.04;
    _drawClosedEye(
      canvas,
      rect: Rect.fromCenter(
        center: center.translate(-size.width * 0.16, -size.height * 0.08),
        width: size.width * 0.15,
        height: size.height * 0.1,
      ),
      paint: eyePaintStroke,
    );
    _drawClosedEye(
      canvas,
      rect: Rect.fromCenter(
        center: center.translate(size.width * 0.16, -size.height * 0.08),
        width: size.width * 0.15,
        height: size.height * 0.1,
      ),
      paint: eyePaintStroke,
    );

    final mouth = Path()
      ..moveTo(center.dx - size.width * 0.2, center.dy + size.height * 0.22)
      ..quadraticBezierTo(
        center.dx,
        center.dy + size.height * (0.05 - pulse * 0.04),
        center.dx + size.width * 0.2,
        center.dy + size.height * 0.22,
      );
    canvas.drawPath(
      mouth,
      featurePaint..strokeWidth = size.shortestSide * 0.052,
    );
  }

  void _paintAngry(
    Canvas canvas,
    Size size,
    Offset center,
    Paint featurePaint,
    Paint eyePaint,
    double pulse,
  ) {
    final eyeRadius = size.shortestSide * (0.048 + pulse * 0.004);
    canvas.drawCircle(
      center.translate(-size.width * 0.15, -size.height * 0.05),
      eyeRadius,
      eyePaint,
    );
    canvas.drawCircle(
      center.translate(size.width * 0.15, -size.height * 0.05),
      eyeRadius,
      eyePaint,
    );

    final browPaint = featurePaint..strokeWidth = size.shortestSide * 0.044;
    canvas.drawLine(
      center.translate(
        -size.width * 0.24,
        -size.height * (0.22 + pulse * 0.03),
      ),
      center.translate(-size.width * 0.1, -size.height * (0.15 + pulse * 0.02)),
      browPaint,
    );
    canvas.drawLine(
      center.translate(size.width * 0.1, -size.height * (0.15 + pulse * 0.02)),
      center.translate(size.width * 0.24, -size.height * (0.22 + pulse * 0.03)),
      browPaint,
    );

    final mouth = Path()
      ..moveTo(center.dx - size.width * 0.2, center.dy + size.height * 0.22)
      ..quadraticBezierTo(
        center.dx,
        center.dy + size.height * (0.06 - pulse * 0.04),
        center.dx + size.width * 0.2,
        center.dy + size.height * 0.22,
      );
    canvas.drawPath(
      mouth,
      featurePaint..strokeWidth = size.shortestSide * 0.052,
    );
  }

  void _drawCurvedBrow(
    Canvas canvas, {
    required Offset start,
    required Offset control,
    required Offset end,
    required Paint paint,
  }) {
    final brow = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
    canvas.drawPath(brow, paint);
  }

  void _drawClosedEye(
    Canvas canvas, {
    required Rect rect,
    required Paint paint,
  }) {
    canvas.drawArc(rect, 0.2, math.pi - 0.4, false, paint);
  }

  @override
  bool shouldRepaint(covariant MoodFacePainter oldDelegate) {
    return oldDelegate.mood != mood ||
        oldDelegate.animationValue != animationValue;
  }
}
