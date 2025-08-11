import 'dart:math';
import 'package:flutter/foundation.dart';
import 'message.dart';
import 'message_data.dart';

class MessageBrain {
  // Temporarily removing singleton pattern for debugging
  // static final MessageBrain _instance = MessageBrain._internal();
  // factory MessageBrain() => _instance;
  // MessageBrain._internal() {
  //   print('MessageBrain._internal() called. Hash: ${hashCode}');
  // }

  // Current conversation state
  List<Message> _messages = [];
  Message? _currentReplyTo;

  // Callback for UI updates
  VoidCallback? _onMessagesChanged;

  // Set callback for UI updates
  void setMessagesChangedCallback(VoidCallback callback) {
    _onMessagesChanged = callback;
  }

  // Notify UI that messages have changed
  void _notifyMessagesChanged() {
    _onMessagesChanged?.call();
  }

  // Getters
  List<Message> get messages => List.unmodifiable(_messages);

  Message? get currentReplyTo => _currentReplyTo;

  int get totalMessages => _messages.length;

  int get unreadCount =>
      _messages.where((msg) => !msg.isMe && !msg.isRead).length;

  bool get hasUnreadMessages => unreadCount > 0;

  // Initialize with sample data
  void initialize() {
    _messages = List.from(MessageData.sampleMessages);
    _sortMessagesByTimestamp();
  }

  // Add new message
  void addMessage(String text, {Message? replyTo}) {
    final newMessage = Message.text(
      id: _generateMessageId(),
      text: text,
      timestamp: DateTime.now(),
      isMe: true,
      replyTo: replyTo,
      hasEmojis: false,
      // Removed emoji detection to prevent crashes
      deliveryStatus: DeliveryStatus.sending,
    );

    _messages.add(newMessage);

    _sortMessagesByTimestamp();
    _clearReplyTo();

    // Simulate message delivery progression
    _simulateMessageDelivery(newMessage);

    // // Simulate auto-reply after a delay
    // _scheduleAutoReply();

    // Notify UI that messages have changed
    _notifyMessagesChanged();

    print(
      '🟡 MessageBrain: addMessage completed. Final count: ${_messages.length}',
    );
  }

  // Set reply to message
  void setReplyTo(Message message) {
    if (message.canReply) {
      _currentReplyTo = message;
      _notifyMessagesChanged();
    } else {
      // Handle other message types if needed
    }
  }

  // Clear reply to
  void _clearReplyTo() {
    _currentReplyTo = null;
  }

  // Remove reply to
  void clearReplyTo() {
    _clearReplyTo();
    _notifyMessagesChanged();
  }

  // Get messages with media
  List<Message> getMediaMessages() {
    return _messages.where((msg) => msg.isMedia).toList();
  }

  // Get messages with links
  List<Message> getLinkMessages() {
    return _messages.where((msg) => msg.hasLink).toList();
  }

  // Get messages with emojis
  List<Message> getEmojiMessages() {
    return _messages.where((msg) => msg.hasEmojis).toList();
  }

  // Generate unique message ID
  String _generateMessageId() {
    final random = Random();
    return 'msg_${DateTime.now().millisecondsSinceEpoch}_${random.nextInt(1000)}';
  }

  // Sort messages by timestamp
  void _sortMessagesByTimestamp() {
    _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  // Schedule auto-reply
  void _scheduleAutoReply() {
    if (_messages.isEmpty) return;

    final lastMessage = _messages.last;
    if (!lastMessage.isMe) return; // Only auto-reply to user messages

    // Random delay between 3-12 seconds
    final delay = 3000 + Random().nextInt(6000);

    Future.delayed(Duration(milliseconds: delay), () {
      _addAutoReply();
    });
  }

  // Add auto-reply
  void _addAutoReply() {
    if (_messages.isEmpty) return;

    final lastMessage = _messages.last;
    if (!lastMessage.isMe) return; // Only auto-reply to user messages

    final autoReplies = [
      'Thanks for your message! I\'ll get back to you soon.',
      'Got it! I\'ll respond in detail later.',
      'Thanks! I\'ll reply when I have a moment.',
      'Received! I\'ll get back to you shortly.',
      'Thanks for reaching out! I\'ll respond soon.',
    ];

    final randomReply = autoReplies[Random().nextInt(autoReplies.length)];

    final replyMessage = Message.text(
      id: _generateMessageId(),
      text: randomReply,
      timestamp: DateTime.now(),
      isMe: false,
      deliveryStatus: DeliveryStatus.sending,
    );

    _messages.add(replyMessage);
    _sortMessagesByTimestamp();

    // Notify UI that messages have changed
    _notifyMessagesChanged();

    // Simulate auto-reply delivery progression
    _simulateAutoReplyDelivery(replyMessage);
  }

  // Simulate message delivery progression
  void _simulateMessageDelivery(Message message) {
    // Message sent (single tick)
    Future.delayed(const Duration(milliseconds: 500), () {
      _updateMessageStatus(message.id, DeliveryStatus.sent);
    });

    // Message delivered (double tick, grey)
    Future.delayed(const Duration(milliseconds: 1500), () {
      _updateMessageStatus(message.id, DeliveryStatus.delivered);
    });

    // Message read (double tick, blue) - happens after auto-reply
    Future.delayed(const Duration(milliseconds: 3000), () {
      _updateMessageStatus(message.id, DeliveryStatus.read);
    });
  }

  // Update message delivery status
  void _updateMessageStatus(String messageId, DeliveryStatus status) {
    final index = _messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      final message = _messages[index];
      _messages[index] = message.copyWith(deliveryStatus: status);
      _notifyMessagesChanged();
    }
  }

  // Simulate auto-reply delivery progression
  void _simulateAutoReplyDelivery(Message message) {
    // Auto-reply sent (single tick)
    Future.delayed(const Duration(milliseconds: 300), () {
      _updateMessageStatus(message.id, DeliveryStatus.sent);
    });

    // Auto-reply delivered (double tick, grey)
    Future.delayed(const Duration(milliseconds: 800), () {
      _updateMessageStatus(message.id, DeliveryStatus.delivered);
    });

    // Auto-reply read (double tick, blue) - happens when user sees it
    Future.delayed(const Duration(milliseconds: 2000), () {
      _updateMessageStatus(message.id, DeliveryStatus.read);
    });
  }
}
