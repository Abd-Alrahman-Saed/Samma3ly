import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatDate(DateTime date) {
    final formatter = DateFormat('yyyy-MM-dd', 'ar');
    return formatter.format(date);
  }

  static String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String relativeDate(DateTime date) {
    final today = DateTime.now();
    final diff = date.difference(today).inDays;

    if (date.year == today.year && date.month == today.month && date.day == today.day) {
      return 'اليوم';
    }
    if (diff == -1) return 'أمس';
    if (diff == 1) return 'غداً';
    if (diff < 0) return 'منذ ${-diff} أيام';
    if (diff < 7) return 'بعد $diff أيام';
    return formatDate(date);
  }

  static String weekDayName(DateTime date) {
    final formatter = DateFormat('EEEE', 'ar');
    return formatter.format(date);
  }

  static DateTime get weekStart {
    final now = DateTime.now();
    final weekday = now.weekday;
    return DateTime(now.year, now.month, now.day - (weekday - DateTime.sunday));
  }

  static DateTime get weekEnd => weekStart.add(const Duration(days: 7));
}
