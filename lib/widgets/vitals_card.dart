import 'package:flutter/material.dart';
import '../core/constants/theme.dart';
import '../models/pet_profile.dart';

class VitalsCard extends StatelessWidget {
  final PetProfile pet;

  const VitalsCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: VetlyTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildVitalItem(Icons.monitor_weight_outlined, 'Berat', '12 kg'),
          Container(width: 1, height: 40, color: Colors.grey.shade200),
          _buildVitalItem(
            Icons.cake_outlined,
            'Usia',
            '${pet.ageInMonths} Bln',
          ),
          Container(width: 1, height: 40, color: Colors.grey.shade200),
          _buildVitalItem(
            Icons.verified_user_outlined,
            'Vaksin',
            'Aman',
            iconColor: Colors.green.shade500,
          ),
        ],
      ),
    );
  }

  Widget _buildVitalItem(
    IconData icon,
    String label,
    String value, {
    Color? iconColor,
  }) {
    return Column(
      children: [
        Icon(icon, color: iconColor ?? VetlyTheme.primaryTeal, size: 26),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: VetlyTheme.textGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: VetlyTheme.textDark,
          ),
        ),
      ],
    );
  }
}
