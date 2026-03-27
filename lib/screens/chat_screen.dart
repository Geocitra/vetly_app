import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chat_message.dart';
import '../providers/triage_provider.dart';
import '../core/constants/theme.dart';
import '../core/utils/responsive_wrapper.dart';
import '../widgets/chat_bubble.dart';
import 'summary_screen.dart';

class ChatScreen extends StatefulWidget {
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
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic, // Animasi scroll premium
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
    _addMessage(
      const ChatMessage(
        id: 'sys1',
        sender: MessageSender.system,
        text: 'Menghubungkan dengan Dr. Budi Santoso...',
      ),
    );

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

    await Future.delayed(const Duration(milliseconds: 2000));
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

    await Future.delayed(const Duration(milliseconds: 1000));
    _addMessage(
      const ChatMessage(
        id: 't2',
        sender: MessageSender.doctor,
        text: '',
        isTyping: true,
      ),
    );

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
      backgroundColor: VetlyTheme.backgroundLight,
      // Custom Premium AppBar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 10),
        child: Container(
          decoration: BoxDecoration(
            color: VetlyTheme.surfaceWhite.withValues(alpha: 0.95),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: VetlyTheme.textDark,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage(
                        'lib/public/images/dokter.jpg',
                      ),
                      radius: 20,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green.shade500,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: VetlyTheme.surfaceWhite,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Dr. Budi Santoso',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: VetlyTheme.textDark,
                      ),
                    ),
                    Text(
                      'Dokter Hewan Online',
                      style: TextStyle(
                        fontSize: 12,
                        color: VetlyTheme.primaryTeal.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              // Tombol CTA 'Selesai' yang lebih mewah (Soft Chip)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
                child: Material(
                  color: VetlyTheme.primaryTeal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SummaryScreen(),
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: Text(
                          'Selesai',
                          style: TextStyle(
                            color: VetlyTheme.primaryTeal,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ResponsiveWrapper(
        child: Stack(
          children: [
            // Implementasi Background Portrait (repeating ubin)
            Positioned.fill(
              child: Image.asset(
                'lib/public/images/chat_bg_portrait.png', // Path gambar doodle hewan portrait
                repeat: ImageRepeat.repeat, // Perbaikan: Trik mengulang ubin
                fit: BoxFit
                    .none, // Perbaikan: Menjaga proporsi doodle portrait asli
                // Memberikan overlay efek kaca buram (Frosted Glass)
                color: VetlyTheme.backgroundLight.withValues(alpha: 0.9),
                colorBlendMode: BlendMode
                    .dstATop, // Blend Mode premium agar doodle portrait tembus pandang
              ),
            ),
            // List Chat (Berada di lapisan Stack di depan background)
            ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 100,
              ), // Padding bawah agar chat tidak tertutup dock
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (context, index) =>
                  ChatBubble(message: _messages[index]),
            ),
            // Floating Input Dock di lapisan atas
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildSimulatedInputBar(),
            ),
          ],
        ),
      ),
    );
  }

  // Komponen Input Chat dengan efek Kaca Buram (Frosted Glass)
  Widget _buildSimulatedInputBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            24,
          ), // Ekstra padding bawah untuk SafeArea
          decoration: BoxDecoration(
            color: VetlyTheme.surfaceWhite.withValues(alpha: 0.75),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.6),
                width: 1.5,
              ),
            ),
          ),
          child: Row(
            children: [
              // Tombol Attachment (+)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: VetlyTheme.textGrey.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: VetlyTheme.textGrey,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // Field Input Mockup (Pill shape)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: VetlyTheme.backgroundLight.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.8),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'Ketik pesan...',
                    style: TextStyle(
                      color: VetlyTheme.textGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Tombol Kirim (Solid Teal dengan Shadow)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: VetlyTheme.primaryTeal,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: VetlyTheme.primaryTeal.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: VetlyTheme.surfaceWhite,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
