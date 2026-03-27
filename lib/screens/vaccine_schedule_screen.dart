import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/constants/theme.dart';
import '../core/utils/responsive_wrapper.dart';
import '../providers/triage_provider.dart';

class VaccineScheduleScreen extends StatefulWidget {
  const VaccineScheduleScreen({super.key});

  @override
  State<VaccineScheduleScreen> createState() => _VaccineScheduleScreenState();
}

class _VaccineScheduleScreenState extends State<VaccineScheduleScreen> {
  // Mock Data Jadwal Vaksin (Domain Model)
  final List<Map<String, dynamic>> _vaccineSchedules = [
    {
      'name': 'Vaksin Rabies (Tahunan)',
      'date': '12 Nov 2024',
      'status': 'upcoming',
      'clinic': 'Belum ditentukan',
      'notes': 'Wajib diulang setiap tahun',
    },
    {
      'name': 'Vaksin F3 / Tricat (Booster)',
      'date': '05 Okt 2024',
      'status': 'upcoming',
      'clinic': 'Klinik Hewan PawCare',
      'notes': 'Mencegah Panleukopenia, Rhinotracheitis, Calicivirus',
    },
    {
      'name': 'Vaksin F3 / Tricat (Dasar)',
      'date': '05 Okt 2023',
      'status': 'done',
      'clinic': 'Klinik Hewan PawCare',
      'notes': 'Diberikan saat usia 3 bulan',
    },
    {
      'name': 'Obat Cacing Rutin',
      'date': '15 Ags 2023',
      'status': 'done',
      'clinic': 'Mandiri di rumah',
      'notes': 'Drontal Cat - 1/2 tablet',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Information Expert: Mengambil konteks pet saat ini
    final pet = context.read<TriageProvider>().currentPet;

    // Memisahkan data berdasarkan status
    final upcomingVaccines = _vaccineSchedules
        .where((v) => v['status'] == 'upcoming')
        .toList();
    final pastVaccines = _vaccineSchedules
        .where((v) => v['status'] == 'done')
        .toList();

    return Scaffold(
      backgroundColor: velyTheme.backgroundLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
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
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: velyTheme.textDark,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Jadwal Vaksinasi',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: velyTheme.textDark,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: ResponsiveWrapper(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. HEADER STATUS PERLINDUNGAN
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: _buildProtectionStatusCard(pet),
              ),
            ),

            // 2. SECTION: AKAN DATANG
            if (upcomingVaccines.isNotEmpty) ...[
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(
                    'Segera Datang',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: velyTheme.textDark,
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildScheduleCard(
                    upcomingVaccines[index],
                    isDone: false,
                  ),
                  childCount: upcomingVaccines.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],

            // 3. SECTION: RIWAYAT SELESAI
            if (pastVaccines.isNotEmpty) ...[
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(
                    'Riwayat Selesai',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: velyTheme.textDark,
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      _buildScheduleCard(pastVaccines[index], isDone: true),
                  childCount: pastVaccines.length,
                ),
              ),
            ],

            const SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ), // Ruang untuk FAB
          ],
        ),
      ),
      // FAB untuk menambah jadwal baru
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.heavyImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fitur tambah jadwal akan segera hadir!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        backgroundColor: velyTheme.primaryTeal,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Tambah Jadwal',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Komponen Kartu Status Perlindungan
  Widget _buildProtectionStatusCard(dynamic pet) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: velyTheme.primaryTeal,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: velyTheme.primaryTeal.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        image: const DecorationImage(
          image: AssetImage(
            'lib/public/images/chat_bg_portrait.png',
          ), // Pola background samar
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status Perlindungan ${pet.name}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Cukup Optimal',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade400,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '1 Vaksin mendekati jadwal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Komponen Kartu Timeline Jadwal
  Widget _buildScheduleCard(Map<String, dynamic> data, {required bool isDone}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      decoration: BoxDecoration(
        color: velyTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDone ? Colors.grey.shade200 : Colors.orange.shade200,
          width: isDone ? 1 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDone
                ? Colors.black.withValues(alpha: 0.02)
                : Colors.orange.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            HapticFeedback.lightImpact();
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Indikator Ikon Kiri
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDone
                            ? velyTheme.primaryTeal.withValues(alpha: 0.1)
                            : Colors.orange.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isDone
                            ? Icons.check_circle_rounded
                            : Icons.vaccines_rounded,
                        color: isDone
                            ? velyTheme.primaryTeal
                            : Colors.orange.shade700,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Detail Informasi Vaksin
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['name'],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isDone
                              ? velyTheme.textDark
                              : Colors.orange.shade900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            size: 14,
                            color: velyTheme.textGrey.withValues(alpha: 0.8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            data['date'],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: velyTheme.textGrey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(height: 1),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.local_hospital_rounded,
                            size: 12,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              data['clinic'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
