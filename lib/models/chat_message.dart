enum MessageSender {
  user,
  doctor,
  system, // Untuk pesan otomatis/sistem
}

class ChatMessage {
  final String id;
  final MessageSender sender;
  final String text;
  final bool
  isTyping; // Jika true, UI merender animasi titik-titik (typing indicator)

  const ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    this.isTyping = false,
  });
}
