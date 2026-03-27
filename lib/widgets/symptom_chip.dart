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
    final bool isSelected = symptom.isSelected;

    return GestureDetector(
      onTap: () {
        // Micro-interaction Taktil (Haptic Feedback)
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          // Background berubah menjadi Teal pudar jika dipilih
          color: isSelected
              ? velyTheme.primaryTeal.withValues(alpha: 0.1)
              : velyTheme.surfaceWhite,
          // Bentuk Kapsul/Pill (Stadium)
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            // Border menjadi Teal solid jika dipilih
            color: isSelected
                ? velyTheme.primaryTeal
                : velyTheme.textGrey.withValues(alpha: 0.2),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    // Efek 'Glow' Teal saat dipilih
                    color: velyTheme.primaryTeal.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ikon Medis/Gejala yang Relevan
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.healing_rounded,
              color: isSelected
                  ? velyTheme.primaryTeal
                  : velyTheme.textGrey.withValues(alpha: 0.5),
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              symptom.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? velyTheme.primaryTeal : velyTheme.textDark,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
