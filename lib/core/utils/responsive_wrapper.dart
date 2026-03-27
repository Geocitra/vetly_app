import 'package:flutter/material.dart';

/// Memastikan konten tidak melebar ekstrem di layar besar (Tablet/Web).
/// Konten akan dibatasi pada lebar maksimum dan dipusatkan.
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.maxWidth = 600.0, // Batas wajar untuk mempertahankan 'Mobile Feel'
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        // Container putih sebagai kanvas utama di tengah layar jika dibuka di Tablet
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
