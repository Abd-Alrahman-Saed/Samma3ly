import 'package:flutter/material.dart';
import 'package:quran_mobile/core/widgets/confirm_dialog.dart';

Future<bool> confirmDiscardChanges(BuildContext context) {
  return showConfirmDialog(
    context,
    title: 'تجاهل التغييرات؟',
    message: 'لديك تغييرات غير محفوظة. هل تريد الخروج دون حفظها؟',
    confirmLabel: 'تجاهل',
    cancelLabel: 'البقاء',
  );
}
