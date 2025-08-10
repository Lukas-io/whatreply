import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/message.dart';
import '../models/message_brain.dart';
import '../widgets/chat_header.dart';
import '../widgets/messages_list.dart';
import '../widgets/chat_input.dart';
import '../widgets/chat_background_painter.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final MessageBrain _messageBrain = MessageBrain();

  @override
  void initState() {
    super.initState();
    _messageBrain.initialize();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSendMessage(String text, {Message? replyTo}) {
    if (text.trim().isEmpty) return;
    
    print('🔵 ChatScreen: _handleSendMessage called with text: "$text", replyTo: ${replyTo?.text}');
    print('🔵 ChatScreen: Message count before adding: ${_messageBrain.messages.length}');
    
    _messageBrain.addMessage(text, replyTo: replyTo);
    
    print('🔵 ChatScreen: Message count after adding: ${_messageBrain.messages.length}');
    print('🔵 ChatScreen: Latest message: ${_messageBrain.messages.last.text}');
    
    setState(() {});
    
    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleMessageLongPress(Message message) {
    if (message.canReply) {
      _messageBrain.setReplyTo(message);
      setState(() {});
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: ChatHeader(),
      backgroundColor: Color(0XFFF6F1EA),
      body: Column(
        children: [
          MessagesList(
            scrollController: _scrollController,
            messageBrain: _messageBrain,
            onMessageLongPress: _handleMessageLongPress,
            onMessageTap: null,
            onChannelTap: null,
          ),
          ChatInput(
            onSendMessage: _handleSendMessage,
            replyTo: _messageBrain.currentReplyTo,
            onCancelReply: () {
              _messageBrain.clearReplyTo();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
