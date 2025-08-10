import 'package:flutter/material.dart';
import '../models/message.dart';
import '../utils/date_utils.dart';

// Simple message widget with minimal UI
class MessageWidget extends StatelessWidget {
  final Message message;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Function(Message)? onSwipeToReply;

  MessageWidget({
    super.key,
    required this.message,
    this.onTap,
    this.onLongPress,
    this.onSwipeToReply,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(message.id),
      direction: DismissDirection.startToEnd,
      // Swipe right to reply
      confirmDismiss: (direction) async {
        // Trigger reply action
        onSwipeToReply!(message);
        return false; // Don't actually dismiss the message
      },
      background: _buildSwipeBackground(),
      child: GestureDetector(
        onTap: onTap,
        // onLongPress: onLongPress,
        child: Padding(
          padding: EdgeInsets.only(
            left: message.isMe ? 60 : 16,
            right: message.isMe ? 16 : 60,
            top: 4,
            bottom: 4,
          ),
          child: TextMessage(message),
        ),
      ),
    );
  }

  final color = Color(0XFFD0FECF);

  Widget _buildSwipeBackground() {
    return Container(
      margin: EdgeInsets.only(
        left: message.isMe ? 60 : 16,
        right: message.isMe ? 16 : 60,
        top: 4,
        bottom: 4,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.reply, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildCallMessage(BuildContext context) {
    final icon = message.displayIcon;
    final color = message.displayColor ?? Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: message.isMe ? const Color(0xFFDCF8C6) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
          ],
          Text(
            message.displayText,
            style: TextStyle(fontSize: 16, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.channelName ?? 'Channel',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0C1317),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message.text,
            style: const TextStyle(fontSize: 14, color: Color(0xFF0C1317)),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSeparator(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey.withValues(alpha: 0.3))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              message.text,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey.withValues(alpha: 0.3))),
        ],
      ),
    );
  }

  Widget _buildUnreadSeparator(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.orange.withValues(alpha: 0.5))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message.text,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.orange.withValues(alpha: 0.5))),
        ],
      ),
    );
  }
}

class TextMessage extends StatelessWidget {
  final Message message;

  const TextMessage(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
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
          default:
            return const Icon(Icons.circle, size: 6, color: Colors.grey);
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
            return const Icon(
              Icons.done_all,
              size: 14,
              color: Color(0xFF53BDEB),
            );
        }
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: message.isMe ? const Color(0xffD0FECF) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: message.isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          // Reply preview
          if (message.replyTo != null) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border(
                  left: BorderSide(color: Colors.black38, width: 2),
                ),
              ),
              child: Text(
                message.replyTo!.text,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.withValues(alpha: 0.8),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          Text(
            message.text,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF0C1317),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            // Always right-align the time row
            children: [
              if (!message.isMe) ...[
                // For received messages, show status on the left
                buildMessageStatus(message, isReceived: true),
                const SizedBox(width: 4),
              ],
              Text(
                ChatDateUtils.formatMessageTime(message.timestamp),
                style: const TextStyle(fontSize: 11, color: Color(0xFF667781)),
              ),
              if (message.isMe) ...[
                // For sent messages, show status on the right
                const SizedBox(width: 4),
                buildMessageStatus(message, isReceived: false),
              ],
            ],
          ),
          // Swipe hint for text messages that can be replied to
          if (message.messageType == MessageType.text && message.canReply) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.swipe_right,
                  size: 12,
                  color: Colors.grey.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 4),
                Text(
                  'Swipe right to reply',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.withValues(alpha: 0.5),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
