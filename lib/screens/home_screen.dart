import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/theme.dart';
import '../core/utils/responsive_wrapper.dart';
import '../widgets/pet_card.dart';
import '../widgets/custom_button.dart';
import 'triage_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _lastPressedAt;

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
          content: const Text('Tekan sekali lagi untuk keluar dari VETLY'),
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _handlePopInvocation,
      child: Scaffold(
        // Menghapus garis batas AppBar bawaan
        extendBodyBehindAppBar: true,
        body: ResponsiveWrapper(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  // Header Sapaan yang lebih kuat
                  const Text(
                    'Halo, Kak Budi & Rocky! 👋',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800, // Extra Bold untuk sapaan
                      color: VetlyTheme.textDark,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Apa yang bisa kami bantu hari ini?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: VetlyTheme.textGrey,
                    ),
                  ),
                  const SizedBox(
                    height: 36,
                  ), // Ruang napas (White space) yang lega

                  const PetCard(),

                  const Spacer(),

                  CustomButton(
                    text: 'Cek Gejala (VETLY AI)',
                    icon: Icons.smart_toy_rounded,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TriageScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Konsultasi Langsung',
                    icon: Icons.chat_bubble_outline_rounded,
                    isOutlined: true,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Skenario demo fokus pada jalur VETLY AI.',
                          ),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
        // Estetika Bottom Navigation Bar modern
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: VetlyTheme.surfaceWhite,
            selectedItemColor: VetlyTheme.primaryTeal,
            unselectedItemColor: VetlyTheme.textGrey.withValues(alpha: 0.5),
            elevation: 0,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            currentIndex: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history_rounded),
                label: 'Riwayat',
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
}
