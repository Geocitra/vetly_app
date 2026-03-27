import 'package:flutter/material.dart';
import '../core/constants/theme.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Konfigurasi kurva animasi masuk (Fade In)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    // Memulai animasi logo
    _animationController.forward();

    // Menjalankan proses inisialisasi di latar belakang
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simulasi waktu yang dibutuhkan sistem untuk memuat data / API
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Navigasi ke HomeScreen menggunakan transisi Pudar (Fade) yang mewah
    // PushReplacement memastikan user tidak bisa menekan tombol 'Back' ke Splash Screen
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(
          milliseconds: 800,
        ), // Durasi transisi pindah layar
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan warna solid Teal untuk menegaskan identitas brand vely
      backgroundColor: velyTheme.primaryTeal,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Premium vely
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: velyTheme.surfaceWhite,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 40,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.pets_rounded,
                  size: 72,
                  color: velyTheme.primaryTeal,
                ),
              ),
              const SizedBox(height: 32),

              // Tipografi Brand
              const Text(
                'vetly',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: velyTheme.surfaceWhite,
                  letterSpacing: 6,
                ),
              ),
              const SizedBox(height: 12),

              // Slogan
              Text(
                'WE CARE. WE LOVE.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: velyTheme.surfaceWhite.withValues(alpha: 0.8),
                  letterSpacing: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
