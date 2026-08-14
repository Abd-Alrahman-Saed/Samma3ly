import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/icons/app_icons.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/widgets/app_form_field.dart';
import 'package:quran_mobile/core/widgets/app_logo_mark.dart';
import 'package:quran_mobile/core/widgets/app_snackbar.dart';
import 'package:quran_mobile/features/auth/providers/auth_provider.dart';

/// شاشة الإعداد الأولي — تُعرض مرة واحدة فقط عند أول تشغيل للتطبيق. تطبيق
/// شخصي لمعلّم واحد بلا كلمة مرور: الاسم فقط، ثم دخول مباشر بلا أي شاشة
/// "تسجيل دخول" لاحقاً.
class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _setup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(authStateProvider.notifier).setupTeacher(_fullNameController.text.trim());
      if (mounted) {
        context.goNamed('onboarding', queryParameters: const {'next': 'dashboard'});
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
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppLogoMark(size: 54, radius: 14, icon: AppIcons.person, iconSize: 26, showBadge: false),
                  const SizedBox(height: 14),
                  const Text('مرحباً بك', style: TextStyle(fontFamily: 'Reem Kufi', fontSize: 20, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  const Text(
                    'أدخل اسمك لبدء استخدام التطبيق',
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  AppFormField(
                    controller: _fullNameController,
                    label: 'الاسم',
                    validator: (v) => v == null || v.trim().isEmpty ? 'الرجاء إدخال الاسم' : null,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _setup,
                      child: _isLoading
                          ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary))
                          : const Text('ابدأ'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
