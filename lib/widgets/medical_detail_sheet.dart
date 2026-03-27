import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/constants/theme.dart';
import '../models/medical_entry.dart';

class MedicalDetailSheet extends StatelessWidget {
  final MedicalEntry entry;

  const MedicalDetailSheet({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: DraggableScrollableSheet(
        initialChildSize: 0.75, // Membuka 3/4 layar untuk fokus instan
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) {
          return Container(
            decoration: const BoxDecoration(
              color: VetlyTheme.surfaceWhite,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                // Handle Bar (Convenience UI)
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Header Profil Medis
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: entry.color.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(entry.icon, color: entry.color, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: VetlyTheme.textDark,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Laporan Terverifikasi • ${entry.date}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: VetlyTheme.textGrey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                const Divider(height: 1),
                const SizedBox(height: 24),

                // Data Sekunder
                _buildInfoSection('Dokter Hewan / Lab', entry.subtitle),
                _buildInfoSection('ID Referensi Medis', 'VET-2023-098812'),

                const SizedBox(height: 12),

                // Catatan Dokter (Immersive Content)
                const Text(
                  'Catatan Hasil Pemeriksaan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: VetlyTheme.textGrey,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: VetlyTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: const Text(
                    'Pemeriksaan menunjukkan kondisi fisik yang stabil. Detak jantung dan pernapasan dalam batas normal. Hasil observasi menyarankan pemberian hidrasi tambahan. Tidak ditemukan indikasi trauma fisik pada area yang dikeluhkan.',
                    style: TextStyle(
                      fontSize: 15,
                      color: VetlyTheme.textDark,
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // File Lampiran
                const Text(
                  'Dokumen Pendukung',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: VetlyTheme.textGrey,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFileCard(
                        Icons.picture_as_pdf_rounded,
                        'Hasil_Lab_Lengkap.pdf',
                      ),
                      const SizedBox(width: 12),
                      _buildFileCard(Icons.image_rounded, 'Foto_Kondisi.png'),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // CTA Utama (Digital Medical Receipt)
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: VetlyTheme.primaryTeal.withValues(alpha: 0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: VetlyTheme.primaryTeal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.cloud_download_rounded),
                    label: const Text(
                      'Unduh Rekap Medis',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: VetlyTheme.textGrey,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: VetlyTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileCard(IconData icon, String fileName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: VetlyTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: VetlyTheme.primaryTeal),
          const SizedBox(width: 10),
          Text(
            fileName,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: VetlyTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
