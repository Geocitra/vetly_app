import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/constants/theme.dart';
import '../core/utils/responsive_wrapper.dart';
import '../providers/triage_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/vitals_card.dart';
import '../widgets/ecosystem_card.dart';
import 'triage_screen.dart';
import 'profile_screen.dart';
import 'medical_record_screen.dart'; // 1. Import layar Rekam Medis baru
import 'article_screen.dart'; // Tambahkan ini di deretan import
import 'clinic_map_screen.dart';
import 'vaccine_schedule_screen.dart'; // Ganti import ini

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _lastPressedAt;

  // Mengelola index navigasi untuk BottomNavigationBar
  int _currentIndex = 0;

  // Fungsi untuk menangani penekanan tombol back sistem (Android)
  void _handlePopInvocation(bool didPop, Object? result) {
    if (didPop) return;
    final now = DateTime.now();
    final isWarningNeeded =
        _lastPressedAt == null ||
        now.difference(_lastPressedAt!) > const Duration(seconds: 2);

    if (isWarningNeeded) {
      _lastPressedAt = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Tekan sekali lagi untuk keluar dari vely'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pet = context.watch<TriageProvider>().currentPet;

    // 2. Daftar halaman yang diperbarui: Placeholder Riwayat diganti MedicalRecordScreen
    final List<Widget> pages = [
      _buildHomeContent(pet), // Tab 0: Beranda
      const MedicalRecordScreen(), // Tab 1: Rekam Medis (Dulu Riwayat)
      const ProfileScreen(), // Tab 2: Profil
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _handlePopInvocation,
      child: Scaffold(
        backgroundColor: velyTheme.backgroundLight,
        body: ResponsiveWrapper(
          // IndexedStack menjaga state halaman agar tidak ter-reset saat ganti tab
          child: IndexedStack(index: _currentIndex, children: pages),
        ),

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: velyTheme.surfaceWhite,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            selectedItemColor: velyTheme.primaryTeal,
            unselectedItemColor: velyTheme.textGrey.withValues(alpha: 0.6),
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            currentIndex: _currentIndex,
            onTap: (index) {
              HapticFeedback.selectionClick();
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Beranda',
              ),
              // 3. Update Label: 'Riwayat' menjadi 'Rekam Medis'
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment_rounded), // Ikon yang lebih 'medis'
                label: 'Rekam Medis',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Komponen konten utama Beranda (Sliver & Parallax)
  Widget _buildHomeContent(dynamic pet) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. Hero Image dengan Parallax effect
            SliverAppBar(
              expandedHeight: screenHeight * 0.42,
              pinned: true,
              stretch: true,
              backgroundColor: velyTheme.backgroundLight,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground],
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(pet.imageUrl, fit: BoxFit.cover),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.4),
                              Colors.transparent,
                              velyTheme.backgroundLight.withValues(alpha: 0.8),
                              velyTheme.backgroundLight,
                            ],
                            stops: const [0.0, 0.3, 0.85, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Konten Informasi & Grid Layanan
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      'Halo, Kak Budi & ${pet.name}! 👋',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: velyTheme.textDark,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Kami siap menjaga kesehatannya hari ini.',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: velyTheme.textGrey,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Komponen Vitals modular
                    VitalsCard(pet: pet),

                    const SizedBox(height: 32),
                    const Text(
                      'Layanan Ekosistem vetly',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: velyTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Grid Layanan Ekosistem
                    _buildQuickActionsGrid(),

                    const SizedBox(
                      height: 140,
                    ), // Ruang agar konten tidak tertutup sticky button
                  ],
                ),
              ),
            ),
          ],
        ),

        // 3. Sticky Panic Button
        Positioned(bottom: 0, left: 0, right: 0, child: _buildStickyButton()),
      ],
    );
  }

  Widget _buildQuickActionsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        EcosystemCard(
          icon: Icons.medical_information_rounded,
          title: 'Rekam Medis',
          subtitle: 'LIHAT',
          primaryColor: Colors.blue.shade600,
          onTap: () {
            // Berpindah ke tab Rekam Medis (Index 1)
            setState(() {
              _currentIndex = 1;
            });
          },
        ),
        EcosystemCard(
          icon: Icons.local_hospital_rounded,
          title: 'Cari Klinik',
          subtitle: 'MAPS',
          primaryColor: Colors.red.shade500,
          onTap: () {
            // PERUBAHAN: Buka halaman ClinicMapScreen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ClinicMapScreen()),
            );
          },
        ),
        EcosystemCard(
          icon: Icons.vaccines,
          title: 'Jadwal Vaksinasi',
          subtitle: 'Health Care',
          primaryColor: Colors.orange.shade500,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VaccineScheduleScreen(),
              ),
            );
          },
        ),
        EcosystemCard(
          icon: Icons.auto_stories_rounded,
          title: 'Artikel Sehat',
          subtitle: 'EDUKASI',
          primaryColor: Colors.purple.shade500,
          onTap: () {
            // PERUBAHAN: Buka halaman ArticleScreen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ArticleScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStickyButton() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          decoration: BoxDecoration(
            color: velyTheme.backgroundLight.withValues(alpha: 0.65),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
          ),
          child: CustomButton(
            text: 'Cek Gejala (vetly AI)',
            icon: Icons.auto_awesome_rounded,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TriageScreen()),
              );
            },
          ),
        ),
      ),
    );
  }
}
