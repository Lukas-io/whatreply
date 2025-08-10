import 'package:flutter/material.dart';
import '../models/message.dart';

class MessageActionsSheet extends StatelessWidget {
  final Message message;
  final VoidCallback onReply;
  final VoidCallback? onCopy;
  final VoidCallback? onForward;

  const MessageActionsSheet({
    super.key,
    required this.message,
    required this.onReply,
    this.onCopy,
    this.onForward,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.reply, color: Color(0xFF25D366), size: 20),
            ),
            title: const Text('Reply', style: TextStyle(fontSize: 16)),
            onTap: () {
              onReply();
              Navigator.pop(context);
            },
          ),
          if (onCopy != null)
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.copy, color: Color(0xFF667781), size: 20),
              ),
              title: const Text('Copy', style: TextStyle(fontSize: 16)),
              onTap: () {
                onCopy!();
                Navigator.pop(context);
              },
            ),
          if (onForward != null)
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.forward, color: Color(0xFF667781), size: 20),
              ),
              title: const Text('Forward', style: TextStyle(fontSize: 16)),
              onTap: () {
                onForward!();
                Navigator.pop(context);
              },
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
