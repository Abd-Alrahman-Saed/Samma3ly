import 'package:flutter/material.dart';
import 'package:quran_mobile/core/widgets/confirm_dialog.dart';

Future<bool> confirmDelete(BuildContext context, {String title = 'تأكيد الحذف', required String message}) {
  return showConfirmDialog(
    context,
    title: title,
    message: message,
    confirmLabel: 'حذف',
    destructive: true,
  );
}

void showUndoSnackbar(BuildContext context, String message, VoidCallback onUndo) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      action: SnackBarAction(label: 'تراجع', onPressed: onUndo),
    ),
  );
}
