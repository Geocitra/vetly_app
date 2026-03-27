import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // State baru untuk memunculkan Interactive End Session Card
  bool _isSessionEnding = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startDynamicSimulationSequence();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(
            milliseconds: 500,
          ), // Diperlambat sedikit agar transisi mulus
          curve: Curves.easeOutCubic,
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

  Future<void> _startDynamicSimulationSequence() async {
    final provider = context.read<TriageProvider>();
    final petName = provider.currentPet.name;

    final symptomNames = provider.selectedSymptoms
        .map((s) => s.name.toLowerCase())
        .toList();
    final symptomsText = symptomNames.isNotEmpty
        ? symptomNames.join(', ')
        : 'gejala tersebut';

    // 1. System Connect
    _addMessage(
      const ChatMessage(
        id: 'sys1',
        sender: MessageSender.system,
        text: 'Menghubungkan dengan Dr. Budi Santoso...',
      ),
    );

    await Future.delayed(const Duration(milliseconds: 1500));
    _removeTypingIndicator();

    // 2. Dokter Menyapa
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

    _addMessage(
      ChatMessage(
        id: 'msg1',
        sender: MessageSender.doctor,
        text:
            'Halo Kak Budi, saya Dr. Budi. Saya sudah membaca laporan dari vely AI. Saya lihat $petName sedang mengalami $symptomsText ya. Sejak kapan kondisi ini terlihat?',
      ),
    );

    // 3. User Membalas otomatis (Simulasi)
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;

    _addMessage(
      ChatMessage(
        id: 'msg_user1',
        sender: MessageSender.user,
        text:
            'Iya dok bener banget. Tadi $petName tiba-tiba $symptomsText dan kelihatan agak lemas. Saya panik banget dok, kira-kira kenapa ya?',
      ),
    );

    // 4. Dokter Memberikan Solusi Awal
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;

    _addMessage(
      const ChatMessage(
        id: 't2',
        sender: MessageSender.doctor,
        text: '',
        isTyping: true,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 3000));
    if (!mounted) return;
    _removeTypingIndicator();

    _addMessage(
      const ChatMessage(
        id: 'msg2',
        sender: MessageSender.doctor,
        text:
            'Saya sangat mengerti kekhawatiran Kakak, tolong jangan panik ya. Sebagai langkah observasi awal, tolong berikan air minum sedikit-sedikit saja dan siapkan area yang hangat untuknya beristirahat. Kita akan pantau perkembangannya.',
      ),
    );

    // 5. Trigger Interactive System Card untuk mengakhiri sesi
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;

    setState(() {
      _isSessionEnding = true;
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: velyTheme.backgroundLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 10),
        child: Container(
          decoration: BoxDecoration(
            color: velyTheme.surfaceWhite.withValues(alpha: 0.95),
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
            titleSpacing: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: velyTheme.textDark,
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
                      radius: 18,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.green.shade500,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: velyTheme.surfaceWhite,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Dr. Budi Santoso',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: velyTheme.textDark,
                        ),
                      ),
                      Text(
                        'Dokter Hewan Online',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: velyTheme.primaryTeal.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // TOMBOL SELESAI DIHAPUS DARI SINI
            actions: const [
              // Ruang kosong untuk menjaga proporsi
              SizedBox(width: 16),
            ],
          ),
        ),
      ),
      body: ResponsiveWrapper(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'lib/public/images/chat_bg_portrait.png',
                repeat: ImageRepeat.repeat,
                fit: BoxFit.none,
                color: velyTheme.backgroundLight.withValues(alpha: 0.9),
                colorBlendMode: BlendMode.dstATop,
              ),
            ),

            // List Chat dengan tambahan item terakhir jika _isSessionEnding = true
            ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 16, bottom: 120),
              physics: const BouncingScrollPhysics(),
              // Menambah 1 item pada List jika kartu end session muncul
              itemCount: _messages.length + (_isSessionEnding ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _messages.length) {
                  return ChatBubble(message: _messages[index]);
                } else {
                  return _buildEndSessionCard();
                }
              },
            ),

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

  // KOMPONEN BARU: Interactive Resolution Card (Muncul di dalam aliran chat)
  Widget _buildEndSessionCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: velyTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: velyTheme.primaryTeal.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: velyTheme.primaryTeal.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: velyTheme.primaryTeal.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user_rounded,
              color: velyTheme.primaryTeal,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Sesi Diagnosa Selesai',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: velyTheme.textDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Apakah panduan dan langkah observasi dari Dokter sudah cukup jelas?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: velyTheme.textGrey,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          // Tombol Akhiri (Primary)
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: velyTheme.primaryTeal,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SummaryScreen(),
                  ),
                );
              },
              child: const Text(
                'Ya, Akhiri & Lihat Rangkuman',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Tombol Tanya Lagi (Secondary)
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: velyTheme.textDark,
                side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                HapticFeedback.selectionClick();
                setState(() {
                  _isSessionEnding = false;
                  _addMessage(
                    const ChatMessage(
                      id: 'sys2',
                      sender: MessageSender.system,
                      text:
                          'Sesi diperpanjang. Silakan ketik pertanyaan lanjutan Anda.',
                    ),
                  );
                });
              },
              child: const Text(
                'Belum, Saya Mau Tanya Lagi',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulatedInputBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          decoration: BoxDecoration(
            color: velyTheme.surfaceWhite.withValues(alpha: 0.75),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.6),
                width: 1.5,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: velyTheme.textGrey.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: velyTheme.textGrey,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: velyTheme.backgroundLight.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.8),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'Ketik pesan...',
                    style: TextStyle(
                      color: velyTheme.textGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: velyTheme.primaryTeal,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: velyTheme.primaryTeal.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: velyTheme.surfaceWhite,
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
