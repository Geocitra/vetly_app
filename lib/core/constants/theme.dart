import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VetlyTheme {
  // Warna Utama (Primary)
  static const Color primaryTeal = Color(0xFF00A896);
  static const Color secondaryTeal = Color(0xFF02C39A);

  // Warna Latar & Netral Baru (Lebih bersih dan luas)
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color textDark = Color(
    0xFF1E2022,
  ); // Lebih tajam dari sebelumnya
  static const Color textGrey = Color(0xFF7A869A);
  static const Color surfaceWhite = Colors.white;

  // Definisi Tema Terpusat
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryTeal,
      scaffoldBackgroundColor: backgroundLight,
      // Menerapkan Poppins secara global sebagai standar tipografi
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: textDark,
        displayColor: textDark,
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryTeal,
        secondary: secondaryTeal,
        surface: surfaceWhite,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundLight, // Menyatu dengan background aplikasi
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: textDark),
        titleTextStyle: GoogleFonts.poppins(
          color: textDark,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
