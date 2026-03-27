import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/constants/theme.dart';
import '../core/utils/responsive_wrapper.dart';
import '../providers/triage_provider.dart';

// Import ketiga layar yang sudah kita buat
import 'medical_record_screen.dart';
import 'vaccine_schedule_screen.dart';
import 'consultation_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pet = context.watch<TriageProvider>().currentPet;

    return Scaffold(
      backgroundColor: velyTheme.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Profil Peliharaan',
          style: TextStyle(
            color: velyTheme.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Jika ini tab utama
      ),
      body: ResponsiveWrapper(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // 1. IDENTITY SECTION
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: velyTheme.primaryTeal,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: AssetImage(pet.imageUrl),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: velyTheme.primaryTeal,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      pet.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: velyTheme.textDark,
                      ),
                    ),
                    Text(
                      '${pet.breed} • 4 Bulan',
                      style: const TextStyle(
                        fontSize: 14,
                        color: velyTheme.textGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // 2. PET SWITCHER (Quick Access to other pets)
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Peliharaan Saya',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: velyTheme.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildPetMiniAvatar(pet.imageUrl, true),
                  _buildAddPetButton(),
                ],
              ),

              const SizedBox(height: 32),

              // 3. MENU GROUPS (Sudah Terhubung Sepenuhnya)
              _buildMenuSection('Aktivitas Medis', [
                _buildMenuItem(
                  Icons.description_outlined,
                  'Rekam Medis Digital',
                  Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MedicalRecordScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  Icons.event_note_rounded,
                  'Jadwal Vaksinasi',
                  Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VaccineScheduleScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  Icons.history_rounded,
                  'Riwayat Konsultasi',
                  Colors.purple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConsultationHistoryScreen(),
                      ),
                    );
                  },
                ),
              ]),

              const SizedBox(height: 24),

              _buildMenuSection('Informasi Hewan', [
                _buildMenuItem(
                  Icons.monitor_weight_outlined,
                  'Lacak Berat Badan',
                  Colors.teal,
                ),
                _buildMenuItem(
                  Icons.restaurant_rounded,
                  'Nutrisi & Diet',
                  Colors.green,
                ),
              ]),

              const SizedBox(height: 24),

              _buildMenuSection('Lainnya', [
                _buildMenuItem(
                  Icons.payments_outlined,
                  'Metode Pembayaran',
                  Colors.indigo,
                ),
                _buildMenuItem(
                  Icons.help_outline_rounded,
                  'Pusat Bantuan',
                  Colors.blueGrey,
                ),
              ]),

              const SizedBox(height: 32),

              // Logout Button
              _buildLogoutButton(context),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetMiniAvatar(String url, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? velyTheme.primaryTeal : Colors.transparent,
          width: 2,
        ),
      ),
      child: CircleAvatar(radius: 24, backgroundImage: AssetImage(url)),
    );
  }

  Widget _buildAddPetButton() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.add_rounded, color: velyTheme.textGrey),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: velyTheme.textGrey,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  // Fungsi Helper dengan parameter onTap opsional
  Widget _buildMenuItem(
    IconData icon,
    String label,
    Color color, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: velyTheme.textDark,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: velyTheme.textGrey,
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        if (onTap != null) {
          onTap();
        } else {
          // Placeholder jika fungsi onTap belum diimplementasi (misal untuk menu Lainnya)
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('$label akan segera hadir!'), behavior: SnackBarBehavior.floating),
          // );
        }
      },
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'Keluar Akun',
            style: TextStyle(
              color: Colors.red.shade700,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
