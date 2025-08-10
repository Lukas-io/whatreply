class Message {
  final String id;
  final String text;
  final DateTime timestamp;
  final bool isMe;
  final Message? replyTo;
  final bool isRead;

  Message({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.isMe,
    this.replyTo,
    this.isRead = false,
  });

  Message copyWith({
    String? id,
    String? text,
    DateTime? timestamp,
    bool? isMe,
    Message? replyTo,
    bool? isRead,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isMe: isMe ?? this.isMe,
      replyTo: replyTo ?? this.replyTo,
      isRead: isRead ?? this.isRead,
    );
  }
}
