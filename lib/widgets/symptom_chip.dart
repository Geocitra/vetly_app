import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/symptom.dart';
import '../core/constants/theme.dart';

class SymptomChip extends StatelessWidget {
  final Symptom symptom;
  final VoidCallback onTap;

  const SymptomChip({super.key, required this.symptom, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Memberikan getaran halus saat chip ditekan
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          // Background berubah menjadi Teal transparan jika dipilih
          color: symptom.isSelected
              ? VetlyTheme.primaryTeal.withValues(alpha: 0.1)
              : VetlyTheme.surfaceWhite,
          border: Border.all(
            // Border menjadi Teal solid jika dipilih, jika tidak abu-abu tipis
            color: symptom.isSelected
                ? VetlyTheme.primaryTeal
                : VetlyTheme.textGrey.withValues(alpha: 0.3),
            width: symptom.isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (symptom.isSelected) ...[
              const Icon(
                Icons.check_circle,
                color: VetlyTheme.primaryTeal,
                size: 24,
              ),
              const SizedBox(height: 4),
            ],
            Text(
              symptom.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: symptom.isSelected
                    ? VetlyTheme.primaryTeal
                    : VetlyTheme.textDark,
                fontWeight: symptom.isSelected
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
