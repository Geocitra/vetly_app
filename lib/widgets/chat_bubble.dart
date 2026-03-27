import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../core/constants/theme.dart';
import 'typing_indicator.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    // Pesan Sistem (Tengah, Abu-abu pudar)
    if (message.sender == MessageSender.system) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message.text,
              style: const TextStyle(
                fontSize: 12,
                color: velyTheme.textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    final isUser = message.sender == MessageSender.user;

    // Perbaikan Bentuk Bubble Asimetris (Premium UX)
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      // Sudut lancip di kiri bawah untuk dokter, kanan bawah untuk user
      bottomLeft: Radius.circular(isUser ? 18 : 4),
      bottomRight: Radius.circular(isUser ? 4 : 18),
    );

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          // Warna User: Teal Transparan (Immersive), Warna Dokter: Putih Bersih
          color: isUser
              ? velyTheme.primaryTeal.withValues(alpha: 0.9)
              : velyTheme.surfaceWhite,
          borderRadius: borderRadius,
          // Border tipis abu-abu hanya untuk bubble dokter
          border: isUser ? null : Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: isUser
                  ? velyTheme.primaryTeal.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: message.isTyping
            ? const TypingIndicator()
            : Text(
                message.text,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  // Kontras teks disesuaikan dengan warna bubble
                  color: isUser ? velyTheme.surfaceWhite : velyTheme.textDark,
                  height: 1.4, // Line height yang nyaman dibaca (Calm UI)
                ),
              ),
      ),
    );
  }
}
