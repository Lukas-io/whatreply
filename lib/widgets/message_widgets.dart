import 'package:flutter/material.dart';
import '../custom_swipe_to_reply_widget.dart';
import '../models/message.dart';
import '../utils/date_utils.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Function(Message)? onSwipeToReply;

  const MessageWidget({
    super.key,
    required this.message,
    this.onTap,
    this.onLongPress,
    this.onSwipeToReply,
  });

  @override
  Widget build(BuildContext context) {
    return CustomSwipeToReply(message: message, onSwipeToReply: onSwipeToReply);
  }
}

class ReplyContainer extends StatelessWidget {
  final Message replyTo;
  final int maxLines;

  const ReplyContainer(this.replyTo, {this.maxLines = 2, super.key});

  @override
  Widget build(BuildContext context) {
    final color = !replyTo.isMe ? Color(0XFFA791FF) : Color(0XFFFB5061);
    return IntrinsicHeight(
      child: IntrinsicWidth(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),

          child: Row(
            children: [
              Container(color: color, width: 4),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.04),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        replyTo.isMe ? "You" : "Jance",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                        maxLines: maxLines,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        replyTo.text,
                        style: TextStyle(
                          fontSize: 12,
                          color: maxLines == 1
                              ? Colors.black87
                              : Color(0XFF414F42),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// TODO: THIS IS WHAT YOU'RE LOOKING FOR. ALWAYS HAPPY TO HELP!
//TODO: LOOK AT FROM HERE TILL THE END.
class TextMessage extends StatelessWidget {
  final Message message;

  const TextMessage(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: message.isMe ? const Color(0xffD0FECF) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black26, width: 0.2),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Reply preview
              if (message.replyTo != null) ...[
                ReplyContainer(message.replyTo!),
              ],
              SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(
                  // top: 4.0,
                  right: 4.0,
                  left: 4.0,
                ),
                child: RichText(
                  textWidthBasis: TextWidthBasis.longestLine,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: message.text,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF0C1317),
                          height: 1.0,
                          letterSpacing: 0,
                        ),
                      ),
                      TextSpan(text: " "),
                      //TODO:
                      /// THIS HELPS TO SET ENOUGH SPACE FOR THE TIME WIDGET. IF IT NEEDS A NEW LINE IT WOULD AUTOMATICALLY ADD IT BECAUSE THE TEXT IS THE SIMILAR WIDTH TO THE TIME WIDGET
                      TextSpan(
                        text:
                            (message.isMe ? "ddd" : "") +
                            ChatDateUtils.formatMessageTime(message.timestamp),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.transparent,
                          //TODO: CHANGE THIS TO RED.
                          wordSpacing: -2,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(bottom: -2, right: 0, child: TimeWidget(message)),
        ],
      ),
    );
  }
}

class TimeWidget extends StatelessWidget {
  final Message message;

  const TimeWidget(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          ChatDateUtils.formatMessageTime(message.timestamp, format: 'hh:mm a'),
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF667781),
            wordSpacing: -2,
            letterSpacing: 0,
          ),
        ),
        if (message.isMe) ...[
          const SizedBox(width: 4),
          buildMessageStatus(message, isReceived: false),
        ],
      ],
    );
  }
}

Widget buildMessageStatus(Message message, {bool isReceived = false}) {
  if (isReceived) {
    // For received messages, show a subtle indicator
    switch (message.deliveryStatus) {
      case DeliveryStatus.sending:
        return const Icon(Icons.access_time, size: 12, color: Colors.grey);
      case DeliveryStatus.sent:
      case DeliveryStatus.delivered:
      case DeliveryStatus.read:
        return const Icon(Icons.circle, size: 6, color: Color(0xFF25D366));
    }
  } else {
    // For sent messages, show WhatsApp-style double check marks
    switch (message.deliveryStatus) {
      case DeliveryStatus.sending:
        return const Icon(Icons.access_time, size: 14, color: Colors.grey);
      case DeliveryStatus.sent:
        return const Icon(Icons.done, size: 14, color: Colors.grey);
      case DeliveryStatus.delivered:
        return const Icon(Icons.done_all, size: 14, color: Colors.grey);
      case DeliveryStatus.read:
        return const Icon(Icons.done_all, size: 14, color: Color(0xFF53BDEB));
    }
  }
}
