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
  // Mock data instruksi dokter
  final List<String> _careInstructions = [
    'Sediakan air minum bersih di dekat tempat tidurnya.',
    'Beri waktu istirahat penuh di area yang hangat dan tenang.',
    'Jangan berikan obat manusia tanpa resep dokter.',
    'Pantau intensitas gejala selama 12-24 jam ke depan.',
  ];

  // State untuk melacak checklist perawatan
  late List<bool> _checkedItems;

  @override
  void initState() {
    super.initState();
    _checkedItems = List.generate(_careInstructions.length, (index) => false);
  }

  void _toggleCheck(int index) {
    HapticFeedback.lightImpact(); // Micro-interaction taktil
    setState(() {
      _checkedItems[index] = !_checkedItems[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final pet = context.read<TriageProvider>().currentPet;
    final now = DateTime.now();
    final formattedDate =
        "${now.day}/${now.month}/${now.year} • ${now.hour}:${now.minute.toString().padLeft(2, '0')}";

    return Scaffold(
      backgroundColor: VetlyTheme.backgroundLight,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghilangkan tombol back default
        backgroundColor: VetlyTheme.backgroundLight,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Ringkasan Konsultasi',
          style: TextStyle(
            color: VetlyTheme.textDark,
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
              // Kartu Resep Medis Digital (Medical Receipt Card)
              Container(
                decoration: BoxDecoration(
                  color: VetlyTheme.surfaceWhite,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Resep: Info Dokter & Waktu
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: VetlyTheme.primaryTeal.withValues(
                                alpha: 0.1,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.assignment_turned_in_rounded,
                              color: VetlyTheme.primaryTeal,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Dr. Budi Santoso',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: VetlyTheme.textDark,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: VetlyTheme.textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const DashedDivider(),

                    // Identitas Pasien
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pasien',
                            style: TextStyle(
                              fontSize: 12,
                              color: VetlyTheme.textGrey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${pet.name} (${pet.breed})',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: VetlyTheme.primaryTeal,
                            ),
                          ),
                          const SizedBox(height: 24),

                          const Text(
                            'Rencana Perawatan (Checklist)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: VetlyTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Animated Checklist
                          ...List.generate(_careInstructions.length, (index) {
                            final isChecked = _checkedItems[index];
                            return GestureDetector(
                              onTap: () => _toggleCheck(index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isChecked
                                      ? VetlyTheme.backgroundLight
                                      : VetlyTheme.surfaceWhite,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isChecked
                                        ? Colors.transparent
                                        : Colors.grey.shade200,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      transitionBuilder: (child, animation) =>
                                          ScaleTransition(
                                            scale: animation,
                                            child: child,
                                          ),
                                      child: Icon(
                                        isChecked
                                            ? Icons.check_circle_rounded
                                            : Icons
                                                  .radio_button_unchecked_rounded,
                                        key: ValueKey<bool>(isChecked),
                                        color: isChecked
                                            ? VetlyTheme.primaryTeal
                                            : VetlyTheme.textGrey.withValues(
                                                alpha: 0.5,
                                              ),
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: AnimatedDefaultTextStyle(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 1.4,
                                          fontWeight: isChecked
                                              ? FontWeight.w500
                                              : FontWeight.w600,
                                          color: isChecked
                                              ? VetlyTheme.textGrey.withValues(
                                                  alpha: 0.6,
                                                )
                                              : VetlyTheme.textDark,
                                          decoration: isChecked
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                          fontFamily:
                                              'Poppins', // Menjaga konsistensi font saat animasi
                                        ),
                                        child: Text(_careInstructions[index]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Final CTA (Kembali ke Beranda & Reset Flow)
              CustomButton(
                text: 'Kembali ke Beranda',
                icon: Icons.home_rounded,
                onPressed: () {
                  // Kembali ke root dan me-reset seluruh state navigasi
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
}

// Custom Widget untuk Garis Putus-putus (Dashed Divider)
class DashedDivider extends StatelessWidget {
  const DashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxWidth = constraints.constrainWidth();
          const dashWidth = 6.0;
          const dashHeight = 1.5;
          final dashCount = (boxWidth / (2 * dashWidth)).floor();
          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.grey.shade300),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
