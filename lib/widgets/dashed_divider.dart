import 'package:flutter/material.dart';

class DashedDivider extends StatelessWidget {
  final Color? color;
  final double dashWidth;
  final double dashHeight;

  const DashedDivider({
    super.key,
    this.color,
    this.dashWidth = 6.0,
    this.dashHeight = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxWidth = constraints.constrainWidth();
          final dashCount = (boxWidth / (2 * dashWidth)).floor();
          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color ?? Colors.grey.shade300,
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
