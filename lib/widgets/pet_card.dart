import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/theme.dart';
import '../providers/triage_provider.dart';

class PetCard extends StatelessWidget {
  const PetCard({super.key});

  @override
  Widget build(BuildContext context) {
    final pet = context.watch<TriageProvider>().currentPet;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: VetlyTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Area Foto Asli Rocky
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: VetlyTheme.primaryTeal.withValues(alpha: 0.15),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: VetlyTheme.primaryTeal.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                18,
              ), // Sedikit lebih kecil dari container agar border terlihat
              child: Image.asset(
                pet.imageUrl,
                fit: BoxFit.cover,
                // Fallback jika path gambar salah/belum di-load
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.pets,
                  size: 40,
                  color: VetlyTheme.primaryTeal,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Area Informasi Teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pet.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: VetlyTheme.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${pet.breed} • ${pet.ageInMonths} Bulan',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: VetlyTheme.textGrey,
                  ),
                ),
                const SizedBox(height: 12),
                // Premium Badge Indikator Vaksin
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange.shade200, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        size: 14,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        pet.vaccineStatus.first,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
