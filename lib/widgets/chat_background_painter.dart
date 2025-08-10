import 'package:flutter/material.dart';
import 'dart:math' as math;

class ChatBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF0F0F0) // iOS WhatsApp background
      ..style = PaintingStyle.fill;

    // Fill background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Draw subtle doodle pattern
    _drawDoodles(canvas, size);
  }

  void _drawDoodles(Canvas canvas, Size canvasSize) {
    final doodlePaint = Paint()
      ..color = const Color(0xFFE8E8E8) // Very subtle grey
      ..style = PaintingStyle.fill;

    final random = math.Random(42); // Fixed seed for consistent pattern

    // Draw various doodle shapes
    for (int i = 0; i < 25; i++) {
      final x = random.nextDouble() * canvasSize.width;
      final y = random.nextDouble() * canvasSize.height;
      final doodleSize = 2 + random.nextDouble() * 3;

      switch (i % 8) {
        case 0:
          // House
          _drawHouse(canvas, Offset(x, y), doodleSize, doodlePaint);
          break;
        case 1:
          // Heart
          _drawHeart(canvas, Offset(x, y), doodleSize, doodlePaint);
          break;
        case 2:
          // Camera
          _drawCamera(canvas, Offset(x, y), doodleSize, doodlePaint);
          break;
        case 3:
          // Pencil
          _drawPencil(canvas, Offset(x, y), doodleSize, doodlePaint);
          break;
        case 4:
          // Gift
          _drawGift(canvas, Offset(x, y), doodleSize, doodlePaint);
          break;
        case 5:
          // Mushroom
          _drawMushroom(canvas, Offset(x, y), doodleSize, doodlePaint);
          break;
        case 6:
          // Turtle
          _drawTurtle(canvas, Offset(x, y), doodleSize, doodlePaint);
          break;
        case 7:
          // Soccer ball
          _drawSoccerBall(canvas, Offset(x, y), doodleSize, doodlePaint);
          break;
      }
    }
  }

  void _drawHouse(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy - size);
    path.lineTo(center.dx - size, center.dy);
    path.lineTo(center.dx + size, center.dy);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawHeart(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy + size * 0.3);
    path.cubicTo(
      center.dx - size * 0.5, center.dy - size * 0.2,
      center.dx - size * 0.5, center.dy - size * 0.8,
      center.dx, center.dy - size * 0.8,
    );
    path.cubicTo(
      center.dx + size * 0.5, center.dy - size * 0.8,
      center.dx + size * 0.5, center.dy - size * 0.2,
      center.dx, center.dy + size * 0.3,
    );
    canvas.drawPath(path, paint);
  }

  void _drawCamera(Canvas canvas, Offset center, double size, Paint paint) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: size * 1.5, height: size),
      const Radius.circular(2),
    );
    canvas.drawRRect(rect, paint);
  }

  void _drawPencil(Canvas canvas, Offset center, double size, Paint paint) {
    final rect = Rect.fromCenter(center: center, width: size * 0.3, height: size * 1.5);
    canvas.drawRect(rect, paint);
  }

  void _drawGift(Canvas canvas, Offset center, double size, Paint paint) {
    final rect = Rect.fromCenter(center: center, width: size * 1.2, height: size * 1.2);
    canvas.drawRect(rect, paint);
  }

  void _drawMushroom(Canvas canvas, Offset center, double size, Paint paint) {
    final capRect = Rect.fromCenter(center: Offset(center.dx, center.dy - size * 0.3), width: size * 1.2, height: size * 0.6);
    final stemRect = Rect.fromCenter(center: Offset(center.dx, center.dy + size * 0.3), width: size * 0.4, height: size * 0.8);
    
    canvas.drawOval(capRect, paint);
    canvas.drawRect(stemRect, paint);
  }

  void _drawTurtle(Canvas canvas, Offset center, double size, Paint paint) {
    final rect = Rect.fromCenter(center: center, width: size * 1.5, height: size);
    canvas.drawOval(rect, paint);
  }

  void _drawSoccerBall(Canvas canvas, Offset center, double size, Paint paint) {
    canvas.drawCircle(center, size * 0.5, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
