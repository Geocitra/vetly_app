import 'package:flutter/material.dart';
import '../core/constants/theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;

    final Widget buttonContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[Icon(icon, size: 22), const SizedBox(width: 10)],
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700, // Bold untuk hierarki CTA yang kuat
            letterSpacing: 0.5,
          ),
        ),
      ],
    );

    // Style untuk Outlined Button (Secondary)
    if (isOutlined) {
      return SizedBox(
        width: double.infinity,
        height: 56, // Tinggi ergonomis premium
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: velyTheme.primaryTeal,
            side: BorderSide(
              color: isDisabled ? Colors.grey.shade300 : velyTheme.primaryTeal,
              width: 2, // Border sedikit lebih tebal agar terlihat solid
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Sudut membulat modern
            ),
            elevation: 0,
          ),
          child: buttonContent,
        ),
      );
    }

    // Style untuk Primary Button (Dengan Soft Shadow Teal)
    return Container(
      width: double.infinity,
      height: 56, // Tinggi ergonomis premium
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDisabled
            ? []
            : [
                BoxShadow(
                  // Bayangan pendar Teal (bukan hitam) untuk efek mewah
                  color: velyTheme.primaryTeal.withValues(alpha: 0.25),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: velyTheme.primaryTeal,
          foregroundColor: velyTheme.surfaceWhite, // Warna teks dan ikon
          elevation: 0, // Elevation ditangani oleh Container Shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          // Perbaikan: Menggunakan overlayColor untuk efek splash/ripple
          overlayColor: velyTheme.surfaceWhite.withValues(alpha: 0.1),
        ),
        child: buttonContent,
      ),
    );
  }
}
