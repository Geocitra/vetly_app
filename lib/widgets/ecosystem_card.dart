import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/theme.dart';

class EcosystemCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color primaryColor;
  final VoidCallback onTap;

  const EcosystemCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: velyTheme
            .surfaceWhite, // PERBAIKAN: Memperbaiki typo velyTheme menjadi velyTheme
        borderRadius: BorderRadius.circular(
          20,
        ), // Dibuat sedikit lebih membulat agar proporsional di Grid
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          splashColor: primaryColor.withValues(alpha: 0.1),
          highlightColor: primaryColor.withValues(alpha: 0.05),
          child: Padding(
            // PERBAIKAN: Mengurangi padding dari 16 menjadi 14 agar lebih bernapas di layar kecil
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tinted Icon Container
                    Container(
                      // PERBAIKAN: Mengurangi padding dan ukuran icon agar rasio pas
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: primaryColor, size: 24),
                    ),
                    const SizedBox(width: 8), // Memberi buffer
                    // Badge "Segera" / Subtitle
                    // PERBAIKAN: Dibungkus Flexible agar teks panjang terpotong, bukan overflow
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: velyTheme.backgroundLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          subtitle,
                          maxLines: 1, // Anti Overflow
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: velyTheme.textGrey.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Spacer aman digunakan jika parent constraint cukup, tapi untuk grid kecil, ini akan mendorong sisa ruang dengan baik
                const Spacer(),

                // Text Title
                Text(
                  title,
                  maxLines:
                      1, // PERBAIKAN: Anti Overflow vertikal jika judul kepanjangan
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14, // Disesuaikan agar aman
                    fontWeight: FontWeight.w800,
                    color: velyTheme.textDark,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),

                // Indikator panah interaktif
                Row(
                  children: [
                    Text(
                      'Lihat detail',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700, // Dipertegas sedikit
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 12,
                      color: primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
