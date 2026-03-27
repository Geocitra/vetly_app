import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/theme.dart';
import '../providers/triage_provider.dart';

class PetCard extends StatelessWidget {
  const PetCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil data secara reaktif
    final pet = context.watch<TriageProvider>().currentPet;

    return Container(
      padding: const EdgeInsets.all(24), // Padding lega untuk kesan 'Calm'
      decoration: BoxDecoration(
        color: velyTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(
          24,
        ), // Sudut sangat membulat (aman & ramah)
        boxShadow: [
          BoxShadow(
            // Bayangan pendar yang luas dan transparan (Soft UI)
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Area Foto dengan Efek Glassmorphism Hint
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              // Gradasi halus transparan mirip pantulan kaca
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  velyTheme.primaryTeal.withValues(alpha: 0.1),
                  velyTheme.primaryTeal.withValues(alpha: 0.02),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: velyTheme.primaryTeal.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            // ClipRRect untuk memastikan foto asli terpotong rapi membulat
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                pet.imageUrl, // Menggunakan gambar asli Golden Retriever
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.pets_rounded,
                  size: 40,
                  color: velyTheme.primaryTeal,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Area Informasi Teks dengan Hierarki Kuat
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pet.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800, // Extra Bold untuk nama
                    color: velyTheme.textDark,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${pet.breed} • ${pet.ageInMonths} Bulan',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: velyTheme.textGrey,
                  ),
                ),
                const SizedBox(height: 12),
                // Premium Badge Indikator Vaksin (Soft Orange)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
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
                        pet
                            .vaccineStatus
                            .first, // Skenario: "Rabies (3 Hari Lagi)"
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
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
