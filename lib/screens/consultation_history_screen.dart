import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/theme.dart';
import '../core/utils/responsive_wrapper.dart';
import 'summary_screen.dart'; // Menambahkan import untuk layar Rangkuman

class ConsultationHistoryScreen extends StatelessWidget {
  const ConsultationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data Riwayat Konsultasi (Pure Fabrication)
    final List<Map<String, dynamic>> historyData = [
      {
        'id': 'VET-8821A',
        'doctor': 'Dr. Budi Santoso',
        'type': 'Telemedisin (Chat)',
        'date': '24 Okt 2023 • 14:30',
        'petName': 'Rocky',
        'complaint': 'Muntah kuning dan lemas sejak pagi',
        'status': 'Selesai',
        'isAI': false,
      },
      {
        'id': 'AI-9910B',
        'doctor': 'vely AI System',
        'type': 'Triase Cerdas',
        'date': '24 Okt 2023 • 14:15',
        'petName': 'Rocky',
        'complaint': 'Analisa awal gejala muntah',
        'status': 'Selesai',
        'isAI': true,
      },
      {
        'id': 'VET-7732C',
        'doctor': 'Drh. Amanda',
        'type': 'Telemedisin (Video)',
        'date': '12 Sep 2023 • 10:00',
        'petName': 'Luna',
        'complaint': 'Pengecekan luka pasca steril',
        'status': 'Selesai',
        'isAI': false,
      },
    ];

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
              'Riwayat Konsultasi',
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
        child: historyData.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                itemCount: historyData.length,
                itemBuilder: (context, index) {
                  return _buildHistoryCard(context, historyData[index]);
                },
              ),
      ),
    );
  }

  // Komponen Kartu Riwayat
  Widget _buildHistoryCard(BuildContext context, Map<String, dynamic> data) {
    final bool isAI = data['isAI'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: velyTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SummaryScreen()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Tanggal & Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data['date'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: velyTheme.textGrey,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        data['status'],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // Body: Info Dokter & Keluhan
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar Dinamis
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isAI
                            ? velyTheme.primaryTeal.withValues(alpha: 0.1)
                            : Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isAI
                            ? Icons.auto_awesome_rounded
                            : Icons.person_rounded,
                        color: isAI
                            ? velyTheme.primaryTeal
                            : Colors.blue.shade700,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['doctor'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: velyTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            data['type'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: velyTheme.textGrey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Highlight Keluhan
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: velyTheme.backgroundLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.pets_rounded,
                                  size: 14,
                                  color: velyTheme.textGrey,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pasien: ${data['petName']}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: velyTheme.textDark,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '"${data['complaint']}"',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: velyTheme.textGrey,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Footer Action
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'ID: ${data['id']}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Lihat Rangkuman',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: velyTheme.primaryTeal,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: velyTheme.primaryTeal,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Komponen Empty State jika belum ada riwayat
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: velyTheme.primaryTeal.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.history_rounded,
              size: 64,
              color: velyTheme.primaryTeal,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Belum Ada Riwayat',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: velyTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Riwayat konsultasi telemedisin dan analisa AI akan muncul di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: velyTheme.textGrey,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
