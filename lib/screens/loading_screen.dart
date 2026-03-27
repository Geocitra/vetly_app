import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/theme.dart';
import '../core/utils/responsive_wrapper.dart';
import '../providers/triage_provider.dart';
import 'result_screen.dart';

class LoadingScreen extends StatefulWidget {
  // Perbaikan Super Parameter
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  int _textIndex = 0;
  Timer? _timer;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    final petName = context.read<TriageProvider>().currentPet.name;

    // Teks dinamis untuk visual reasoning
    final List<String> reasoningTexts = [
      'Menganalisis gejala $petName...',
      'Memindai profil ras & usia...',
      'Mengevaluasi riwayat vaksinasi...',
      'Menghitung tingkat risiko...',
    ];

    // Animasi Pulse untuk efek menenangkan (Calm UI)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Mengganti teks setiap 800 milidetik
    _timer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (mounted) {
        setState(() {
          _textIndex = (_textIndex + 1) % reasoningTexts.length;
        });
      }
    });

    // Aturan 3 Detik: Pindah ke ResultScreen
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ResultScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petName = context.read<TriageProvider>().currentPet.name;
    final List<String> reasoningTexts = [
      'Menganalisis gejala $petName...',
      'Memindai profil ras & usia...',
      'Mengevaluasi riwayat vaksinasi...',
      'Menghitung tingkat risiko...',
    ];

    return Scaffold(
      body: ResponsiveWrapper(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    // Mengganti .withOpacity dengan .withValues sesuai standar baru
                    color: VetlyTheme.primaryTeal.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 48,
                    color: VetlyTheme.primaryTeal,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Text(
                  reasoningTexts[_textIndex],
                  key: ValueKey<int>(_textIndex),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: VetlyTheme.textDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
