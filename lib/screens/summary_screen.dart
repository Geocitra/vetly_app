import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/theme.dart';
import '../core/utils/responsive_wrapper.dart';
import '../providers/triage_provider.dart';
import '../models/triage_result.dart';
import '../widgets/custom_button.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  // Mock data untuk checklist berdasarkan kategori
  List<Map<String, dynamic>> _checklist = [];

  @override
  void initState() {
    super.initState();
    _initializeChecklist();
  }

  void _initializeChecklist() {
    // Mengambil hasil dari Provider pada saat inisialisasi
    final result = context.read<TriageProvider>().currentResult;

    List<String> rawPoints = [
      'Berikan air minum sedikit-sedikit.',
      'Pantau suhu tubuh setiap 4 jam.',
      'Batasi pergerakan fisik.',
    ];

    if (result != null && result.category == UrgencyCategory.urgent) {
      rawPoints = [
        'Hubungi klinik untuk persiapan kedatangan.',
        'Bawa rekam medis fisik jika ada.',
        'Siapkan carrier/pet cargo yang aman.',
      ];
    }

    _checklist = rawPoints
        .map((point) => {'task': point, 'isDone': false})
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final petName = context.read<TriageProvider>().currentPet.name;
    final result = context.read<TriageProvider>().currentResult;

    final diagTitle = result?.category == UrgencyCategory.urgent
        ? 'Indikasi Kritis (Rujukan)'
        : 'Indikasi Gejala Menengah/Ringan';

    return Scaffold(
      backgroundColor: VetlyTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Rencana Perawatan'),
        automaticallyImplyLeading: false, // Menghilangkan tombol back native
      ),
      body: ResponsiveWrapper(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Laporan Konsultasi $petName 📋',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: VetlyTheme.textDark,
                ),
              ),
              const SizedBox(height: 16),

              // Kartu Diagnosa
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: VetlyTheme.surfaceWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dokter Penanggung Jawab:',
                      style: TextStyle(
                        color: VetlyTheme.textGrey,
                        fontSize: 12,
                      ),
                    ),
                    const Text(
                      'Dr. Budi Santoso',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Divider(height: 24),
                    const Text(
                      'Ringkasan Awal:',
                      style: TextStyle(
                        color: VetlyTheme.textGrey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      diagTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: VetlyTheme.primaryTeal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Area Checklist
              const Text(
                'Checklist Mandiri:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: VetlyTheme.textDark,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: _checklist.length,
                  itemBuilder: (context, index) {
                    final item = _checklist[index];
                    return CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      activeColor: VetlyTheme.primaryTeal,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        item['task'],
                        style: TextStyle(
                          decoration: item['isDone']
                              ? TextDecoration.lineThrough
                              : null,
                          color: item['isDone']
                              ? VetlyTheme.textGrey
                              : VetlyTheme.textDark,
                        ),
                      ),
                      value: item['isDone'],
                      onChanged: (bool? value) {
                        setState(() {
                          _checklist[index]['isDone'] = value ?? false;
                        });
                      },
                    );
                  },
                ),
              ),

              // CTA Akhir
              CustomButton(
                text: 'Simpan ke Rekam Medis',
                icon: Icons.save_alt,
                onPressed: () {
                  // Reset state provider jika diperlukan sebelum kembali ke beranda
                  // context.read<TriageProvider>().reset();
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
