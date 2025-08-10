import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/message.dart';
import '../widgets/chat_header.dart';
import '../widgets/messages_list.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_actions_sheet.dart';
import '../widgets/chat_background_painter.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  Message? _replyTo;

  @override
  void initState() {
    super.initState();
    _loadSampleMessages();
    // Set iOS status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadSampleMessages() {
    final now = DateTime.now();
    
    // Add some sample messages that match the reference image
    _messages.addAll([
      Message(
        id: '1',
        text: 'Solo Travelling Tips | WhatsApp Channel\n\nSolo Travelling Tips WhatsApp Channel. A safe place to exchange travel experiences, tips, and connect with fellow solo travelers.\n\nFollow the Solo Travelling Tips channel on WhatsApp: https://whatsapp.com/channel/0029VaiLhB58KMqfV1He7u0o',
        timestamp: now.subtract(const Duration(hours: 2, minutes: 25)),
        isMe: true,
      ),
      Message(
        id: '2',
        text: 'Voice call',
        timestamp: now.subtract(const Duration(hours: 2, minutes: 19)),
        isMe: true,
      ),
      Message(
        id: '3',
        text: 'Missed voice call\nTap to call back',
        timestamp: now.subtract(const Duration(hours: 2, minutes: 18)),
        isMe: false,
      ),
      Message(
        id: '4',
        text: 'Hey Alex, what you\'re doing tonight? 👀',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 26)),
        isMe: true,
      ),
      Message(
        id: '5',
        text: 'oh I\'m busy tonight 😔',
        timestamp: now.subtract(const Duration(minutes: 32)),
        isMe: false,
      ),
      Message(
        id: '6',
        text: 'what about tomorrow? I\'m free the whole day!',
        timestamp: now.subtract(const Duration(minutes: 31)),
        isMe: false,
      ),
    ]);
  }

  void _sendMessage(String text, Message? replyTo) {
    if (text.trim().isEmpty) return;

    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      timestamp: DateTime.now(),
      isMe: true,
      replyTo: replyTo,
    );

    setState(() {
      _messages.add(newMessage);
      _replyTo = null;
    });

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

    // Simulate reply after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final replyMessage = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: _getRandomReply(),
          timestamp: DateTime.now(),
          isMe: false,
        );

        setState(() {
          _messages.add(replyMessage);
        });

        // Scroll to bottom for reply
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
    });
  }

  String _getRandomReply() {
    final replies = [
      'That sounds great!',
      'I\'d love to!',
      'Perfect timing!',
      'Count me in!',
      'Sounds like a plan!',
      'Can\'t wait!',
      'That works for me!',
      'Absolutely!',
    ];
    return replies[DateTime.now().millisecond % replies.length];
  }

  void _onMessageLongPress(Message message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => MessageActionsSheet(
        message: message,
        onReply: () {
          setState(() {
            _replyTo = message;
          });
        },
        onCopy: () {
          // TODO: Implement copy functionality
        },
        onForward: () {
          // TODO: Implement forward functionality
        },
      ),
    );
  }

  void _onBack() {
    // TODO: Implement back navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Back navigation coming soon!')),
    );
  }

  void _onVideoCall() {
    // TODO: Implement video call
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Video call feature coming soon!')),
    );
  }

  void _onVoiceCall() {
    // TODO: Implement voice call
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voice call feature coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0), // iOS WhatsApp background
      body: CustomPaint(
        painter: ChatBackgroundPainter(),
        child: Column(
          children: [
            // Chat Header
            ChatHeader(
              contactName: 'Alex Smith',
              status: 'online',
              profileImageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
              onBack: _onBack,
              onVideoCall: _onVideoCall,
              onVoiceCall: _onVoiceCall,
            ),
            
            // Messages List
            MessagesList(
              messages: _messages,
              scrollController: _scrollController,
              onMessageLongPress: _onMessageLongPress,
            ),
            
            // Chat Input
            ChatInput(
              onSendMessage: _sendMessage,
              replyTo: _replyTo,
              onCancelReply: () {
                setState(() {
                  _replyTo = null;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
