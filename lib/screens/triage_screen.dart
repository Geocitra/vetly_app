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
    final pet = context.read<TriageProvider>().currentPet;

    return Scaffold(
      backgroundColor: velyTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: velyTheme.backgroundLight,
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
          'Asisten AI vely',
          style: TextStyle(
            color: velyTheme.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ResponsiveWrapper(
        child: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. AI Persona & Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAIPersona(pet),
                        const SizedBox(height: 24),
                        _buildSearchBar(),
                        const SizedBox(height: 32),
                        const Text(
                          'Gejala Umum',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: velyTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                // 2. GRID GEJALA (2 Kolom Presisi)
                Consumer<TriageProvider>(
                  builder: (context, provider, child) {
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          // ASPECT RATIO: Dibuat sedikit lebih tinggi (0.8 - 0.9)
                          // agar jika teks wrap ke baris kedua, tidak overflow bawah.
                          childAspectRatio: 1.4,
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

                const SliverToBoxAdapter(child: SizedBox(height: 140)),
              ],
            ),

            // 3. STICKY BUTTON
            _buildStickyButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAIPersona(dynamic pet) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: velyTheme.primaryTeal.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: velyTheme.primaryTeal.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 24, backgroundImage: AssetImage(pet.imageUrl)),
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
                      color: velyTheme.primaryTeal,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'vely AI Active',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: velyTheme.primaryTeal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Halo Kak Budi, mari kita periksa ${pet.name}. Pilih gejala yang terlihat.',
                  style: const TextStyle(
                    fontSize: 14,
                    color: velyTheme.textDark,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: velyTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            size: 20,
            color: velyTheme.textGrey.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Cari gejala (mis. Muntah)...',
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

  Widget _buildStickyButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: velyTheme.backgroundLight.withValues(alpha: 0.75),
              border: const Border(
                top: BorderSide(color: Colors.white, width: 1.5),
              ),
            ),
            child: Consumer<TriageProvider>(
              builder: (context, provider, child) {
                final selectedCount = provider.selectedSymptoms.length;
                final bool isEnabled = selectedCount > 0;
                return CustomButton(
                  text: isEnabled
                      ? 'Analisa $selectedCount Gejala'
                      : 'Pilih Gejala Terlebih Dahulu',
                  icon: Icons.auto_awesome_rounded,
                  onPressed: isEnabled
                      ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoadingScreen(),
                          ),
                        )
                      : null,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
