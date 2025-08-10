import 'package:flutter/material.dart';
import '../models/message.dart';

class ChatInput extends StatefulWidget {
  final Function(String, Message?) onSendMessage;
  final Message? replyTo;
  final VoidCallback onCancelReply;

  const ChatInput({
    super.key,
    required this.onSendMessage,
    this.replyTo,
    required this.onCancelReply,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _controller.text.trim().isNotEmpty;
    });
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text, widget.replyTo);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withValues(alpha: 0.1),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 3,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF25D366),
                        borderRadius: BorderRadius.circular(1.5),
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
                              fontSize: 13,
                              color: Color(0xFF25D366),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.replyTo!.text,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onCancelReply,
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFF667781),
                        size: 18,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ),
              ),
            
            // Input field
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Plus button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // TODO: Implement attachment menu
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Color(0xFF667781),
                        size: 22,
                      ),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Text input field
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.1),
                          width: 0.5,
                        ),
                      ),
                      child: TextField(
                        controller: _controller,
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
                            vertical: 10,
                          ),
                        ),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Send button
                  Container(
                    decoration: BoxDecoration(
                      color: _hasText
                          ? const Color(0xFF25D366)
                          : Colors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: _hasText ? _sendMessage : null,
                      icon: Icon(
                        _hasText ? Icons.send : Icons.mic,
                        color: _hasText
                            ? Colors.white
                            : Colors.grey.withValues(alpha: 0.4),
                        size: 18,
                      ),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
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
