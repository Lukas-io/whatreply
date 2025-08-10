import 'package:flutter/material.dart';

enum MessageType {
  text,
  voiceCall,
  videoCall,
  image,
  document,
  location,
  contact,
  channel,
  dateSeparator,
  unreadSeparator,
  system,
}

enum CallDirection {
  incoming,
  outgoing,
  missed,
}

enum CallStatus {
  completed,
  missed,
  declined,
  busy,
}

enum DeliveryStatus {
  sending,
  sent,
  delivered,
  read,
}

class Message {
  final String id;
  final String text;
  final DateTime timestamp;
  final bool isMe;
  final bool isRead;
  final Message? replyTo;
  final MessageType messageType;
  final DeliveryStatus deliveryStatus;
  
  // Call-specific properties
  final String? callDuration;
  final CallDirection? callDirection;
  final CallStatus? callStatus;
  
  // Media properties
  final String? mediaUrl;
  final String? mediaThumbnail;
  final String? mediaCaption;
  final int? mediaSize; // in bytes
  
  // Link properties
  final bool hasLink;
  final String? linkText;
  final String? linkUrl;
  final String? linkPreview;
  
  // Action properties
  final bool hasAction;
  final String? actionText;
  final VoidCallback? actionCallback;
  
  // Content properties
  final bool hasEmojis;
  final List<String>? mentionedUsers;
  final Map<String, dynamic>? metadata;
  
  // Unread separator properties
  final int? unreadCount;
  
  // Channel properties
  final String? channelName;
  final String? channelAvatar;
  final int? channelSubscribers;

  Message({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.isMe,
    this.isRead = false,
    this.replyTo,
    this.messageType = MessageType.text,
    this.deliveryStatus = DeliveryStatus.sending,
    this.callDuration,
    this.callDirection,
    this.callStatus,
    this.mediaUrl,
    this.mediaThumbnail,
    this.mediaCaption,
    this.mediaSize,
    this.hasLink = false,
    this.linkText,
    this.linkUrl,
    this.linkPreview,
    this.hasAction = false,
    this.actionText,
    this.actionCallback,
    this.hasEmojis = false,
    this.mentionedUsers,
    this.metadata,
    this.unreadCount,
    this.channelName,
    this.channelAvatar,
    this.channelSubscribers,
  });

  // Factory constructor for text messages
  factory Message.text({
    required String id,
    required String text,
    required DateTime timestamp,
    required bool isMe,
    bool isRead = false,
    Message? replyTo,
    DeliveryStatus deliveryStatus = DeliveryStatus.sending,
    bool hasEmojis = false,
    List<String>? mentionedUsers,
  }) {
    return Message(
      id: id,
      text: text,
      timestamp: timestamp,
      isMe: isMe,
      isRead: isRead,
      replyTo: replyTo,
      messageType: MessageType.text,
      deliveryStatus: deliveryStatus,
      hasEmojis: hasEmojis,
      mentionedUsers: mentionedUsers,
    );
  }

  // Factory constructor for call messages
  factory Message.call({
    required String id,
    required String text,
    required DateTime timestamp,
    required bool isMe,
    required CallDirection direction,
    required CallStatus status,
    String? duration,
    bool isRead = false,
  }) {
    return Message(
      id: id,
      text: text,
      timestamp: timestamp,
      isMe: isMe,
      isRead: isRead,
      messageType: direction == CallDirection.incoming ? MessageType.voiceCall : MessageType.videoCall,
      deliveryStatus: DeliveryStatus.sent,
      callDirection: direction,
      callStatus: status,
      callDuration: duration,
    );
  }

  // Factory constructor for channel messages
  factory Message.channel({
    required String id,
    required String text,
    required DateTime timestamp,
    required String channelName,
    String? channelAvatar,
    int? channelSubscribers,
    bool hasLink = false,
    String? linkText,
    String? linkUrl,
    String? linkPreview,
    bool isRead = false,
  }) {
    return Message(
      id: id,
      text: text,
      timestamp: timestamp,
      isMe: false,
      isRead: isRead,
      messageType: MessageType.channel,
      deliveryStatus: DeliveryStatus.sent,
      channelName: channelName,
      channelAvatar: channelAvatar,
      channelSubscribers: channelSubscribers,
      hasLink: hasLink,
      linkText: linkText,
      linkUrl: linkUrl,
      linkPreview: linkPreview,
    );
  }

  // Factory constructor for date separators
  factory Message.dateSeparator({
    required String id,
    required DateTime timestamp,
  }) {
    return Message(
      id: id,
      text: _formatDate(timestamp),
      timestamp: timestamp,
      isMe: false,
      messageType: MessageType.dateSeparator,
      deliveryStatus: DeliveryStatus.sent,
    );
  }

  // Factory constructor for unread separators
  factory Message.unreadSeparator({
    required String id,
    required DateTime timestamp,
    required int unreadCount,
  }) {
    return Message(
      id: id,
      text: 'Unread messages',
      timestamp: timestamp,
      isMe: false,
      messageType: MessageType.unreadSeparator,
      deliveryStatus: DeliveryStatus.sent,
      unreadCount: unreadCount,
    );
  }

  // Factory constructor for system messages
  factory Message.system({
    required String id,
    required String text,
    required DateTime timestamp,
  }) {
    return Message(
      id: id,
      text: text,
      timestamp: timestamp,
      isMe: false,
      messageType: MessageType.system,
      deliveryStatus: DeliveryStatus.sent,
    );
  }

  // Helper method to format date for separators
  static String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  // Computed properties
  bool get canReply => messageType == MessageType.text || 
                      messageType == MessageType.voiceCall || 
                      messageType == MessageType.videoCall || 
                      messageType == MessageType.channel;
  
  IconData? get displayIcon {
    switch (messageType) {
      case MessageType.voiceCall:
        return Icons.call;
      case MessageType.videoCall:
        return Icons.videocam;
      default:
        return null;
    }
  }
  
  Color? get displayColor {
    switch (messageType) {
      case MessageType.voiceCall:
      case MessageType.videoCall:
        switch (callStatus) {
          case CallStatus.completed:
            return const Color(0xFF25D366);
          case CallStatus.missed:
            return const Color(0xFFFF3B30);
          case CallStatus.declined:
          case CallStatus.busy:
            return Colors.orange;
          default:
            return Colors.grey;
        }
      default:
        return null;
    }
  }
  
  String get displayText {
    switch (messageType) {
      case MessageType.voiceCall:
        switch (callStatus) {
          case CallStatus.completed:
            return 'Voice call';
          case CallStatus.missed:
            return 'Missed voice call';
          case CallStatus.declined:
            return 'Voice call declined';
          case CallStatus.busy:
            return 'Voice call busy';
          default:
            return 'Voice call';
        }
      case MessageType.videoCall:
        switch (callStatus) {
          case CallStatus.completed:
            return 'Video call';
          case CallStatus.missed:
            return 'Missed video call';
          case CallStatus.declined:
            return 'Video call declined';
          case CallStatus.busy:
            return 'Video call busy';
          default:
            return 'Video call';
        }
      default:
        return text;
    }
  }

  // Copy with method for easy modifications
  Message copyWith({
    String? id,
    String? text,
    DateTime? timestamp,
    bool? isMe,
    bool? isRead,
    Message? replyTo,
    MessageType? messageType,
    DeliveryStatus? deliveryStatus,
    String? callDuration,
    CallDirection? callDirection,
    CallStatus? callStatus,
    String? mediaUrl,
    String? mediaThumbnail,
    String? mediaCaption,
    int? mediaSize,
    bool? hasLink,
    String? linkText,
    String? linkUrl,
    String? linkPreview,
    bool? hasAction,
    String? actionText,
    VoidCallback? actionCallback,
    bool? hasEmojis,
    List<String>? mentionedUsers,
    Map<String, dynamic>? metadata,
    int? unreadCount,
    String? channelName,
    String? channelAvatar,
    int? channelSubscribers,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isMe: isMe ?? this.isMe,
      isRead: isRead ?? this.isRead,
      replyTo: replyTo ?? this.replyTo,
      messageType: messageType ?? this.messageType,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      callDuration: callDuration ?? this.callDuration,
      callDirection: callDirection ?? this.callDirection,
      callStatus: callStatus ?? this.callStatus,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaThumbnail: mediaThumbnail ?? this.mediaThumbnail,
      mediaCaption: mediaCaption ?? this.mediaCaption,
      mediaSize: mediaSize ?? this.mediaSize,
      hasLink: hasLink ?? this.hasLink,
      linkText: linkText ?? this.linkText,
      linkUrl: linkUrl ?? this.linkUrl,
      linkPreview: linkPreview ?? this.linkPreview,
      hasAction: hasAction ?? this.hasAction,
      actionText: actionText ?? this.actionText,
      actionCallback: actionCallback ?? this.actionCallback,
      hasEmojis: hasEmojis ?? this.hasEmojis,
      mentionedUsers: mentionedUsers ?? this.mentionedUsers,
      metadata: metadata ?? this.metadata,
      unreadCount: unreadCount ?? this.unreadCount,
      channelName: channelName ?? this.channelName,
      channelAvatar: channelAvatar ?? this.channelAvatar,
      channelSubscribers: channelSubscribers ?? this.channelSubscribers,
    );
  }

  // Helper methods
  bool get isCall => messageType == MessageType.voiceCall || messageType == MessageType.videoCall;
  bool get isMedia => messageType == MessageType.image || messageType == MessageType.document;
  bool get isSystem => messageType == MessageType.system || messageType == MessageType.dateSeparator || messageType == MessageType.unreadSeparator;
  bool get canForward => !isSystem && messageType != MessageType.dateSeparator && messageType != MessageType.unreadSeparator;
  bool get canCopy => !isSystem && messageType != MessageType.dateSeparator && messageType != MessageType.unreadSeparator;
  
  @override
  String toString() {
    return 'Message(id: $id, text: $text, type: $messageType, isMe: $isMe, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Message && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
