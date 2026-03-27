import 'package:flutter/material.dart';
import 'dart:math' as math; // Perbaikan: Import diletakkan di level top-file
import '../core/constants/theme.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Menghitung delay untuk masing-masing titik agar bergerak bergantian
              final double offset = index * 0.2;
              final double t = (_controller.value - offset) % 1.0;

              // Perbaikan: Menggunakan math.sin dari package asli
              final double y = t < 0.5 ? -4.0 * math.sin(t * math.pi * 2) : 0.0;

              // Titik meredup saat di bawah, menyala saat di atas
              final double opacity = t < 0.5 ? 1.0 : 0.4;

              return Transform.translate(
                offset: Offset(0, y < 0 ? y : 0),
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: VetlyTheme.primaryTeal.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
