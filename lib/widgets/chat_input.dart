import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/message.dart';

class ChatInput extends StatefulWidget {
  final Function(String, {Message? replyTo}) onSendMessage;
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
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
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
      widget.onSendMessage(text, replyTo: widget.replyTo);
      _controller.clear();
      setState(() {
        _hasText = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Reply preview
        if (widget.replyTo != null) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(6),
              border: Border(
                left: BorderSide(color: const Color(0xFF25D366), width: 2),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.replyTo!.text,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: widget.onCancelReply,
                  icon: const Icon(
                    Icons.close,
                    size: 16,
                    color: Color(0xFF25D366),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
        Container(
          decoration: BoxDecoration(
            color: Color(0xffF5F5F5),
            border: Border(top: BorderSide(color: Colors.grey, width: 0.2)),
          ),
          child: SafeArea(
            top: false,

            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Attachment feature coming soon!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(
                    CupertinoIcons.add,
                    color: Colors.black87,
                    size: 24,
                  ),
                ),

                // Text input
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey, width: 0.25),
                    ),
                    height: 30,
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(top: 6),
                    child: TextField(
                      controller: _controller,
                      expands: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,

                        constraints: BoxConstraints(minHeight: 30),

                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          // vertical: 12,
                        ),
                      ),

                      maxLines: null,
                      style: TextStyle(height: 0, fontSize: 14),
                      cursorColor: Colors.grey,

                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),

                if (_hasText)
                  IconButton(
                    onPressed: _sendMessage,
                    icon: Icon(Icons.send, color: Colors.white, size: 20),

                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFF15C111),
                      padding: EdgeInsets.zero,
                    ),
                  )
                else
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Voice message feature coming soon!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: Icon(
                      CupertinoIcons.mic,
                      color: Colors.black87,
                      size: 24,
                    ),

                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
