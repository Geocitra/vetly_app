import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../core/constants/theme.dart';
import 'typing_indicator.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    // Penanganan khusus untuk pesan sistem (contoh: "Menghubungkan...")
    if (message.sender == MessageSender.system) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: Text(
            message.text,
            style: const TextStyle(
              fontSize: 12,
              color: VetlyTheme.textGrey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    final isUser = message.sender == MessageSender.user;
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
      bottomRight: isUser ? Radius.zero : const Radius.circular(16),
    );

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? VetlyTheme.primaryTeal : VetlyTheme.surfaceWhite,
          borderRadius: borderRadius,
          border: isUser ? null : Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: message.isTyping
            ? const TypingIndicator()
            : Text(
                message.text,
                style: TextStyle(
                  fontSize: 14,
                  color: isUser ? VetlyTheme.surfaceWhite : VetlyTheme.textDark,
                  height: 1.4,
                ),
              ),
      ),
    );
  }
}
