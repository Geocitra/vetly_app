import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/theme.dart';
import 'providers/triage_provider.dart';
import 'screens/splash_screen.dart'; // Pastikan untuk mengimpor file splash_screen

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TriageProvider())],
      child: const velyApp(),
    ),
  );
}

// ignore: camel_case_types
class velyApp extends StatelessWidget {
  const velyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'vely',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: velyTheme.primaryTeal,
        scaffoldBackgroundColor: velyTheme.backgroundLight,
        fontFamily: 'Poppins', // Pastikan font Anda sudah terkonfigurasi
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: velyTheme.backgroundLight,
          iconTheme: IconThemeData(color: velyTheme.textDark),
          titleTextStyle: TextStyle(
            color: velyTheme.textDark,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      // PERUBAHAN UTAMA: Ubah titik awal dari HomeScreen() menjadi SplashScreen()
      home: const SplashScreen(),
    );
  }
}
