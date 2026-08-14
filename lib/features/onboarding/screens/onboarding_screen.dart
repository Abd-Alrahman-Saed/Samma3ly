import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_mobile/core/theme/app_colors.dart';
import 'package:quran_mobile/core/theme/app_text_styles.dart';

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingPage({required this.icon, required this.title, required this.description});
}

const _pages = [
  _OnboardingPage(
    icon: Icons.person_add_alt_1,
    title: 'أضف طلابك',
    description: 'ابدأ بإضافة الطلاب مع بياناتهم الأساسية ومعلومات التواصل مع أولياء الأمور.',
  ),
  _OnboardingPage(
    icon: Icons.schedule,
    title: 'جدول الجلسات',
    description: 'حدد مواعيد الجلسات القادمة لكل طالب لتنظيم برنامج الحفظ والمراجعة.',
  ),
  _OnboardingPage(
    icon: Icons.playlist_add_check,
    title: 'سجّل الجلسات',
    description: 'بعد كل جلسة، سجّل الحضور والحفظ الجديد والمراجعة وقيّم أداء الطالب.',
  ),
  _OnboardingPage(
    icon: Icons.trending_up,
    title: 'تابع التقدم',
    description: 'راقب تقدم كل طالب من خلال لوحة التحكم والتقارير وقائمة المراجعة المستحقة.',
  ),
];

/// Standalone first-run product tour, also revisitable from Settings.
class OnboardingScreen extends StatefulWidget {
  final String nextRoute;

  const OnboardingScreen({super.key, this.nextRoute = 'dashboard'});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  void _finish() {
    context.goNamed(widget.nextRoute);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _page == _pages.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(onPressed: _finish, child: const Text('تخطي')),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) {
                  final page = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(24)),
                          child: Icon(page.icon, size: 48, color: AppColors.primary),
                        ),
                        const SizedBox(height: 32),
                        Text(page.title, style: AppTextStyles.pageHeader, textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        Text(page.description, style: AppTextStyles.body, textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < _pages.length; i++)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _page ? AppColors.primary : AppColors.divider,
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isLast
                      ? _finish
                      : () => _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                  child: Text(isLast ? 'ابدأ' : 'التالي'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
