import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quran_mobile/core/theme/app_motion.dart';

/// Sprint 1, item 1.8 — standard entrance animation for list items and
/// cards. Always checks [MotionQuery.reduceMotion] first — the whole point
/// of centralizing this is that no widget can forget to.
class FadeSlideIn extends StatelessWidget {
  final Widget child;

  /// Position within a list — multiplied by [AppMotion.stagger] so items
  /// cascade in reading order instead of all animating at once.
  final int index;

  const FadeSlideIn({super.key, required this.child, this.index = 0});

  @override
  Widget build(BuildContext context) {
    if (context.reduceMotion) return child;
    return child
        .animate(delay: AppMotion.stagger * index)
        .fadeIn(duration: AppMotion.base, curve: AppMotion.enter)
        .slideY(begin: AppMotion.slideInDy, curve: AppMotion.enter);
  }
}

/// Standard tap feedback — a subtle scale-down plus the platform ripple,
/// combined so touch targets get both cues instead of just one.
class PressableScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius,
  });

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _down = false;

  void _setDown(bool value) {
    if (_down != value) setState(() => _down = value);
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = context.reduceMotion;
    return GestureDetector(
      onTapDown: (_) => _setDown(true),
      onTapUp: (_) => _setDown(false),
      onTapCancel: () => _setDown(false),
      child: AnimatedScale(
        scale: _down && !reduceMotion ? 0.97 : 1.0,
        duration: AppMotion.instant,
        curve: AppMotion.enter,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: widget.borderRadius,
            onTap: widget.onTap,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
