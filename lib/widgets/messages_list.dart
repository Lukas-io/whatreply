import 'package:flutter/material.dart';
import '../models/message.dart';
import '../models/message_brain.dart';
import 'message_widgets.dart';
import 'chat_background_painter.dart';

class MessagesList extends StatefulWidget {
  final ScrollController scrollController;
  final MessageBrain messageBrain;
  final Function(Message) onMessageLongPress;
  final Function(Message)? onMessageTap;
  final Function(Message)? onChannelTap;

  const MessagesList({
    super.key,
    required this.scrollController,
    required this.messageBrain,
    required this.onMessageLongPress,
    this.onMessageTap,
    this.onChannelTap,
  });

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  @override
  void initState() {
    super.initState();
    // Set up callback to listen for message changes
    widget.messageBrain.setMessagesChangedCallback(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didUpdateWidget(MessagesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update callback if MessageBrain instance changes
    if (oldWidget.messageBrain != widget.messageBrain) {
      oldWidget.messageBrain.setMessagesChangedCallback((){});
      widget.messageBrain.setMessagesChangedCallback(() {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    widget.messageBrain.setMessagesChangedCallback((){});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: ListView.builder(
        key: ValueKey('messages_${widget.messageBrain.messages.length}'),
        controller: widget.scrollController,
        padding: const EdgeInsets.only(top: 16),
        itemCount: widget.messageBrain.messages.length,
        itemBuilder: (context, index) {
          final message = widget.messageBrain.messages[index];
          return MessageWidget(
          message:   message,
            onLongPress: message.canReply ? () => widget.onMessageLongPress(message) : null,
            onTap: widget.onMessageTap != null ? () => widget.onMessageTap!(message) : null,
            onSwipeToReply: message.canReply ? (message) => widget.onMessageLongPress(message) : null,
          );
        },
      ),
    );
  }
}
