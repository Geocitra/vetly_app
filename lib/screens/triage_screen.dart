import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/theme.dart';
import '../core/utils/responsive_wrapper.dart';
import '../providers/triage_provider.dart';
import '../widgets/symptom_chip.dart';
import '../widgets/custom_button.dart';
import 'loading_screen.dart';

class TriageScreen extends StatelessWidget {
  const TriageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Information Expert: Mengambil data pet dari provider
    final pet = context.read<TriageProvider>().currentPet;

    return Scaffold(
      backgroundColor: VetlyTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: VetlyTheme.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: VetlyTheme.textDark,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Asisten AI VETLY',
          style: TextStyle(
            color: VetlyTheme.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ResponsiveWrapper(
        child: Stack(
          children: [
            // Lapisan Dasar: Area Scrollable
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. AI Persona & Search Bar Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card AI Persona (Membangun kepercayaan psikologis)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: VetlyTheme.primaryTeal.withValues(
                              alpha: 0.08,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: VetlyTheme.primaryTeal.withValues(
                                alpha: 0.15,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage: AssetImage(pet.imageUrl),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.auto_awesome_rounded,
                                          size: 16,
                                          color: VetlyTheme.primaryTeal,
                                        ),
                                        const SizedBox(width: 6),
                                        const Text(
                                          'VETLY AI Active',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: VetlyTheme.primaryTeal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Halo Kak Budi, mari kita periksa ${pet.name}. Sentuh gejala yang terlihat.',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: VetlyTheme.textDark,
                                        fontWeight: FontWeight.w500,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Mockup Smart Search Bar (Efisiensi waktu pengguna)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: VetlyTheme.surfaceWhite,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search_rounded,
                                color: VetlyTheme.textGrey.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Cari gejala (mis. Kejang, Muntah)...',
                                style: TextStyle(
                                  color: VetlyTheme.textGrey.withValues(
                                    alpha: 0.7,
                                  ),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Gejala Umum',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: VetlyTheme.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 2. Grid Gejala (Anti-Overflow & Responsive)
                Consumer<TriageProvider>(
                  builder: (context, provider, child) {
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent:
                                  180, // Dynamic max width per chip
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 1.1,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final symptom = provider.allSymptoms[index];
                          return SymptomChip(
                            symptom: symptom,
                            onTap: () => provider.toggleSymptom(symptom),
                          );
                        }, childCount: provider.allSymptoms.length),
                      ),
                    );
                  },
                ),

                // 3. Spacer agar grid bisa di-scroll sepenuhnya melewati sticky button
                const SliverToBoxAdapter(child: SizedBox(height: 140)),
              ],
            ),

            // Lapisan Atas: Sticky CTA Button (Glassmorphism)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 12,
                    sigmaY: 12,
                  ), // Intensitas blur kaca
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                    decoration: BoxDecoration(
                      color: VetlyTheme.backgroundLight.withValues(alpha: 0.75),
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withValues(alpha: 0.6),
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Consumer<TriageProvider>(
                      builder: (context, provider, child) {
                        final selectedCount = provider.selectedSymptoms.length;
                        final bool isEnabled = selectedCount > 0;

                        return CustomButton(
                          // Label dinamis berdasarkan status state
                          text: isEnabled
                              ? 'Analisa $selectedCount Gejala'
                              : 'Pilih Gejala Terlebih Dahulu',
                          icon: Icons.auto_awesome_rounded,
                          onPressed: isEnabled
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const LoadingScreen(),
                                    ),
                                  );
                                }
                              : null,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
