import 'package:flutter/material.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/utils/error_utils.dart';

class AppSnackbar {
  AppSnackbar._();

  static void _show(BuildContext context, String message, IconData icon, Color iconColor, {String? actionLabel, VoidCallback? onAction}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        action: actionLabel != null && onAction != null ? SnackBarAction(label: actionLabel, onPressed: onAction) : null,
      ),
    );
  }

  static void success(BuildContext context, String message, {String? actionLabel, VoidCallback? onAction}) {
    _show(context, message, Icons.check_circle, AppColors.success, actionLabel: actionLabel, onAction: onAction);
  }

  /// Logs the raw [error] and shows a friendly Arabic message; never surfaces raw exception text.
  static void error(BuildContext context, Object error) {
    _show(context, AppErrorUtils.friendlyMessage(error), Icons.error_outline, AppColors.danger);
  }

  static void info(BuildContext context, String message, {String? actionLabel, VoidCallback? onAction}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: actionLabel != null && onAction != null ? SnackBarAction(label: actionLabel, onPressed: onAction) : null,
      ),
    );
  }
}
