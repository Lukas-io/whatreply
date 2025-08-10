import 'package:flutter/material.dart';
import '../models/message.dart';
import '../utils/date_utils.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final VoidCallback? onReplyTap;
  final bool showReplyPreview;

  const MessageBubble({
    super.key,
    required this.message,
    this.onReplyTap,
    this.showReplyPreview = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: message.isMe ? 60 : 16,
          right: message.isMe ? 16 : 60,
          top: 4,
          bottom: 4,
        ),
        child: Column(
          crossAxisAlignment: message.isMe 
              ? CrossAxisAlignment.end 
              : CrossAxisAlignment.start,
          children: [
            if (message.replyTo != null && showReplyPreview)
              _buildReplyPreview(context),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isMe 
                    ? const Color(0xFFDCF8C6) // WhatsApp green for sent messages
                    : Colors.white, // White for received messages
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(message.isMe ? 18 : 4),
                  bottomRight: Radius.circular(message.isMe ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 16,
                      color: message.isMe 
                          ? const Color(0xFF0C1317)
                          : const Color(0xFF0C1317),
                      height: 1.3,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        ChatDateUtils.formatMessageTime(message.timestamp),
                        style: TextStyle(
                          fontSize: 11,
                          color: message.isMe 
                              ? const Color(0xFF667781)
                              : const Color(0xFF667781),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if (message.isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.isRead ? Icons.done_all : Icons.done,
                          size: 14,
                          color: message.isRead 
                              ? const Color(0xFF53BDEB) // Blue for read
                              : const Color(0xFF667781), // Grey for unread
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyPreview(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: message.isMe ? 0 : 0,
        right: message.isMe ? 0 : 0,
        bottom: 6,
      ),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: message.isMe 
                ? const Color(0xFF25D366)
                : const Color(0xFF128C7E),
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.replyTo!.isMe ? 'You' : 'John Doe',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF128C7E),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            message.replyTo!.text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
