import 'package:flutter/material.dart';

/// Sprint 1, item 1.7 — centralized motion tokens. No `Duration`/`Curve`
/// literals in widgets; everything routes through here so it stays
/// consistent and — critically — respects "reduce motion" uniformly.
class AppMotion {
  const AppMotion._();

  // ── Durations ──────────────────────────────────────────
  static const instant = Duration(milliseconds: 100); // ردّ فعل اللمس
  static const fast = Duration(milliseconds: 180); // تبديل الحالة
  static const base = Duration(milliseconds: 250); // الافتراضي
  static const slow = Duration(milliseconds: 350); // انتقال الشاشات
  static const deliberate = Duration(milliseconds: 600); // الاحتفالات

  // ── Curves ─────────────────────────────────────────────
  static const enter = Curves.easeOutCubic;
  static const exit = Curves.easeInCubic;
  static const move = Curves.easeInOutCubic;
  static const pop = Curves.easeOutBack; // نابض — للإنجازات فقط

  // ── Offsets ────────────────────────────────────────────
  static const slideInDy = 0.06;
  static const stagger = Duration(milliseconds: 45);
}

/// Reads the platform's "reduce motion" accessibility setting.
///
/// Every animated widget in this app must check this before animating —
/// see docs/UI_DESIGN_SYSTEM.md §1.1: ignoring it isn't just a UX nit, it
/// can trigger real motion sickness for users who've explicitly asked the
/// OS to minimize animation.
extension MotionQuery on BuildContext {
  bool get reduceMotion => MediaQuery.disableAnimationsOf(this);

  /// Returns [Duration.zero] when the user has reduced motion enabled,
  /// otherwise returns [d] unchanged. Use for one-off AnimatedFoo durations
  /// that don't go through [FadeSlideIn]/[PressableScale].
  Duration motionDuration(Duration d) => reduceMotion ? Duration.zero : d;
}
