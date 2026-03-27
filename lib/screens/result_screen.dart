import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/theme.dart';
import '../core/utils/responsive_wrapper.dart';
import '../providers/triage_provider.dart';
import '../models/triage_result.dart';
import '../widgets/custom_button.dart';
import 'chat_screen.dart';

class ResultScreen extends StatelessWidget {
  // 1. Perbaikan Super Parameter
  const ResultScreen({super.key});

  Map<String, dynamic> _getCategoryConfig(UrgencyCategory category) {
    switch (category) {
      case UrgencyCategory.mild:
        return {
          'color': Colors.green.shade600,
          'bgColor': Colors.green.shade50,
          'icon': Icons.check_circle_outline,
          'title': 'Kondisi Ringan',
          'message': 'Bisa ditangani dengan perawatan dasar di rumah.',
          'points': [
            'Berikan waktu istirahat yang cukup.',
            'Pastikan akses air minum bersih tersedia.',
            'Pantau perkembangan selama 24 jam ke depan.',
          ],
        };
      case UrgencyCategory.moderate:
        return {
          'color': Colors.orange.shade600,
          'bgColor': Colors.orange.shade50,
          'icon': Icons.warning_amber_rounded,
          'title': 'Kondisi Sedang',
          'message': 'Disarankan melakukan konsultasi digital.',
          'points': [
            'Gejala menunjukkan indikasi infeksi/gangguan menengah.',
            'Segera konsultasikan dengan dokter hewan online.',
            'Jangan berikan obat manusia tanpa resep dokter.',
          ],
        };
      case UrgencyCategory.urgent:
        return {
          'color': Colors.red.shade600,
          'bgColor': Colors.red.shade50,
          'icon': Icons.local_hospital_outlined,
          'title': 'Kondisi Mendesak!',
          'message': 'Segera bawa ke klinik hewan terdekat.',
          'points': [
            'Gejala sangat kritis dan mengancam nyawa.',
            'Minimalkan pergerakan hewan saat evakuasi.',
            'Hubungi klinik terdekat untuk persiapan UGD.',
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
      appBar: AppBar(
        title: const Text('Hasil Analisa'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () =>
              Navigator.popUntil(context, (route) => route.isFirst),
        ),
      ),
      body: ResponsiveWrapper(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: config['bgColor'],
                  borderRadius: BorderRadius.circular(16),
                  // 2. Perbaikan withValues untuk menghindari hilangnya presisi warna
                  border: Border.all(color: mainColor.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Icon(config['icon'], size: 64, color: mainColor),
                    const SizedBox(height: 16),
                    Text(
                      config['title'],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      config['message'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: VetlyTheme.textDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Rekomendasi untuk $petName:',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: VetlyTheme.textDark,
                ),
              ),
              const SizedBox(height: 12),

              // 3. Menghapus .toList() yang tidak perlu pada operasi Spread
              ...actionPoints.map(
                (point) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.play_arrow, size: 20, color: mainColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          point,
                          style: const TextStyle(
                            fontSize: 15,
                            color: VetlyTheme.textGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              CustomButton(
                text: 'Konsultasi Dokter Sekarang',
                icon: Icons.chat,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Cari Klinik Terdekat',
                icon: Icons.location_on,
                isOutlined: true,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Membuka integrasi peta...')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
