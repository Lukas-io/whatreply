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
      oldWidget.messageBrain.setMessagesChangedCallback(() {});
      widget.messageBrain.setMessagesChangedCallback(() {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    widget.messageBrain.setMessagesChangedCallback(() {});
    super.dispose();
  }

  int getTotalItemCount() {
    // Add 1 for the date chip if there are messages
    return widget.messageBrain.messages.isNotEmpty
        ? widget.messageBrain.messages.length + 1
        : 0;
  }

  bool shouldShowDateChip(int index) {
    // Show date chip at the beginning
    return index == 0 && widget.messageBrain.messages.isNotEmpty;
  }

  int getMessageIndex(int listIndex) {
    // Adjust index to account for date chip
    return shouldShowDateChip(0) ? listIndex - 1 : listIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        key: ValueKey('messages_2'),
        controller: widget.scrollController,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: getTotalItemCount(),
        itemBuilder: (context, index) {
          // Check if this should be a date chip
          if (shouldShowDateChip(index)) {
            return DateChip(text: 'Today');
          }

          // Get the actual message index (accounting for date chips)
          final messageIndex = getMessageIndex(index);
          final message = widget.messageBrain.messages[messageIndex];

          return MessageWidget(
            message: message,
            onLongPress: message.canReply
                ? () => widget.onMessageLongPress(message)
                : null,
            onTap: widget.onMessageTap != null
                ? () => widget.onMessageTap!(message)
                : null,
            onSwipeToReply: message.canReply
                ? (message) => widget.onMessageLongPress(message)
                : null,
          );
        },
      ),
    );
  }
}

class DateChip extends StatelessWidget {
  final String text;

  const DateChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        decoration: BoxDecoration(
          color: Color(0XFFFBFAFA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0XFFFBFAF9), width: 0.5),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0XFF323232),
          ),
        ),
      ),
    );
  }
}
