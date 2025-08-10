import 'message.dart';

class MessageData {
  static final List<Message> sampleMessages = [
    // Simple conversation messages
    Message.text(
      id: 'msg_1',
      text: 'Hey Alex, how are you doing?',
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
      isMe: true,
      hasEmojis: false,
      deliveryStatus: DeliveryStatus.read,
    ),

    Message.text(
      id: 'msg_2',
      text: 'I\'m good, thanks! How about you',
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 25)),
      isMe: false,
      hasEmojis: false,
      deliveryStatus: DeliveryStatus.read,
    ),

    Message.text(
      id: 'msg_3',
      text: 'Pretty good! Are you free tonight?',
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 20)),
      isMe: true,
      hasEmojis: false,
      deliveryStatus: DeliveryStatus.read,
    ),

    Message.text(
      id: 'msg_4',
      text: 'Actually, I\'m busy tonight 😔',
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 15)),
      isMe: false,
      hasEmojis: true,
      deliveryStatus: DeliveryStatus.read,
    ),

    Message.text(
      id: 'msg_5',
      text: 'What about tomorrow? I\'m free the whole day!',
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 10)),
      isMe: true,
      hasEmojis: true,
      deliveryStatus: DeliveryStatus.read,
    ),

    Message.text(
      id: 'msg_6',
      text: 'That sounds great! What do you have in mind?',
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 5)),
      isMe: false,
      hasEmojis: false,
      deliveryStatus: DeliveryStatus.read,
    ),

    Message.text(
      id: 'msg_7',
      text: 'Maybe we could grab coffee and catch up?',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
      isMe: true,
      hasEmojis: false,
      deliveryStatus: DeliveryStatus.read,
    ),

    Message.text(
      id: 'msg_8',
      text: 'Perfect! I\'d love that ☕️',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
      isMe: false,
      hasEmojis: true,
      deliveryStatus: DeliveryStatus.read,
    ),

    Message.text(
      id: 'msg_9',
      text: 'Great! How about 2 PM at the usual place?',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
      isMe: true,
      hasEmojis: false,
      deliveryStatus: DeliveryStatus.read,
    ),

    Message.text(
      id: 'msg_10',
      text: 'Sounds perfect! See you there 👋',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 40)),
      isMe: false,
      hasEmojis: true,
      deliveryStatus: DeliveryStatus.read,
    ),
  ];

  static final List<String> autoReplies = [
    'That sounds great!',
    'I\'d love to!',
    'Perfect timing!',
    'Count me in!',
    'Sounds like a plan!',
    'Can\'t wait!',
    'That works for me!',
    'Absolutely!',
    'Sounds exciting!',
    'I\'m in!',
  ];

  static final List<String> quickReplies = [
    '👍',
    '👎',
    '❤️',
    '😊',
    '😢',
    '🎉',
    '🔥',
    '💯',
    '✨',
    '🚀',
  ];

  // Get messages by type
  static List<Message> getMessagesByType(MessageType type) {
    return sampleMessages.where((msg) => msg.messageType == type).toList();
  }

  // Get messages for a specific date
  static List<Message> getMessagesForDate(DateTime date) {
    return sampleMessages.where((msg) {
      final msgDate = DateTime(
        msg.timestamp.year,
        msg.timestamp.month,
        msg.timestamp.day,
      );
      final targetDate = DateTime(date.year, date.month, date.day);
      return msgDate == targetDate;
    }).toList();
  }

  // Get unread message count
  static int getUnreadCount() {
    return sampleMessages.where((msg) => !msg.isMe && !msg.isRead).length;
  }

  // Get last message
  static Message? getLastMessage() {
    if (sampleMessages.isEmpty) return null;
    return sampleMessages.last;
  }

  // Get messages with replies
  static List<Message> getMessagesWithReplies() {
    return sampleMessages.where((msg) => msg.replyTo != null).toList();
  }

  // Get messages containing emojis
  static List<Message> getMessagesWithEmojis() {
    return sampleMessages.where((msg) => msg.hasEmojis).toList();
  }

  // Get messages for today
  static List<Message> getTodayMessages() {
    final today = DateTime.now();
    return getMessagesForDate(today);
  }

  // Get messages for yesterday
  static List<Message> getYesterdayMessages() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return getMessagesForDate(yesterday);
  }

  // Get messages for this week
  static List<Message> getThisWeekMessages() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return sampleMessages
        .where(
          (msg) => msg.timestamp.isAfter(
            startOfWeek.subtract(const Duration(days: 1)),
          ),
        )
        .toList();
  }

  // Get messages for this month
  static List<Message> getThisMonthMessages() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    return sampleMessages
        .where(
          (msg) => msg.timestamp.isAfter(
            startOfMonth.subtract(const Duration(days: 1)),
          ),
        )
        .toList();
  }

  // Search messages by text
  static List<Message> searchMessages(String query) {
    final lowercaseQuery = query.toLowerCase();
    return sampleMessages
        .where((msg) => msg.text.toLowerCase().contains(lowercaseQuery))
        .toList();
  }

  // Get message statistics
  static Map<String, int> getMessageStats() {
    final stats = <String, int>{};

    for (final msg in sampleMessages) {
      final type = msg.messageType.toString().split('.').last;
      stats[type] = (stats[type] ?? 0) + 1;
    }

    return stats;
  }

  // Get conversation summary
  static Map<String, dynamic> getConversationSummary() {
    final totalMessages = sampleMessages.length;
    final myMessages = sampleMessages.where((msg) => msg.isMe).length;
    final theirMessages = totalMessages - myMessages;
    final unreadCount = getUnreadCount();
    final lastMessage = getLastMessage();

    return {
      'totalMessages': totalMessages,
      'myMessages': myMessages,
      'theirMessages': theirMessages,
      'unreadCount': unreadCount,
      'lastMessageTime': lastMessage?.timestamp,
      'lastMessageText': lastMessage?.text,
      'hasUnreadMessages': unreadCount > 0,
    };
  }
}
