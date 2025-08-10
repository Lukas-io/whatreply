import 'package:flutter/material.dart';
import '../models/message.dart';

class ChatInput extends StatefulWidget {
  final Function(String text, Message? replyTo) onSendMessage;
  final Message? replyTo;
  final VoidCallback? onCancelReply;

  const ChatInput({
    super.key,
    required this.onSendMessage,
    this.replyTo,
    this.onCancelReply,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;
    
    widget.onSendMessage(text.trim(), widget.replyTo);
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
  }

  void _handleTextChanged(String text) {
    setState(() {
      _isComposing = text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Reply preview
            if (widget.replyTo != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withValues(alpha: 0.15),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 3,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF25D366),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.replyTo!.isMe ? 'You' : 'John Doe',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF128C7E),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.replyTo!.text,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onCancelReply,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Color(0xFF667781),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            // Input field
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Emoji button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // TODO: Implement emoji picker
                      },
                      icon: const Icon(
                        Icons.emoji_emotions_outlined,
                        color: Color(0xFF667781),
                        size: 24,
                      ),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 44,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Text input
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.1),
                          width: 0.5,
                        ),
                      ),
                      child: TextField(
                        controller: _textController,
                        onChanged: _handleTextChanged,
                        onSubmitted: _handleSubmitted,
                        decoration: const InputDecoration(
                          hintText: 'Message',
                          hintStyle: TextStyle(
                            color: Color(0xFF667781),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Send button
                  Container(
                    decoration: BoxDecoration(
                      color: _isComposing 
                          ? const Color(0xFF25D366)
                          : Colors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: IconButton(
                      onPressed: _isComposing 
                          ? () => _handleSubmitted(_textController.text)
                          : null,
                      icon: Icon(
                        _isComposing ? Icons.send : Icons.send,
                        color: _isComposing 
                            ? Colors.white
                            : Colors.grey.withValues(alpha: 0.4),
                        size: 20,
                      ),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 44,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
