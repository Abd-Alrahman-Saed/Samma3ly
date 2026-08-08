import 'package:flutter/material.dart';

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'تأكيد',
  String cancelLabel = 'إلغاء',
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(cancelLabel)),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: destructive ? TextButton.styleFrom(foregroundColor: Theme.of(ctx).colorScheme.error) : null,
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}
