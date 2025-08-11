import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatreply/widgets/message_widgets.dart';
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
  final FocusNode focusNode = FocusNode();
  bool hasText = false;

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
      hasText = _controller.text.trim().isNotEmpty;
    });
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text, replyTo: widget.replyTo);
      _controller.clear();
      setState(() {
        hasText = false;
      });
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Reply preview
        ReplyPreviewWidget(widget: widget),

        Container(
          decoration: BoxDecoration(
            color: Color(0xffF5F5F5),
            border: widget.replyTo != null
                ? null
                : Border(top: BorderSide(color: Colors.grey, width: 0.2)),
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
                    height: 34,
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(top: 7),
                    child: TextField(
                      controller: _controller,
                      focusNode: focusNode,
                      expands: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,

                        constraints: BoxConstraints(minHeight: 30),

                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),

                      maxLines: null,
                      style: TextStyle(height: 0, fontSize: 15),
                      cursorColor: Colors.black45,

                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                        );
                      },
                  child: hasText
                      ? IconButton(
                          key: const ValueKey('send_button'),
                          onPressed: _sendMessage,
                          icon: Icon(
                            Icons.send,
                            color: Colors.black87,
                            size: 20,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFF1CA961),
                            padding: EdgeInsets.zero,
                          ),
                        )
                      : IconButton(
                          key: const ValueKey('mic_button'),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Voice message feature coming soon!',
                                ),
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
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ReplyPreviewWidget extends StatelessWidget {
  const ReplyPreviewWidget({super.key, required this.widget});

  final ChatInput widget;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0), // Start from bottom
            end: Offset.zero, // End at normal position
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: widget.replyTo != null
          ? Container(
              key: const ValueKey('reply_container'),
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                border: Border(top: BorderSide(color: Colors.grey, width: 0.2)),
              ),
              padding: EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Opacity(
                    opacity: 0,
                    child: IconButton(
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
                  ),
                  Expanded(child: ReplyContainer(widget.replyTo!, maxLines: 1)),
                  IconButton.filled(
                    onPressed: widget.onCancelReply,
                    icon: const Icon(Icons.close, size: 16),
                    padding: EdgeInsets.zero,
                    style: IconButton.styleFrom(
                      backgroundColor: Color(0xFFCACACA),
                      foregroundColor: Color(0xFF6B6C6C),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(key: ValueKey('empty_container')),
    );
  }
}
