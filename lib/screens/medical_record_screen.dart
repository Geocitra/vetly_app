import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/constants/theme.dart';
import '../core/utils/responsive_wrapper.dart';
import '../providers/triage_provider.dart';
import '../widgets/medical_detail_sheet.dart';
import '../models/medical_entry.dart';

class MedicalRecordScreen extends StatelessWidget {
  const MedicalRecordScreen({super.key});

  void _showMedicalDetail(BuildContext context, MedicalEntry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) => MedicalDetailSheet(entry: entry),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pet = context.read<TriageProvider>().currentPet;

    final List<MedicalEntry> mockEntries = [
      MedicalEntry(
        icon: Icons.assignment_turned_in_rounded,
        color: Colors.blue,
        title: 'Check-up & Konsultasi',
        subtitle: 'Dr. Budi Santoso • Klinik PawCare',
        date: '20 Nov 2023',
      ),
      MedicalEntry(
        icon: Icons.auto_awesome_rounded,
        color: velyTheme.primaryTeal,
        title: 'Analisa VETLY AI (Muntah)',
        subtitle: 'Saran: Kondisi Sedang • Konsultasi Dokter',
        date: '15 Nov 2023',
      ),
      MedicalEntry(
        icon: Icons.local_hospital_rounded,
        color: Colors.orange,
        title: 'Vaksinasi Rabies & Parvo',
        subtitle: 'Dr. Budi Santoso • Klinik PawCare',
        date: '01 Nov 2023',
      ),
      MedicalEntry(
        icon: Icons.biotech_rounded,
        color: Colors.purple,
        title: 'Hasil Tes Darah Lengkap',
        subtitle: 'Lab Sehat Satwa • Nilai Normal',
        date: '10 Okt 2023',
      ),
    ];

    return Scaffold(
      backgroundColor: velyTheme.backgroundLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Rekam Medis Digital',
          style: TextStyle(
            color: velyTheme.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: ResponsiveWrapper(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: _buildPetHeader(pet),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildSearchBar(),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    left: 36,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 2,
                      color: velyTheme.primaryTeal.withValues(alpha: 0.15),
                    ),
                  ),
                  ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                    itemCount: mockEntries.length,
                    itemBuilder: (context, index) {
                      return _buildTimelineItem(context, mockEntries[index]);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetHeader(dynamic pet) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: velyTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 28, backgroundImage: AssetImage(pet.imageUrl)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pemilik data kesehatan:',
                  style: TextStyle(
                    fontSize: 12,
                    color: velyTheme.textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${pet.name} (${pet.breed})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: velyTheme.textDark,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.qr_code_scanner_rounded,
              color: velyTheme.primaryTeal,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  // PERBAIKAN: Search bar dibuat lebih responsif
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: velyTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: velyTheme.textGrey.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 12),
          // PERBAIKAN: Gunakan Expanded & TextOverflow
          Expanded(
            child: Text(
              'Cari rekam medis (mis. Vaksin Parvo)...',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: velyTheme.textGrey.withValues(alpha: 0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, MedicalEntry entry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            margin: const EdgeInsets.only(top: 12, right: 20),
            decoration: BoxDecoration(
              color: entry.color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: entry.color.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(entry.icon, size: 14, color: Colors.white),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: velyTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    _showMedicalDetail(context, entry);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: velyTheme.textDark,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              entry.subtitle,
                              style: const TextStyle(
                                fontSize: 13,
                                color: velyTheme.textGrey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: velyTheme.backgroundLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                entry.date,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: velyTheme.textGrey.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: velyTheme.textGrey.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
