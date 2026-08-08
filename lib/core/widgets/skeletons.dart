import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppShimmer extends StatelessWidget {
  final Widget child;

  const AppShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: child,
    );
  }
}

class ListItemSkeleton extends StatelessWidget {
  const ListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const CircleAvatar(backgroundColor: Colors.white, radius: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 14, width: 140, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(height: 12, width: 90, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListSkeleton extends StatelessWidget {
  final int itemCount;

  const ListSkeleton({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: itemCount,
        itemBuilder: (_, __) => const ListItemSkeleton(),
      ),
    );
  }
}

class KpiCardSkeleton extends StatelessWidget {
  const KpiCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                ),
                const SizedBox(width: 8),
                Expanded(child: Container(height: 13, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 12),
            Container(height: 24, width: 60, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class KpiGridSkeleton extends StatelessWidget {
  final int rows;

  const KpiGridSkeleton({super.key, this.rows = 3});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        children: List.generate(
          rows,
          (i) => Padding(
            padding: EdgeInsets.only(bottom: i == rows - 1 ? 0 : 12),
            child: const Row(
              children: [
                Expanded(child: KpiCardSkeleton()),
                SizedBox(width: 12),
                Expanded(child: KpiCardSkeleton()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
