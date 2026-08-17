# سمَّعلي (Samma3ly)

تطبيق موبايل لمعلّم/معلّمة تحفيظ القرآن الكريم — لمتابعة الطلاب، تسجيل
جلسات الحفظ والمراجعة الفردية والجماعية (الحلقات)، تقييم التسميع، تتبّع
الحفظ بالجزء/الربع، الأهداف، التقارير، والتذكيرات — كل ده من الموبايل،
بدون إنترنت (بيانات محلية بالكامل على الجهاز).

Built with Flutter — offline-first, single-teacher Quran memorization
tracker: students, individual & group (حلقات) recitation sessions with
4-criteria evaluation, manual juz/quarter memorization progress, goals,
weekly scheduling, notifications, reports, and local JSON backup/restore.

## تحميل التطبيق

آخر إصدار APK متاح دايماً من [صفحة الإصدارات (Releases)](https://github.com/Abd-Alrahman-Saed/Samma3ly/releases/latest) — نزّل ملف `.apk` وثبّته مباشرة على جهاز أندرويد.

## المزايا

- إدارة الطلاب والحلقات (المجموعات)، بمعلّم واحد لكل تطبيق (بلا تسجيل دخول معقّد).
- جلسات فردية وجماعية، بحضور وتقييم بأربعة معايير (حفظ/تجويد/طلاقة/تشكيل) لكل من الحفظ الجديد والمراجعة.
- قرار سريع بعد التسميع (اجتاز/يُعاد) يظهر في كل قوائم الجلسات — يعرف المعلّم فوراً أي جلسة تحتاج إعادة.
- تتبّع الحفظ يدوياً بالجزء والربع، مع أهداف قابلة للمتابعة.
- جدول أسبوعي متكرر للحلقات، وتقويم أسبوعي موحَّد لكل الجلسات.
- تذكيرات محلية قابلة للتخصيص لمواعيد المراجعة والحلقات.
- تقارير عامة وتقرير مفصَّل لكل طالب، قابل للمشاركة.
- نسخ احتياطي واستعادة (JSON) — كل البيانات على الجهاز، بلا خادم خارجي.
- عربي بالكامل (RTL)، خط Cairo، تصميم مخصَّص (راجع `docs/DESIGN_SPEC.md`).

## التقنيات

- [Flutter](https://flutter.dev) + [Riverpod](https://riverpod.dev) لإدارة الحالة.
- [Drift](https://drift.simonbinder.eu) (SQLite) للتخزين المحلي، مع نظام ترقية schema صارم (راجع `docs/IMPLEMENTATION_PLAN.md`).
- [go_router](https://pub.dev/packages/go_router) للتنقّل.
- `flutter_local_notifications` للتذكيرات المحلية.

## التشغيل محلياً

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## الاختبارات

```bash
flutter test
```

راجع `docs/IMPLEMENTATION_PLAN.md` لتفاصيل كل قرار تنفيذي ولماذا، و`docs/DESIGN_SPEC.md` لنظام التصميم الكامل (الألوان، الخطوط، الأيقونات).

## المساهمة

المشروع مفتوح المصدر ومرحِّب بالمساهمات — Issues وPull Requests مرحَّب
بيهم. لو بتضيف تعديلاً على الـschema (Drift)، اتّبع انضباط الترقية
الموثَّق في `docs/IMPLEMENTATION_PLAN.md` (نسخة جديدة لكل تعديل schema،
مايتلغيش migration اتشحن قبل كده).

## الترخيص

[MIT](LICENSE)
