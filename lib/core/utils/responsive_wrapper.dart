import 'package:flutter/material.dart';
import '../constants/theme.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.maxWidth = 600.0, // Batas rasio emas untuk Mobile UI
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Latar belakang di luar area aplikasi (Hanya terlihat di Tablet)
      color: const Color(0xFFEAECEF), // Dimmed gray
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Container(
            // Kanvas utama aplikasi
            decoration: BoxDecoration(
              color: VetlyTheme.backgroundLight,
              boxShadow: [
                BoxShadow(
                  // Bayangan pendar yang luas untuk efek 'Floating'
                  color: VetlyTheme.primaryTeal.withValues(alpha: 0.08),
                  blurRadius: 40,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
