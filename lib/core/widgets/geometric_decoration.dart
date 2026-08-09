import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';

/// The eight-pointed-star decoration on the login screen — two overlapping
/// squares, one rotated 45°, thin gold outline at low opacity. A common
/// Islamic geometric motif; exact proportions from the design source.
class GeometricDecoration extends StatelessWidget {
  const GeometricDecoration({super.key, this.size = 140});

  final double size;

  @override
  Widget build(BuildContext context) {
    final squareSide = size * 0.6; // ٦٠ من ١٠٠ في نظام إحداثيات الملف المصدر
    return IgnorePointer(
      child: Opacity(
        opacity: 0.28,
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _square(squareSide),
              Transform.rotate(angle: math.pi / 4, child: _square(squareSide)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _square(double side) {
    return Container(
      width: side,
      height: side,
      decoration: BoxDecoration(border: Border.all(color: AppColors.accent, width: 1)),
    );
  }
}
