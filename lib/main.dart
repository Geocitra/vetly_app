import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/theme.dart';
import 'providers/triage_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    // Injeksi TriageProvider di root aplikasi agar context-nya bisa diakses global
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TriageProvider())],
      child: const VetlyApp(),
    ),
  );
}

class VetlyApp extends StatelessWidget {
  // Menggunakan Super Parameter sesuai standar Dart 2.17+
  const VetlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VETLY Prototype',
      debugShowCheckedModeBanner: false,
      theme: VetlyTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
