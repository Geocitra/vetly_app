import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/theme.dart';
import '../core/utils/responsive_wrapper.dart';
import '../providers/triage_provider.dart';
import '../widgets/symptom_chip.dart';
import '../widgets/custom_button.dart';
import 'loading_screen.dart'; // Akan kita buat dummy-nya di bawah

class TriageScreen extends StatelessWidget {
  const TriageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Kita baca nama hewan sekali saja di awal untuk header
    final petName = context.read<TriageProvider>().currentPet.name;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cek Gejala VETLY AI'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ResponsiveWrapper(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Apa yang dirasakan $petName saat ini?',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: VetlyTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pilih satu atau lebih gejala yang sesuai.',
                style: TextStyle(fontSize: 14, color: VetlyTheme.textGrey),
              ),
              const SizedBox(height: 24),

              // Area Grid Gejala
              Expanded(
                child: Consumer<TriageProvider>(
                  builder: (context, provider, child) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        // Logic Responsif: Jika lebar layar > 500 (Tablet), gunakan 4 kolom. Jika HP, 2 kolom.
                        final int crossAxisCount = constraints.maxWidth > 500
                            ? 4
                            : 2;

                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio:
                                    2.0, // Mengatur proporsi lebar:tinggi chip
                              ),
                          itemCount: provider.allSymptoms.length,
                          itemBuilder: (context, index) {
                            final symptom = provider.allSymptoms[index];
                            return SymptomChip(
                              symptom: symptom,
                              onTap: () => provider.toggleSymptom(symptom),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Area Tombol CTA
              Consumer<TriageProvider>(
                builder: (context, provider, child) {
                  final bool isEnabled = provider.selectedSymptoms.isNotEmpty;
                  return CustomButton(
                    text: 'Analisis Gejala (VETLY AI)',
                    // Tombol akan otomatis menjadi warna abu-abu (disabled) jika onPressed bernilai null
                    onPressed: isEnabled
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoadingScreen(),
                              ),
                            );
                          }
                        : null,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
