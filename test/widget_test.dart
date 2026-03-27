// Test ini disesuaikan untuk arsitektur vely MVP
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// Sesuaikan nama package dengan nama project Anda (velyapp)
import 'package:vely_app/main.dart';
import 'package:vely_app/providers/triage_provider.dart';

void main() {
  testWidgets('velyApp initialization & routing smoke test', (
    WidgetTester tester,
  ) async {
    // 1. Membangun aplikasi dengan Dependency Injection yang sama persis seperti di main.dart
    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => TriageProvider())],
        child: const velyApp(),
      ),
    );

    // 2. Karena ada animasi atau loading state dari Provider (jika ada), kita pump frame sekali lagi
    await tester.pumpAndSettle();

    // 3. Verifikasi UI: Memastikan bahwa HomeScreen berhasil dimuat.
    // Kita mencari teks statis yang ada di HomeScreen fase 3.
    expect(find.textContaining('Halo, Kak Budi & Rocky!'), findsOneWidget);

    // 4. Memastikan tombol utama CTA juga ter-render
    expect(find.text('Cek Gejala (vely AI)'), findsOneWidget);

    // 5. Verifikasi Negatif: Memastikan aplikasi counter bawaan sudah benar-benar hilang
    expect(find.byIcon(Icons.add), findsNothing);
  });
}
