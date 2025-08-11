import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatreply/widgets/message_widgets.dart';

import 'models/message.dart';

class CustomSwipeToReply extends StatefulWidget {
  final Message message;
  final Function(Message)? onSwipeToReply;

  const CustomSwipeToReply({
    super.key,
    required this.message,
    this.onSwipeToReply,
  });

  @override
  State<CustomSwipeToReply> createState() => CustomSwipeToReplyState();
}

class CustomSwipeToReplyState extends State<CustomSwipeToReply>
    with SingleTickerProviderStateMixin {
  double _dragX = 0.0;
  static const double _maxDrag = 80.0;
  static const double _triggerDrag = 60.0;
  late AnimationController _controller;
  late Animation<double> _indicatorOpacity;
  late Animation<double> _dragAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      reverseDuration: Duration(milliseconds: 300),
    );
    _indicatorOpacity = _controller.drive(Tween(begin: 0.0, end: 1.0));
    _dragAnimation = _controller.drive(
      Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
    );

    // Add listener to reset drag state when animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          _dragX = 0.0;
        });
      }
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    // Stop any ongoing animation if user starts dragging again
    if (_controller.isAnimating) {
      _controller.stop();
    }

    // Only allow right swipes (positive dx)
    if (details.delta.dx > 0) {
      setState(() {
        _dragX += details.delta.dx;
        if (_dragX > _maxDrag) _dragX = _maxDrag;
        if (_dragX < 0) _dragX = 0;
        // Update controller value smoothly
        _updateControllerValue();
      });
    } else if (details.delta.dx < 0 && _dragX > 0) {
      // Allow slight left movement to cancel the swipe
      setState(() {
        _dragX += details.delta.dx;
        if (_dragX < 0) _dragX = 0;
        _updateControllerValue();
      });
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    if (_dragX >= _triggerDrag) {
      widget.onSwipeToReply?.call(widget.message);
    }

    // Use velocity to determine animation duration for more natural feel
    double velocity = details.velocity.pixelsPerSecond.dx.abs();
    double duration = (300 / (velocity / 1000)).clamp(150.0, 500.0);

    // Animate back to original position with velocity-based duration
    _controller.duration = Duration(milliseconds: duration.toInt());
    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Helper method to safely update controller value
  void _updateControllerValue() {
    if (mounted) {
      _controller.value = (_dragX / _maxDrag).clamp(0.0, 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        // Stop any ongoing animation when starting a new gesture
        if (_controller.isAnimating) {
          _controller.stop();
        }
      },
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      onPanCancel: () {
        // Handle pan cancellation
        _controller.reverse();
      },
      child: Container(
        //     color: Colors.transparent, Uncomment to make the entire tile swipeable not just the bubble. But it may be difficult scrolling.
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(-40 + 100 * _dragAnimation.value / 2, 0),
                  child: Opacity(
                    opacity: _indicatorOpacity.value,
                    child: ReplyIndicatorBubble(
                      message: widget.message,
                      progress: _controller.value,
                      canReply: _dragX >= _triggerDrag,
                    ),
                  ),
                );
              },
            ),
            // The message itself, slides right
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_dragX * _dragAnimation.value, 0),
                  child: Container(
                    padding: EdgeInsets.only(
                      left: widget.message.isMe ? 60 : 16,
                      right: widget.message.isMe ? 16 : 60,
                      top: 2,
                      bottom: 2,
                    ),
                    alignment: widget.message.isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: TextMessage(widget.message),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ReplyIndicatorBubble extends StatelessWidget {
  final Message message;
  final double progress; // 0.0 to 1.0
  final bool canReply;

  const ReplyIndicatorBubble({
    super.key,
    required this.message,
    required this.progress,
    required this.canReply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: canReply
            ? Color(0xFF9E9E9E) // Slightly darker when can reply
            : Color(0xFFBDBDBD),
        shape: BoxShape.circle,
        border: Border.all(
          color: canReply
              ? CupertinoColors.systemGreen.withOpacity(0.2)
              : CupertinoColors.inactiveGray,
          width: 0.5,
        ),
        boxShadow: canReply
            ? [
                BoxShadow(
                  color: CupertinoColors.systemGreen.withOpacity(0.2),
                  blurRadius: 8.0,
                  spreadRadius: 2.0,
                ),
                BoxShadow(
                  color: CupertinoColors.systemBackground.withOpacity(0.3),
                  blurRadius: 8.0,
                  spreadRadius: 2.0,
                ),
              ]
            : null,
      ),
      child: Icon(CupertinoIcons.reply, color: Color(0xFFF1F1F1), size: 20.0),
    );
  }
}
