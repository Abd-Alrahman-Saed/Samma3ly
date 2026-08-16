import 'package:flutter/material.dart';

/// قائمة اختيار جزء من الأجزاء الثلاثين، بأسماء عربية ترتيبية (الأول،
/// الثاني، ...، الثلاثون) بدل إدخال رقم يدوياً. طلب المستخدم لبند هدف
/// جديد — لكنه ودجت عام قابل لإعادة الاستخدام في أي مكان يحتاج اختيار جزء.
class JuzDropdown extends StatelessWidget {
  final int? value;
  final ValueChanged<int?> onChanged;
  final String label;
  final String noneLabel;

  const JuzDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = 'الجزء',
    this.noneLabel = 'بدون',
  });

  static const List<String> _ordinals = [
    'الأول',
    'الثاني',
    'الثالث',
    'الرابع',
    'الخامس',
    'السادس',
    'السابع',
    'الثامن',
    'التاسع',
    'العاشر',
    'الحادي عشر',
    'الثاني عشر',
    'الثالث عشر',
    'الرابع عشر',
    'الخامس عشر',
    'السادس عشر',
    'السابع عشر',
    'الثامن عشر',
    'التاسع عشر',
    'العشرون',
    'الحادي والعشرون',
    'الثاني والعشرون',
    'الثالث والعشرون',
    'الرابع والعشرون',
    'الخامس والعشرون',
    'السادس والعشرون',
    'السابع والعشرون',
    'الثامن والعشرون',
    'التاسع والعشرون',
    'الثلاثون',
  ];

  /// "الجزء الأول"، "الجزء الثاني"، ... لجزء رقم 1..30.
  static String label30(int juzNumber) => 'الجزء ${_ordinals[juzNumber - 1]}';

  @override
  Widget build(BuildContext context) {
    final validValue = value != null && value! >= 1 && value! <= 30 ? value : null;
    return DropdownButtonFormField<int?>(
      initialValue: validValue,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: [
        DropdownMenuItem<int?>(value: null, child: Text(noneLabel)),
        for (var i = 1; i <= 30; i++) DropdownMenuItem<int?>(value: i, child: Text(label30(i))),
      ],
      onChanged: onChanged,
    );
  }
}
