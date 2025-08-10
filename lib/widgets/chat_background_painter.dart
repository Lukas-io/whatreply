import 'package:flutter/material.dart';
import 'dart:math' as math;

class ChatBackgroundPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;

  ChatBackgroundPainter({
    this.primaryColor = const Color(0xFF25D366),
    this.secondaryColor = const Color(0xFF128C7E),
    this.accentColor = const Color(0xFFDCF8C6),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final random = math.Random(42); // Fixed seed for consistent pattern

    // Draw main background gradient - very subtle
    final backgroundGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        primaryColor.withValues(alpha: 0.02),
        accentColor.withValues(alpha: 0.01),
        Colors.white,
      ],
    );

    final backgroundRect = Rect.fromLTWH(0, 0, size.width, size.height);
    paint.shader = backgroundGradient.createShader(backgroundRect);
    canvas.drawRect(backgroundRect, paint);

    // Draw floating bubbles - very subtle
    _drawBubbles(canvas, size, random);
    
    // Draw geometric patterns - very subtle
    _drawGeometricPatterns(canvas, size, random);
    
    // Draw subtle grid lines - very subtle
    _drawGridLines(canvas, size);
  }

  void _drawBubbles(Canvas canvas, Size size, math.Random random) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = primaryColor.withValues(alpha: 0.03);

    for (int i = 0; i < 8; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = 15 + random.nextDouble() * 25;
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  void _drawGeometricPatterns(Canvas canvas, Size size, math.Random random) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = secondaryColor.withValues(alpha: 0.02)
      ..strokeWidth = 0.5;

    // Draw triangles
    for (int i = 0; i < 5; i++) {
      final path = Path();
      final x1 = random.nextDouble() * size.width;
      final y1 = random.nextDouble() * size.height;
      final x2 = x1 + 20 + random.nextDouble() * 15;
      final y2 = y1 + 15 + random.nextDouble() * 10;
      final x3 = x1 + 10 + random.nextDouble() * 8;
      final y3 = y1 + 25 + random.nextDouble() * 18;

      path.moveTo(x1, y1);
      path.lineTo(x2, y2);
      path.lineTo(x3, y3);
      path.close();
      
      canvas.drawPath(path, paint);
    }

    // Draw rectangles
    for (int i = 0; i < 3; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final width = 15 + random.nextDouble() * 20;
      final height = 12 + random.nextDouble() * 18;
      
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, width, height),
        const Radius.circular(3),
      );
      
      canvas.drawRRect(rect, paint);
    }
  }

  void _drawGridLines(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey.withValues(alpha: 0.015)
      ..strokeWidth = 0.3;

    // Vertical lines - fewer and more subtle
    for (int i = 0; i <= 6; i++) {
      final x = (size.width / 6) * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines - fewer and more subtle
    for (int i = 0; i <= 12; i++) {
      final y = (size.height / 12) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
