import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/constants/theme.dart';
import '../core/utils/responsive_wrapper.dart';
import '../providers/triage_provider.dart';
import '../models/triage_result.dart';
import '../widgets/custom_button.dart';
import 'chat_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    // Memberikan getaran haptic saat hasil keluar (Memberi tahu user bahwa proses selesai)
    HapticFeedback.mediumImpact();

    // Setup Animasi Denyut (Pulse)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _getCategoryConfig(UrgencyCategory category) {
    switch (category) {
      case UrgencyCategory.mild:
        return {
          'color': Colors.green.shade600,
          'bgColor': Colors.green.shade50,
          'icon': Icons.health_and_safety_rounded,
          'title': 'Kondisi Ringan',
          'message':
              'Jangan panik. Kondisi ini bisa ditangani dengan perawatan dasar di rumah.',
          'points': [
            'Berikan waktu istirahat yang cukup di tempat hangat.',
            'Pastikan akses air minum bersih selalu tersedia.',
            'Pantau perkembangan gejala selama 24 jam ke depan.',
          ],
        };
      case UrgencyCategory.moderate:
        return {
          'color': Colors.orange.shade600,
          'bgColor': Colors.orange.shade50,
          'icon': Icons.warning_rounded,
          'title': 'Kondisi Sedang',
          'message':
              'Ada indikasi gangguan kesehatan menengah. Disarankan konsultasi dengan ahli.',
          'points': [
            'Gejala menunjukkan indikasi infeksi atau ketidaknyamanan.',
            'Segera konsultasikan dengan dokter hewan online vely.',
            'Tolong jangan berikan obat manusia tanpa resep dokter.',
          ],
        };
      case UrgencyCategory.urgent:
        return {
          'color': Colors.red.shade600,
          'bgColor': Colors.red.shade50,
          'icon': Icons.emergency_rounded,
          'title': 'Kondisi Mendesak!',
          'message':
              'Gejala kritis. Segera evakuasi hewan kesayangan Anda ke klinik terdekat.',
          'points': [
            'Kondisi ini berpotensi mengancam nyawa jika dibiarkan.',
            'Minimalkan pergerakan hewan saat proses evakuasi.',
            'Hubungi klinik terdekat sekarang untuk persiapan UGD.',
          ],
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final triageResult = context.read<TriageProvider>().currentResult;
    final petName = context.read<TriageProvider>().currentPet.name;

    if (triageResult == null) {
      return const Scaffold(
        body: Center(child: Text('Tidak ada data analisa.')),
      );
    }

    final config = _getCategoryConfig(triageResult.category);
    final Color mainColor = config['color'];
    final List<String> actionPoints = config['points'];

    return Scaffold(
      backgroundColor: velyTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Hasil Analisa AI',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close_rounded,
            size: 26,
            color: velyTheme.textDark,
          ),
          onPressed: () =>
              Navigator.popUntil(context, (route) => route.isFirst),
        ),
      ),
      body: ResponsiveWrapper(
        child: Stack(
          children: [
            // Konten Utama yang bisa di-scroll
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Premium Result Card dengan Animated Halo
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 40,
                    ),
                    decoration: BoxDecoration(
                      color: config['bgColor'],
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: mainColor.withValues(alpha: 0.15),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: mainColor.withValues(alpha: 0.1),
                          blurRadius: 32,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Animated Breathing Icon
                        ScaleTransition(
                          scale: _pulseAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: velyTheme.surfaceWhite,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: mainColor.withValues(alpha: 0.25),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Icon(
                              config['icon'],
                              size: 56,
                              color: mainColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          config['title'],
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: mainColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          config['message'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: velyTheme.textDark.withValues(alpha: 0.8),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 2. Lembar Instruksi Medis (Clean Sheet Card)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: velyTheme.surfaceWhite,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.assignment_outlined,
                              color: mainColor,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Rekomendasi untuk $petName:',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: velyTheme.textDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        ...actionPoints.map(
                          (point) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 3),
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: mainColor.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check_rounded,
                                    size: 14,
                                    color: mainColor,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    point,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: velyTheme.textGrey,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Spacer bawah untuk memberikan ruang bebas dari Sticky Button
                  const SizedBox(height: 160),
                ],
              ),
            ),

            // 3. Bottom Sticky Actions (Glassmorphism Dock)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                    decoration: BoxDecoration(
                      color: velyTheme.backgroundLight.withValues(alpha: 0.75),
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withValues(alpha: 0.6),
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomButton(
                          text: 'Konsultasi Dokter Sekarang',
                          icon: Icons.chat_rounded,
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChatScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomButton(
                          text: 'Cari Klinik Terdekat',
                          icon: Icons.location_on_rounded,
                          isOutlined: true,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Membuka integrasi peta...'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
