import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_mobile/core/widgets/app_snackbar.dart';
import 'package:quran_mobile/providers.dart';

class ConvertToSessionButton extends ConsumerStatefulWidget {
  final int scheduleId;
  final VoidCallback onConverted;

  const ConvertToSessionButton({super.key, required this.scheduleId, required this.onConverted});

  @override
  ConsumerState<ConvertToSessionButton> createState() => _ConvertToSessionButtonState();
}

class _ConvertToSessionButtonState extends ConsumerState<ConvertToSessionButton> {
  bool _isLoading = false;

  Future<void> _convert() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(scheduleRepositoryProvider);
      await repo.convertToSession(widget.scheduleId);
      widget.onConverted();
      if (mounted) {
        AppSnackbar.success(context, 'تم تحويل الجدول إلى جلسة');
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.error(context, e);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    return IconButton(
      icon: Icon(Icons.check_circle_outline, color: Theme.of(context).colorScheme.primary),
      tooltip: 'تحويل إلى جلسة',
      onPressed: _convert,
    );
  }
}
