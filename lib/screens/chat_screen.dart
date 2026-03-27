import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chat_message.dart';
import '../providers/triage_provider.dart';
import '../core/constants/theme.dart';
import '../core/utils/responsive_wrapper.dart';
import '../widgets/chat_bubble.dart';
import 'summary_screen.dart';

class ChatScreen extends StatefulWidget {
  // 1. Perbaikan Super Parameter
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _startSimulationSequence();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _addMessage(ChatMessage msg) {
    if (mounted) {
      setState(() => _messages.add(msg));
      _scrollToBottom();
    }
  }

  void _removeTypingIndicator() {
    if (mounted) {
      setState(() => _messages.removeWhere((m) => m.isTyping));
    }
  }

  Future<void> _startSimulationSequence() async {
    // 1. Pesan Sistem Awal
    _addMessage(
      const ChatMessage(
        id: 'sys1',
        sender: MessageSender.system,
        text: 'Menghubungkan dengan Dr. Budi Santoso...',
      ),
    );

    // 2. Delay & Dokter Mengetik
    await Future.delayed(const Duration(milliseconds: 1500));
    _removeTypingIndicator();
    _addMessage(
      const ChatMessage(
        id: 't1',
        sender: MessageSender.doctor,
        text: '',
        isTyping: true,
      ),
    );

    // 3. Pesan Pembuka Dinamis dari Provider
    await Future.delayed(const Duration(milliseconds: 2000));

    // 2. Perbaikan BuildContext Synchronously
    // Mencegah akses context jika layar sudah ditutup pengguna saat jeda 2 detik
    if (!mounted) return;

    _removeTypingIndicator();
    final doctorGreeting = context
        .read<TriageProvider>()
        .generateDoctorOpeningMessage();
    _addMessage(
      ChatMessage(
        id: 'msg1',
        sender: MessageSender.doctor,
        text: doctorGreeting,
      ),
    );

    // 4. Dokter Mengetik Saran Lanjutan
    await Future.delayed(const Duration(milliseconds: 1000));
    _addMessage(
      const ChatMessage(
        id: 't2',
        sender: MessageSender.doctor,
        text: '',
        isTyping: true,
      ),
    );

    // 5. Pesan Saran
    await Future.delayed(const Duration(milliseconds: 2500));
    _removeTypingIndicator();
    _addMessage(
      const ChatMessage(
        id: 'msg2',
        sender: MessageSender.doctor,
        text:
            'Sebagai langkah awal sebelum observasi lebih lanjut, tolong berikan air minum sedikit-sedikit saja dan siapkan area yang hangat untuknya beristirahat ya.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Menambahkan foto Dr. Budi di sebelah nama
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('lib/public/images/dokter.jpg'),
              radius: 18,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Dr. Budi Santoso', style: TextStyle(fontSize: 16)),
                Text(
                  'Dokter Hewan Online',
                  style: TextStyle(
                    fontSize: 12,
                    color: VetlyTheme.primaryTeal.withValues(alpha: 0.8),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SummaryScreen()),
              );
            },
            child: const Text(
              'Selesaikan',
              style: TextStyle(
                color: VetlyTheme.primaryTeal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: ResponsiveWrapper(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: _messages.length,
                itemBuilder: (context, index) =>
                    ChatBubble(message: _messages[index]),
              ),
            ),
            _buildSimulatedInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildSimulatedInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: VetlyTheme.surfaceWhite,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            const Icon(
              Icons.add_circle_outline,
              color: VetlyTheme.textGrey,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: VetlyTheme.backgroundLight,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Text(
                  'Ketik pesan...',
                  style: TextStyle(color: VetlyTheme.textGrey, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const CircleAvatar(
              backgroundColor: VetlyTheme.primaryTeal,
              radius: 20,
              child: Icon(Icons.send, color: VetlyTheme.surfaceWhite, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
