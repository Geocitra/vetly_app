import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart'; // Import package Lottie
import '../core/constants/theme.dart';
import '../core/utils/responsive_wrapper.dart';
import '../providers/triage_provider.dart';
import 'result_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  int _textIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final petName = context.read<TriageProvider>().currentPet.name;

    final List<String> reasoningTexts = [
      'Menganalisis gejala $petName...',
      'Memindai profil ras & usia...',
      'Mengevaluasi riwayat vaksinasi...',
      'Menghitung tingkat risiko...',
    ];

    // Mengganti teks setiap 800 milidetik
    _timer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (mounted) {
        setState(() {
          _textIndex = (_textIndex + 1) % reasoningTexts.length;
        });
      }
    });

    // Pindah ke ResultScreen setelah 3.5 detik (memberi waktu animasi Lottie terlihat penuh)
    Future.delayed(const Duration(milliseconds: 3500), () {
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
      backgroundColor: VetlyTheme.backgroundLight,
      body: ResponsiveWrapper(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Menggunakan Lottie Animation dari Network
              Lottie.network(
                'https://assets9.lottiefiles.com/packages/lf20_t2v9p7p3.json', // URL contoh: radar/loading medis yang smooth
                width: 150,
                height: 150,
                fit: BoxFit.contain,
                // Mengubah warna animasi agar sesuai dengan Tema Teal Vetly
                delegates: LottieDelegates(
                  values: [
                    ValueDelegate.color(
                      const [
                        '**',
                      ], // Menerapkan warna pada seluruh layer animasi
                      value: VetlyTheme.primaryTeal,
                    ),
                  ],
                ),
                // Fallback jika tidak ada koneksi internet saat demo
                errorBuilder: (context, error, stackTrace) {
                  return const CircularProgressIndicator(
                    color: VetlyTheme.primaryTeal,
                    strokeWidth: 3,
                  );
                },
              ),

              const SizedBox(height: 32),

              // Teks yang berganti-ganti (Visual Reasoning)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  // Kombinasi Fade dan Slide pelan untuk kesan mewah
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.2),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  reasoningTexts[_textIndex],
                  key: ValueKey<int>(_textIndex),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: VetlyTheme
                        .primaryTeal, // Warna teks diselaraskan dengan animasi
                    letterSpacing: 0.3,
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
