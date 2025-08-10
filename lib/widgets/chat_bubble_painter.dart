import 'package:flutter/material.dart';

class ChatBubblePainter extends CustomPainter {
  final Color color;
  final bool isMe;
  final double borderRadius;
  final double tailSize;

  ChatBubblePainter({
    required this.color,
    required this.isMe,
    this.borderRadius = 18.0,
    this.tailSize = 6.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    if (isMe) {
      // Right-aligned bubble (sent messages)
      _drawRightBubble(path, size);
    } else {
      // Left-aligned bubble (received messages)
      _drawLeftBubble(path, size);
    }

    canvas.drawPath(path, paint);

    // Optional: Add subtle shadow
    _drawShadow(canvas, path);
  }

  void _drawRightBubble(Path path, Size size) {
    // Start from top-left with radius
    path.moveTo(borderRadius, 0);

    // Top edge to top-right corner
    path.lineTo(size.width - borderRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, borderRadius);

    // Right edge down to where tail starts
    path.lineTo(size.width, size.height - borderRadius - tailSize);

    // Create the tail pointing right
    path.lineTo(size.width + tailSize, size.height - borderRadius);
    path.lineTo(size.width, size.height - borderRadius + tailSize);

    // Continue to bottom-right corner
    path.lineTo(size.width, size.height - borderRadius);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - borderRadius,
      size.height,
    );

    // Bottom edge to bottom-left corner
    path.lineTo(borderRadius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - borderRadius);

    // Left edge to top-left corner
    path.lineTo(0, borderRadius);
    path.quadraticBezierTo(0, 0, borderRadius, 0);

    path.close();
  }

  void _drawLeftBubble(Path path, Size size) {
    // Start from top-left corner (after the tail area)
    path.moveTo(tailSize + borderRadius, 0);

    // Top edge to top-right corner
    path.lineTo(size.width - borderRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, borderRadius);

    // Right edge
    path.lineTo(size.width, size.height - borderRadius);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - borderRadius,
      size.height,
    );

    // Bottom edge to where tail will be
    path.lineTo(tailSize + borderRadius, size.height);
    path.quadraticBezierTo(
      tailSize,
      size.height,
      tailSize,
      size.height - borderRadius,
    );

    // Left edge up to where tail starts
    path.lineTo(tailSize, borderRadius + tailSize);

    // Create the tail pointing left
    path.lineTo(-tailSize, borderRadius);
    path.lineTo(tailSize, borderRadius - tailSize);

    // Continue to top-left corner
    path.lineTo(tailSize, borderRadius);
    path.quadraticBezierTo(tailSize, 0, tailSize + borderRadius, 0);

    path.close();
  }

  void _drawShadow(Canvas canvas, Path bubblePath) {
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    canvas.save();
    canvas.translate(0, 1); // Slight shadow offset
    canvas.drawPath(bubblePath, shadowPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is ChatBubblePainter &&
        (oldDelegate.color != color ||
            oldDelegate.isMe != isMe ||
            oldDelegate.borderRadius != borderRadius ||
            oldDelegate.tailSize != tailSize);
  }
}

// Widget wrapper for easy usage
class ChatBubble extends StatelessWidget {
  final Widget child;
  final Color color;
  final bool isMe;
  final double borderRadius;
  final double tailSize;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const ChatBubble({
    Key? key,
    required this.child,
    required this.color,
    required this.isMe,
    this.borderRadius = 18.0,
    this.tailSize = 6.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: CustomPaint(
        painter: ChatBubblePainter(
          color: color,
          isMe: isMe,
          borderRadius: borderRadius,
          tailSize: tailSize,
        ),
        child: Container(
          padding: padding?.add(
            EdgeInsets.only(
              left: isMe ? 0 : tailSize,
              right: isMe ? tailSize : 0,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

// Example usage
class ChatBubbleExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFF6F1EA),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Received message
            Align(
              alignment: Alignment.centerLeft,
              child: ChatBubble(
                color: Colors.white,
                isMe: false,
                child: Text(
                  'Hello! How are you doing today?',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Sent message
            Align(
              alignment: Alignment.centerRight,
              child: ChatBubble(
                color: Color(0xFFDCF8C6),
                isMe: true,
                child: Text(
                  'I\'m doing great, thanks for asking!',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
