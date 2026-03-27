import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/constants/theme.dart';
import '../core/utils/responsive_wrapper.dart';
import '../providers/triage_provider.dart';
import '../widgets/custom_button.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  // Mock data instruksi perawatan mandiri
  final List<String> _careInstructions = [
    'Sediakan air minum bersih di dekat tempat tidurnya.',
    'Beri waktu istirahat penuh di area yang hangat.',
    'Pantau intensitas gejala selama 12-24 jam ke depan.',
  ];

  late List<bool> _checkedItems;

  @override
  void initState() {
    super.initState();
    _checkedItems = List.generate(_careInstructions.length, (index) => false);
  }

  void _toggleCheck(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _checkedItems[index] = !_checkedItems[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final pet = context.read<TriageProvider>().currentPet;

    return Scaffold(
      backgroundColor: velyTheme.backgroundLight,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hilangkan tombol back (alur maju)
        backgroundColor: velyTheme.backgroundLight,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Rangkuman Sesi & Solusi',
          style: TextStyle(
            color: velyTheme.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: ResponsiveWrapper(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. KARTU KESIMPULAN DIAGNOSA
              _buildDiagnosisSummary(pet.name),

              const SizedBox(height: 28),

              // 2. CHECKLIST TINDAKAN MANDIRI
              const Text(
                'Tindakan Observasi di Rumah',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: velyTheme.textDark,
                ),
              ),
              const SizedBox(height: 12),
              ...List.generate(
                _careInstructions.length,
                (index) => _buildChecklistItem(index),
              ),

              const SizedBox(height: 32),

              // 3. RUJUKAN KLINIK TERDEKAT (The Wow Factor)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rujukan Klinik Terdekat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: velyTheme.textDark,
                    ),
                  ),
                  Text(
                    'Lihat Peta',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: velyTheme.primaryTeal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildClinicReferralSection(),

              const SizedBox(height: 48),

              // 4. FINAL CTA
              CustomButton(
                text: 'Selesai & Kembali ke Beranda',
                icon: Icons.home_rounded,
                onPressed: () {
                  // Kembali ke root beranda
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // Widget 1: Kartu Kesimpulan Diagnosa
  Widget _buildDiagnosisSummary(String petName) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: velyTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: velyTheme.primaryTeal.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: velyTheme.primaryTeal.withValues(alpha: 0.05),
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: Colors.orange.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Indikasi Kondisi Sedang',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: velyTheme.textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Berdasarkan analisa AI dan konsultasi dokter, $petName mengalami gejala yang membutuhkan observasi lebih lanjut. Jika kondisi memburuk dalam 12 jam, segera kunjungi klinik terdekat di bawah ini.',
            style: const TextStyle(
              fontSize: 14,
              color: velyTheme.textGrey,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Widget 2: Item Checklist Interaktif
  Widget _buildChecklistItem(int index) {
    final isChecked = _checkedItems[index];
    return GestureDetector(
      onTap: () => _toggleCheck(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isChecked ? velyTheme.backgroundLight : velyTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isChecked ? Colors.transparent : Colors.grey.shade200,
          ),
          boxShadow: isChecked
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(
                isChecked ? Icons.check_circle_rounded : Icons.circle_outlined,
                key: ValueKey<bool>(isChecked),
                color: isChecked ? velyTheme.primaryTeal : Colors.grey.shade400,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: isChecked ? FontWeight.w500 : FontWeight.w600,
                  color: isChecked
                      ? velyTheme.textGrey.withValues(alpha: 0.6)
                      : velyTheme.textDark,
                  decoration: isChecked
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  fontFamily: 'Poppins',
                ),
                child: Text(_careInstructions[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget 3: Seksi Peta & Rujukan Klinik
  Widget _buildClinicReferralSection() {
    return Container(
      decoration: BoxDecoration(
        color: velyTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Mockup Peta Mini
          Container(
            height: 120,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F0F2), // Warna dasar ala peta
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              image: DecorationImage(
                image: AssetImage(
                  'lib/public/images/chat_bg_portrait.png',
                ), // Menggunakan pola doodle sebagai background peta sementara
                fit: BoxFit.cover,
                opacity: 0.2,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Mockup Pin Lokasi
                Icon(
                  Icons.location_on_rounded,
                  size: 48,
                  color: Colors.red.shade600,
                ),
                Positioned(
                  bottom: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: velyTheme.textDark.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Posisi Anda',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Daftar Klinik
          _buildClinicCard(
            name: 'Klinik Hewan PawCare',
            distance: '1.2 km',
            status: 'Buka 24 Jam • UGD Tersedia',
            statusColor: Colors.green.shade600,
            isFirst: true,
          ),
          const Divider(height: 1, indent: 20, endIndent: 20),
          _buildClinicCard(
            name: 'Sehat Satwa Vet Clinic',
            distance: '3.5 km',
            status: 'Tutup Pukul 20.00',
            statusColor: Colors.orange.shade700,
            isFirst: false,
          ),
        ],
      ),
    );
  }

  Widget _buildClinicCard({
    required String name,
    required String distance,
    required String status,
    required Color statusColor,
    required bool isFirst,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.vertical(
          bottom: isFirst ? Radius.zero : const Radius.circular(24),
        ),
        onTap: () {
          HapticFeedback.selectionClick();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Membuka Google Maps...'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: velyTheme.primaryTeal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_hospital_rounded,
                  color: velyTheme.primaryTeal,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: velyTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    distance,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: velyTheme.textGrey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: velyTheme.backgroundLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.directions_car_rounded,
                      size: 16,
                      color: velyTheme.primaryTeal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
