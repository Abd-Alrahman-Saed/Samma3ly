import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

/// Wraps a list item with a subtle fade/slide-in entrance animation.
/// The parent [ListView] must be wrapped in an [AnimationLimiter].
class StaggeredListItem extends StatelessWidget {
  final int index;
  final Widget child;

  const StaggeredListItem({super.key, required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 300),
      child: SlideAnimation(
        verticalOffset: 30.0,
        child: FadeInAnimation(child: child),
      ),
    );
  }
}
