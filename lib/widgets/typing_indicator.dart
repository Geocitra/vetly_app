import 'package:flutter/material.dart';
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Logika stagger (jeda) sederhana menggunakan nilai sinus
            final double offset = index * 0.2;
            final double t = (_controller.value + offset) % 1.0;
            final double opacity = t < 0.5 ? 1.0 - (t * 2) : (t - 0.5) * 2;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Opacity(
                opacity: opacity.clamp(0.2, 1.0),
                child: const CircleAvatar(
                  radius: 4,
                  backgroundColor: VetlyTheme.textGrey,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
