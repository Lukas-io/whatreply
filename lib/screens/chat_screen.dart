import 'package:flutter/material.dart';
import '../models/message.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input.dart';
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
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadSampleMessages() {
    final now = DateTime.now();
    
    // Add some sample messages
    _messages.addAll([
      Message(
        id: '1',
        text: 'Hey! How are you doing?',
        timestamp: now.subtract(const Duration(minutes: 30)),
        isMe: false,
      ),
      Message(
        id: '2',
        text: 'I\'m doing great! Just finished working on a new project.',
        timestamp: now.subtract(const Duration(minutes: 25)),
        isMe: true,
      ),
      Message(
        id: '3',
        text: 'That sounds exciting! What kind of project is it?',
        timestamp: now.subtract(const Duration(minutes: 20)),
        isMe: false,
      ),
      Message(
        id: '4',
        text: 'It\'s a Flutter app with some really cool features. I\'ll show you when it\'s ready!',
        timestamp: now.subtract(const Duration(minutes: 15)),
        isMe: true,
      ),
      Message(
        id: '5',
        text: 'Can\'t wait to see it! Flutter is amazing for cross-platform development.',
        timestamp: now.subtract(const Duration(minutes: 10)),
        isMe: false,
      ),
      Message(
        id: '6',
        text: 'Exactly! The hot reload feature alone makes development so much faster.',
        timestamp: now.subtract(const Duration(minutes: 5)),
        isMe: true,
      ),
      Message(
        id: '7',
        text: 'I totally agree. Have you tried the new Material 3 components?',
        timestamp: now.subtract(const Duration(minutes: 2)),
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
      'That\'s interesting!',
      'Tell me more about it.',
      'Sounds great!',
      'I\'d love to see it.',
      'That\'s awesome!',
      'Keep me updated!',
      'Looking forward to it!',
      'Can\'t wait!',
    ];
    return replies[DateTime.now().millisecond % replies.length];
  }

  void _onMessageLongPress(Message message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
                setState(() {
                  _replyTo = message;
                });
                Navigator.pop(context);
              },
            ),
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
                // TODO: Implement copy functionality
                Navigator.pop(context);
              },
            ),
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
                // TODO: Implement forward functionality
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomPaint(
        painter: ChatBackgroundPainter(),
        child: Column(
          children: [
            // App Bar - iOS Style
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF075E54),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      // Profile Image
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            image: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'John Doe',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF4CAF50),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'online',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // iOS Style Call Buttons
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: () {
                            // TODO: Implement video call
                          },
                          icon: const Icon(
                            Icons.video_call,
                            color: Colors.white,
                            size: 22,
                          ),
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: () {
                            // TODO: Implement voice call
                          },
                          icon: const Icon(
                            Icons.call,
                            color: Colors.white,
                            size: 22,
                          ),
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: () {
                            // TODO: Implement more options
                          },
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 22,
                          ),
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(top: 16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return GestureDetector(
                    onLongPress: () => _onMessageLongPress(message),
                    child: MessageBubble(
                      message: message,
                      showReplyPreview: true,
                    ),
                  );
                },
              ),
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
