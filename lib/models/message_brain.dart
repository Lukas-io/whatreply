import 'dart:math';
import 'package:flutter/material.dart';
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
  bool _isTyping = false;
  String _typingText = '';
  
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
  bool get isTyping => _isTyping;
  String get typingText => _typingText;
  int get totalMessages => _messages.length;
  int get unreadCount => _messages.where((msg) => !msg.isMe && !msg.isRead).length;
  bool get hasUnreadMessages => unreadCount > 0;

  // Initialize with sample data
  void initialize() {
    _messages = List.from(MessageData.sampleMessages);
    _sortMessagesByTimestamp();
  }

  // Add new message
  void addMessage(String text, {Message? replyTo}) {
    print('🟡 MessageBrain: addMessage called with text: "$text", replyTo: ${replyTo?.text}');
    print('🟡 MessageBrain: Current message count: ${_messages.length}');
    
    final newMessage = Message.text(
      id: _generateMessageId(),
      text: text,
      timestamp: DateTime.now(),
      isMe: true,
      replyTo: replyTo,
      hasEmojis: false, // Removed emoji detection to prevent crashes
      deliveryStatus: DeliveryStatus.sending,
    );

    print('🟡 MessageBrain: Created new message: "${newMessage.text}" with ID: ${newMessage.id}');
    
    _messages.add(newMessage);
    
    print('🟡 MessageBrain: Added message to list. New count: ${_messages.length}');
    
    _sortMessagesByTimestamp();
    _clearReplyTo();
    
    // Simulate message delivery progression
    _simulateMessageDelivery(newMessage);
    
    // Simulate auto-reply after a delay
    _scheduleAutoReply();
    
    // Notify UI that messages have changed
    _notifyMessagesChanged();
    
    print('🟡 MessageBrain: addMessage completed. Final count: ${_messages.length}');
  }

  // Add system message (date separator, unread separator, etc.)
  void addSystemMessage(MessageType type, String text, {DateTime? timestamp}) {
    Message systemMessage;
    
    switch (type) {
      case MessageType.dateSeparator:
        systemMessage = Message.dateSeparator(
          id: _generateMessageId(),
          timestamp: timestamp ?? DateTime.now(),
        );
        break;
      case MessageType.unreadSeparator:
        systemMessage = Message.unreadSeparator(
          id: _generateMessageId(),
          timestamp: timestamp ?? DateTime.now(),
          unreadCount: unreadCount,
        );
        break;
      default:
        return;
    }

    _messages.add(systemMessage);
    _sortMessagesByTimestamp();
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

  // Mark message as read
  void markMessageAsRead(String messageId) {
    final index = _messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      _messages[index] = _messages[index].copyWith(isRead: true);
    }
  }

  // Mark all messages as read
  void markAllMessagesAsRead() {
    for (int i = 0; i < _messages.length; i++) {
      if (!_messages[i].isMe) {
        _messages[i] = _messages[i].copyWith(isRead: true);
      }
    }
  }

  // Delete message
  void deleteMessage(String messageId) {
    _messages.removeWhere((msg) => msg.id == messageId);
  }

  // Forward message to another contact
  void forwardMessage(Message message, String targetContact) {
    // Implementation for forwarding messages
    // This could be expanded to actually send to another contact
  }

  // Copy message text
  String copyMessageText(String messageId) {
    final message = _messages.firstWhere((msg) => msg.id == messageId);
    return message.text;
  }

  // Search messages
  List<Message> searchMessages(String query) {
    if (query.isEmpty) return _messages;
    
    final lowercaseQuery = query.toLowerCase();
    return _messages.where((msg) => 
      msg.text.toLowerCase().contains(lowercaseQuery) ||
      (msg.channelName?.toLowerCase().contains(lowercaseQuery) ?? false)
    ).toList();
  }

  // Filter messages by type
  List<Message> filterMessagesByType(MessageType type) {
    return _messages.where((msg) => msg.messageType == type).toList();
  }

  // Filter messages by date range
  List<Message> filterMessagesByDateRange(DateTime start, DateTime end) {
    return _messages.where((msg) => 
      msg.timestamp.isAfter(start.subtract(const Duration(days: 1))) &&
      msg.timestamp.isBefore(end.add(const Duration(days: 1)))
    ).toList();
  }

  // Get messages for today
  List<Message> getTodayMessages() {
    final today = DateTime.now();
    return filterMessagesByDateRange(today, today);
  }

  // Get messages for yesterday
  List<Message> getYesterdayMessages() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return filterMessagesByDateRange(yesterday, yesterday);
  }

  // Get messages for this week
  List<Message> getThisWeekMessages() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return filterMessagesByDateRange(startOfWeek, now);
  }

  // Get messages for this month
  List<Message> getThisMonthMessages() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    return filterMessagesByDateRange(startOfMonth, now);
  }

  // Get call history
  List<Message> getCallHistory() {
    return filterMessagesByType(MessageType.voiceCall);
  }

  // Get missed calls
  List<Message> getMissedCalls() {
    return _messages.where((msg) => 
      msg.messageType == MessageType.voiceCall && 
      msg.callDirection == CallDirection.missed
    ).toList();
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

  // Get conversation statistics
  Map<String, dynamic> getConversationStats() {
    final totalMessages = _messages.length;
    final myMessages = _messages.where((msg) => msg.isMe).length;
    final theirMessages = totalMessages - myMessages;
    final unreadCount = this.unreadCount;
    final lastMessage = _messages.isNotEmpty ? _messages.last : null;
    
    // Count by type
    final typeStats = <String, int>{};
    for (final msg in _messages) {
      final type = msg.messageType.toString().split('.').last;
      typeStats[type] = (typeStats[type] ?? 0) + 1;
    }
    
    // Count calls
    final totalCalls = _messages.where((msg) => msg.isCall).length;
    final missedCalls = getMissedCalls().length;
    final completedCalls = totalCalls - missedCalls;
    
    return {
      'totalMessages': totalMessages,
      'myMessages': myMessages,
      'theirMessages': theirMessages,
      'unreadCount': unreadCount,
      'hasUnreadMessages': unreadCount > 0,
      'lastMessageTime': lastMessage?.timestamp,
      'lastMessageText': lastMessage?.text,
      'typeStats': typeStats,
      'totalCalls': totalCalls,
      'missedCalls': missedCalls,
      'completedCalls': completedCalls,
      'mediaMessages': getMediaMessages().length,
      'linkMessages': getLinkMessages().length,
      'emojiMessages': getEmojiMessages().length,
    };
  }

  // Get message suggestions based on context
  List<String> getMessageSuggestions(String partialText) {
    if (partialText.isEmpty) return [];
    
    final suggestions = <String>[];
    final lowercasePartial = partialText.toLowerCase();
    
    // Add auto-replies that match the partial text
    for (final reply in MessageData.autoReplies) {
      if (reply.toLowerCase().contains(lowercasePartial)) {
        suggestions.add(reply);
      }
    }
    
    // Add quick replies that match
    for (final emoji in MessageData.quickReplies) {
      if (emoji.contains(partialText)) {
        suggestions.add(emoji);
      }
    }
    
    // Add common phrases
    final commonPhrases = [
      'How are you?',
      'What\'s up?',
      'See you later!',
      'Thanks!',
      'You\'re welcome!',
      'Great!',
      'Awesome!',
      'Perfect!',
    ];
    
    for (final phrase in commonPhrases) {
      if (phrase.toLowerCase().contains(lowercasePartial)) {
        suggestions.add(phrase);
      }
    }
    
    return suggestions.take(5).toList();
  }

  // Get quick reply options
  List<String> getQuickReplies() {
    return List.from(MessageData.quickReplies);
  }

  // Set typing indicator
  void setTyping(bool isTyping, {String text = ''}) {
    _isTyping = isTyping;
    _typingText = text;
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
    if (lastMessage.isMe) return; // Don't auto-reply to our own messages
    
    // Random delay between 2-8 seconds
    final delay = 2000 + Random().nextInt(6000);
    
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

  // Get messages grouped by date
  Map<String, List<Message>> getMessagesGroupedByDate() {
    final grouped = <String, List<Message>>{};
    
    for (final message in _messages) {
      final dateKey = _formatDateKey(message.timestamp);
      grouped.putIfAbsent(dateKey, () => []).add(message);
    }
    
    return grouped;
  }

  // Format date key for grouping
  String _formatDateKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);
    
    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else if (messageDate.isAfter(today.subtract(const Duration(days: 7)))) {
      return _getDayName(date.weekday);
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  // Get day name
  String _getDayName(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday - 1];
  }

  // Clear all messages
  void clearAllMessages() {
    _messages.clear();
    _clearReplyTo();
  }

  // Reset to sample data
  void resetToSampleData() {
    clearAllMessages();
    initialize();
  }

  // Export conversation
  String exportConversation() {
    final buffer = StringBuffer();
    buffer.writeln('WhatsApp Conversation Export');
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln('Total Messages: $totalMessages');
    buffer.writeln('Unread Messages: $unreadCount');
    buffer.writeln('=' * 50);
    buffer.writeln();
    
    for (final message in _messages) {
      final time = _formatTime(message.timestamp);
      final sender = message.isMe ? 'You' : 'Alex Smith';
      final type = message.messageType.toString().split('.').last;
      
      buffer.writeln('[$time] $sender ($type):');
      buffer.writeln(message.text);
      buffer.writeln();
    }
    
    return buffer.toString();
  }

  // Format time for export
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  // Get reply information
  String? getReplyInfo() {
    if (_currentReplyTo != null) {
      return 'Replying to: ${_currentReplyTo!.text}';
    }
    return null;
  }

  // Check if currently replying to a message
  bool get isReplying => _currentReplyTo != null;
}
