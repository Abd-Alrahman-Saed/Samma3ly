import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final String? ctaLabel;
  final VoidCallback? onCta;
  final bool card;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.ctaLabel,
    this.onCta,
    this.card = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: card ? 48 : 64, color: colorScheme.onSurfaceVariant),
        const SizedBox(height: 16),
        Text(title, style: textTheme.bodyLarge, textAlign: TextAlign.center),
        if (description != null) ...[
          const SizedBox(height: 4),
          Text(description!, style: textTheme.bodySmall, textAlign: TextAlign.center),
        ],
        if (ctaLabel != null && onCta != null) ...[
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: Text(ctaLabel!),
            onPressed: onCta,
          ),
        ],
      ],
    );

    if (card) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: content,
        ),
      );
    }
    return Center(child: content);
  }
}
