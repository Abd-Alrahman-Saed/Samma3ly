# تقرير مقترحات تطوير تطبيق `quran_mobile`

**بصفة:** Flutter Tech Lead + خبير في إدارة حِلَق التحفيظ
**التاريخ:** 2026-08-07
**النسخة الحالية:** 1.0.0+1 — Flutter 3.2+, Riverpod, Drift, GoRouter

---

## 0. الخلاصة التنفيذية (TL;DR)

التطبيق الحالي **بنيته الهندسية سليمة ومحترمة** (Clean Architecture: `data / domain / features`، Drift DAOs، Riverpod، GoRouter، Skeletons، Empty States، Semantics). دي أساس ممتاز — مش هنرميه.

لكن فيه **٣ فجوات كبيرة** تمنعه من إنه يبقى منتج حقيقي:

| # | الفجوة | الأثر |
|---|--------|-------|
| **1** | **النموذج فردي بالكامل** — كل شيء مربوط بـ `studentId` واحد. مفيش مجموعات/حِلَق، ومفيش تكرار أسبوعي (`Schedules` = صف واحد لتاريخ واحد) | المعلّم اللي عنده حلقة ٢٠ طالب لازم يعمل ٢٠ جدولة يدوية كل أسبوع. عملياً غير قابل للاستخدام |
| **2** | **الـ UI شغّال بس "generic"** — أيقونة Flutter الافتراضية (544 بايت)، اسم التطبيق `quran_mobile`، Primary color أزرق SaaS `#2563EB`، مفيش Dark Mode، مفيش صور/رسوم، مفيش خط مصحف | يبان كـ prototype مش منتج |
| **3** | **ثغرات هندسية إنتاجية** — `schemaVersion = 1` بدون أي migration، كلمات السر SHA-256 بجولة واحدة، قاعدة بيانات غير مشفّرة، ملف اختبار واحد، N+1 queries في `ProgressService`، وأخطاء حسابية في احتساب الأجزاء المكتملة | أول تحديث للـ schema هيكسّر بيانات المستخدمين |

**التوصية:** ٤ مراحل على ~١٠–١٢ أسبوع. المرحلة الأولى (المجموعات + الجدولة المتكررة) هي اللي بتحوّل التطبيق من "أداة تسجيل" إلى "نظام إدارة حلقات".

---

# الجزء الأول: تقييم الوضع الحالي (Tech Lead Review)

## 1.1 ما هو جيد فعلاً — نحافظ عليه

- **فصل الطبقات نظيف**: `domain/entities` + `domain/repositories` (abstract) + `data/repositories/*_impl` — ده pattern صحيح ومطبّق بانضباط.
- **Drift DAOs منفصلة** لكل كيان بدل DAO عملاق.
- **حالات الـ UI مكتملة**: عندك `skeletons.dart`, `empty_state.dart`, `error_banner.dart`, `loading_overlay.dart`, `app_snackbar.dart`, `confirm_delete.dart`, `discard_changes_dialog.dart` — أغلب التطبيقات بتنسى دول.
- **`PopScope` + `_isDirty`** في شاشات الإنشاء = حماية من فقد البيانات. ممتاز.
- **`Semantics` في الـ Dashboard** (ترتيب أفضل ٥ طلاب) — وعي بالـ accessibility.
- **كشف التعارض في الجدولة** موجود في [schedule_create_screen.dart](lib/features/schedules/screens/schedule_create_screen.dart) — الفكرة صح، محتاجة توسعة للمجموعات.
- **نظام المراجعة المتباعدة** (`MemorizedRanges` + `nextReviewDate` + إشعارات محلية) — فكرة قوية جداً وموجودة بالفعل.

## 1.2 المشاكل الحرجة (Blockers)

### 🔴 B1 — لا يوجد نظام Migrations إطلاقاً

```dart
// lib/data/local/database/app_database.dart
int get schemaVersion => 1;
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (m) async { ... },   // ← onUpgrade مفقود تماماً
);
```

أي إضافة جدول (زي `Groups`) هتخلي التطبيق **يفشل في الإقلاع** عند المستخدمين الحاليين، أو أسوأ: يفتح بقاعدة بيانات ناقصة الأعمدة.

**الحل:**
1. تفعيل `drift_dev schema dump` + `schema generate` → مجلد `drift_schemas/`.
2. كتابة `onUpgrade` مع `stepByStep` من drift 2.x.
3. إضافة **migration tests** (drift بيولّدها) في CI.

```dart
@override
int get schemaVersion => 2;

@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (m) async { await m.createAll(); await _seedAll(); },
  onUpgrade: stepByStep(
    from1To2: (m, schema) async {
      await m.createTable(schema.groups);
      await m.createTable(schema.groupMembers);
      await m.createTable(schema.groupScheduleSlots);
      await m.addColumn(schema.sessions, schema.sessions.groupId);
    },
  ),
  beforeOpen: (details) async {
    await customStatement('PRAGMA foreign_keys = ON');   // ← غير مفعّل حالياً!
  },
);
```

> ⚠️ ملاحظة إضافية: `PRAGMA foreign_keys` **غير مفعّل**، يعني كل الـ `.references()` الموجودة في الجداول **مش بتتنفّذ فعلياً** على مستوى SQLite. حذف طالب حالياً بيسيب جلسات يتيمة.

### 🔴 B2 — أخطاء حسابية في تتبّع التقدّم

في [progress_service.dart](lib/domain/services/progress_service.dart):

```dart
final ayahCount = memorizations
    .where((m) => m.surahId == range.surahId && m.fromAyah >= range.fromAyah && m.toAyah <= range.toAyah)
    .fold<int>(0, (sum, m) => sum + (m.toAyah - m.fromAyah + 1));
if (ayahCount < targetCount) { juzComplete = false; }
```

**المشكلة:** المجموع بيجمع **آيات متداخلة أو مكرّرة**. لو الطالب سمّع البقرة ١–١٠ في جلستين (إعادة تسميع)، النتيجة `20` بدل `10` → **جزء يُحتسب مكتمل وهو ناقص**. نفس الخطأ في `syncGoalProgress` (هدف السورة والجزء).

**الحل:** حساب **اتحاد الفترات** (interval union) قبل الجمع:

```dart
int coveredAyahs(List<(int from, int to)> ranges) {
  if (ranges.isEmpty) return 0;
  final sorted = [...ranges]..sort((a, b) => a.$1.compareTo(b.$1));
  var total = 0, curFrom = sorted.first.$1, curTo = sorted.first.$2;
  for (final r in sorted.skip(1)) {
    if (r.$1 <= curTo + 1) { curTo = r.$2 > curTo ? r.$2 : curTo; }
    else { total += curTo - curFrom + 1; curFrom = r.$1; curTo = r.$2; }
  }
  return total + curTo - curFrom + 1;
}
```

**كمان:** الشرط `m.fromAyah >= range.fromAyah && m.toAyah <= range.toAyah` بيتجاهل الحفظ اللي **يتقاطع جزئياً** مع حدود الجزء (مثلاً حفظ البقرة ١٣٠–١٥٠ يقع على حدّ الجزء ١/٢) → بيتحسب صفر في الاتنين. لازم يبقى تقاطع (`intersection`) مش احتواء (`containment`).

### 🔴 B3 — N+1 Queries في كل مسار التقدّم

```dart
final allSessions = await _sessionDao.getAll(studentId: studentId);
for (final s in presentSessions) {
  final mem = await _sessionDao.getMemorizationBySession(s.id);   // ← استعلام لكل جلسة
}
```

و `syncStudentProgress` بيستدعي `_calculateCompletedJuz` اللي **بيعيد جلب نفس البيانات من الأول**. طالب عنده ١٠٠ جلسة = ~٢٠٤ استعلامات لكل حفظ جلسة.

**الحل:** استعلام واحد بـ `join` في `SessionDao`:
```dart
Future<List<SessionMemorization>> getMemorizationsForStudent(int studentId) {
  final q = select(sessionMemorizations).join([
    innerJoin(sessions, sessions.id.equalsExp(sessionMemorizations.sessionId)),
  ])..where(sessions.studentId.equals(studentId) & sessions.attendanceStatus.equals(DomainConstants.present));
  return q.map((r) => r.readTable(sessionMemorizations)).get();
}
```

### 🔴 B4 — كتابة داخل مسار القراءة

`MemorizedRangeService.getByStudent()` **بيعدّل الحالة في قاعدة البيانات** ثم يعيد القراءة مرتين:

```dart
Future<List<MemorizedRange>> getByStudent(int studentId) async {
  final ranges = await _dao.getByStudent(studentId);
  for (final r in ranges) { ... await _dao.updateEntry(...); }   // ← side effect في getter
  return _dao.getByStudent(studentId);                            // ← قراءة ثانية
}
```

ده بيسبّب: كتابات عشوائية عند كل rebuild، تعطيل الـ `watch` streams، و flicker في الـ UI. كمان `needsSave` متغيّر ميّت (بيتحسب ومش بيتستخدم).

**الحل:** `status` تبقى **حقل محسوب** (computed) مش مخزّن:
```dart
MemorizedStatus statusAt(DateTime today) =>
    nextReviewDate != null && !nextReviewDate!.isAfter(today)
        ? MemorizedStatus.needsRevision : MemorizedStatus.memorized;
```

### 🟠 B5 — الأمان

| البند | الحالي | المطلوب |
|-------|--------|---------|
| تشفير كلمة المرور | `SHA-256(salt + password)` — **جولة واحدة** | PBKDF2 (100k+ iterations) أو Argon2id عبر حزمة `cryptography` |
| قاعدة البيانات | نص صريح على القرص (`quran_management.db`) | SQLCipher عبر `sqlcipher_flutter_libs` + مفتاح في `flutter_secure_storage` |
| قفل التطبيق | لا يوجد | PIN / بصمة (`local_auth`) + انتهاء جلسة |
| بيانات الطلاب | أسماء + هواتف أولياء أمور، غير محمية | تشفير + سياسة خصوصية (شرط متجر Google Play) |

### 🟠 B6 — نصوص عربية داخل قاعدة البيانات

```dart
TextColumn get attendanceStatus => text().withDefault(const Constant('حاضر'))();
TextColumn get level => text().withDefault(const Constant('مبتدئ'))();
TextColumn get status => text().withDefault(const Constant('محفوظ'))();
```

و في الكود: `s.attendanceStatus == 'حاضر'` مقارنات نصية مباشرة في `ProgressService`.

الـ enums موجودة (`AttendanceStatus`, `StudentLevel`, `MemorizedStatus`) لكن القيمة المخزّنة عربية → أي تغيير في صياغة الكلمة يكسر البيانات، والترجمة لأي لغة تانية مستحيلة. **نفس المشكلة اللي اتحلّت بالفعل في نسخة الديسكتوب** (commit `2adc9ad — Phase 6: replace magic Arabic status strings with DomainConstants`) — لازم نطبّق نفس الحل هنا.

**الحل:** تخزين `snake_case` إنجليزي (`present`, `absent`, `memorized`) + `.arabic` getter للعرض + migration تحويلية.

### 🟠 B7 — التوطين (i18n) غير مُفعّل

`flutter_localizations` مضاف في `pubspec.yaml` و `app.dart` بيسجّل الـ delegates — لكن **مفيش `l10n.yaml` ولا ملفات `.arb` إطلاقاً**. كل النصوص hardcoded داخل الـ widgets (`'الرئيسية'`, `'تم حفظ الجدولة'`, ...).

**الحل:** استخراج كل النصوص لـ `lib/l10n/app_ar.arb` + `app_en.arb` باستخدام `flutter gen-l10n`. ده كمان بيفتح السوق لغير الناطقين بالعربية (حلقات في أوروبا/أمريكا/آسيا — سوق ضخم).

### 🟡 B8 — أمور أخرى

- **`PendingChanges` جدول ميّت**: موجود في الـ schema ومستخدم فقط في `backup_service`، مش مربوط بأي مزامنة فعلية. إما نكمّله (مزامنة مع نظام الديسكتوب WPF) أو نشيله.
- **اختبار واحد فقط**: `test/widget_test.dart`. مفيش unit tests لـ `ProgressService` (وهو أخطر كود في المشروع)، ولا golden tests.
- **`riverpod_annotation` + `riverpod_generator` مثبّتين بس غير مستخدمين** — كل الـ providers يدوية في `providers.dart`. إما نستخدم الـ codegen أو نشيل الاعتمادية.
- **`_requireLogin` ثابت `const bool` في الراوتر** — flag تطوير مسرّب في كود الإنتاج.
- **`dependency_overrides: analyzer_plugin`** — دَين تقني، يتراجع عند تحديث الحزم.

---

# الجزء الثاني: ميزة المجموعات / الحِلَق (الأولوية القصوى)

## 2.1 لماذا هذه أهم ميزة

في الواقع العملي، **٩٠٪ من التحفيظ يتم في حِلَق جماعية** لا جلسات فردية:
- الحلقة لها **اسم** (حلقة الفاروق)، **مكان** (مسجد النور — الدور الأول)، **معلّم**، **مستوى**.
- لها **موعد أسبوعي متكرر** (السبت والاثنين والأربعاء بعد المغرب).
- الطلاب **ينضمون ويخرجون** عبر الزمن.
- المعلّم في الحلقة بيسجّل **حضور جماعي** بضغطة واحدة، بعدين يسمّع طالب طالب.

النموذج الحالي (`Sessions.studentId` + `Schedules` لتاريخ واحد) لا يدعم أي من ده.

## 2.2 نموذج البيانات المقترح

```
Groups (الحلقات)
├── id, name, teacherUserId → Users
├── locationName, locationDetails, latitude?, longitude?
├── level (مبتدئ/متوسط/متقدم/تثبيت), capacity, colorTag
├── startDate, endDate?, isActive, notes
└── createdAt, updatedAt

GroupMembers (عضوية تاريخية — مش مجرد رابط)
├── id, groupId → Groups, studentId → Students
├── joinedAt, leftAt?, membershipStatus (active/paused/left)
└── UNIQUE(groupId, studentId, joinedAt)

GroupScheduleSlots (قاعدة التكرار الأسبوعي)
├── id, groupId → Groups
├── weekday (1=السبت … 7=الجمعة)
├── anchorType: 'fixed' | 'after_prayer'
├── startTime (HH:mm — لو fixed)
├── prayerAnchor: 'fajr'|'dhuhr'|'asr'|'maghrib'|'isha' + offsetMinutes  (لو after_prayer)
├── durationMinutes
├── effectiveFrom, effectiveTo?     ← يسمح بتغيير المواعيد بدون فقد التاريخ
└── createdAt

ScheduleExceptions (استثناءات)
├── id, groupId, originalDate
├── exceptionType: 'cancelled' | 'moved' | 'holiday'
├── newDate?, newTime?, reason (إجازة/سفر المعلّم/رمضان)
└── createdAt

Sessions (تعديل على الموجود)
├── + groupId? → Groups
├── + sessionType: 'individual' | 'group'
├── + occurrenceDate (تاريخ التكرار الأصلي — للربط بالـ slot)
└── studentId يصبح nullable (جلسة المجموعة ليست لطالب واحد)

SessionAttendances (جدول جديد — الحضور صار متعدد)
├── id, sessionId → Sessions, studentId → Students
├── status (present/absent/late/excused)
├── lateMinutes?, excuseReason?, notes?
└── UNIQUE(sessionId, studentId)
```

> **قرار معماري مهم:** `attendanceStatus` حالياً **عمود على `Sessions`** — ده يشتغل لطالب واحد بس. لازم ينتقل لجدول `SessionAttendances`. لكن **لا نكسر التوافق**: نخلي العمود القديم موجود مع migration ينقل البيانات لجدول الحضور الجديد، وبعد نسختين نشيله.

## 2.3 محرّك الجدولة — التوصية المعمارية

فيه مدرستان:

| النهج | المزايا | العيوب |
|-------|---------|--------|
| **Materialization** (توليد صفوف Session مسبقاً لكل أسبوع) | استعلامات بسيطة | تضخّم قاعدة البيانات، تعديل قاعدة التكرار = كابوس (لازم تعيد توليد وتحافظ على المسجّل) |
| **Virtual Occurrences** (حساب المواعيد على الطاير من الـ slots) | مرن، لا تضخّم، تعديل القاعدة فوري | الاستعلامات أعقد |

**التوصية: نهج هجين** ✅

1. عرض التقويم/"جلسات الأسبوع" **يُحسب افتراضياً** من `GroupScheduleSlots` + `ScheduleExceptions` — بدون صفوف في قاعدة البيانات.
2. **أول ما المعلّم يفتح الحلقة ويسجّل حضور** → نُنشئ صف `Session` حقيقي (materialize on write).
3. أفق الحساب: ٨ أسابيع للأمام في الواجهة.

```dart
/// lib/domain/services/recurrence_service.dart
class GroupOccurrence {
  final int groupId;
  final DateTime date;
  final TimeOfDay startTime;
  final int durationMinutes;
  final int? materializedSessionId;   // null = لسه ما اتسجّلش
  final bool isCancelled;
}

class RecurrenceService {
  /// يولّد المواعيد الافتراضية لمدى زمني، مع تطبيق الاستثناءات
  List<GroupOccurrence> expand({
    required List<GroupScheduleSlot> slots,
    required List<ScheduleException> exceptions,
    required DateTime from,
    required DateTime to,
  });
}
```

**نقاط لازم تتعالج في المحرّك:**
- التوقيت الصيفي (استخدم `timezone` — موجودة بالفعل في `pubspec`).
- `effectiveFrom/To` عشان تغيير الموعد من الشهر الجاي ما يغيّرش تاريخ الشهر اللي فات.
- رمضان: تعليق جماعي أو تحويل المواعيد لبعد التراويح (استثناء بالجملة).
- الأعياد والإجازات.

## 2.4 المواعيد المرتبطة بالصلاة — ميزة مميّزة 🌟

في الواقع، حلقات المساجد **بتتجدول نسبةً للأذان مش للساعة**: "بعد المغرب بربع ساعة"، "بعد العصر مباشرة". الوقت ده **بيتغيّر كل يوم** حسب الموقع والموسم.

هي دي الميزة اللي هتفرق تطبيقك عن أي تطبيق جدولة عام. التنفيذ:
- حزمة `adhan` (Dart) لحساب مواقيت الصلاة محلياً من خطوط الطول/العرض — **بدون إنترنت**.
- إحداثيات الحلقة مخزّنة في `Groups.latitude/longitude`.
- عرض: «حلقة الفاروق — السبت بعد المغرب بـ ١٥ د (٦:٤٢ م اليوم)».
- الإشعارات تُجدول على الوقت المحسوب فعلياً لليوم ده.

## 2.5 تدفّق المستخدم المقترح (الشاشات الجديدة)

```
/groups                          قائمة الحلقات — كارت لكل حلقة (اسم، مكان، عدد الطلاب، الموعد القادم)
/groups/create                   إنشاء: اسم + مكان + معلّم + مستوى + سعة + لون
/groups/:id                      تفاصيل الحلقة (Tabs):
   ├── نظرة عامة                إحصائيات + الموعد القادم + نسبة الحضور
   ├── الطلاب                    إضافة/إزالة أعضاء (Multi-select من الطلاب)
   ├── المواعيد                  محرّر الجدول الأسبوعي ← ⭐ القلب
   └── السجل                     الجلسات السابقة
/groups/:id/schedule             محرّر الأيام: شبكة أيام الأسبوع + وقت لكل يوم
/groups/:id/session/:date        شاشة الحلقة المباشرة ← ⭐⭐ أهم شاشة في التطبيق
```

### شاشة محرّر الجدول الأسبوعي

```
┌──────────────────────────────────────┐
│  مواعيد حلقة الفاروق                 │
├──────────────────────────────────────┤
│  [السبت] [الأحد] [الاثنين] [الثلاثاء]│   ← ChoiceChips قابلة للتبديل
│  [الأربعاء] [الخميس] [الجمعة]        │
├──────────────────────────────────────┤
│  ● السبت      بعد المغرب + ١٥ د  ⏱٦٠│
│  ● الاثنين    بعد المغرب + ١٥ د  ⏱٦٠│
│  ● الأربعاء   ٥:٠٠ م              ⏱٩٠│
├──────────────────────────────────────┤
│  نوع التوقيت:  ( ) ساعة ثابتة        │
│                (●) مرتبط بالصلاة     │
│  الصلاة: [المغرب ▾]  بعدها بـ [١٥] د │
│  المدة:  [٦٠] دقيقة                  │
├──────────────────────────────────────┤
│  🔁 يبدأ من: ١ سبتمبر ٢٠٢٦           │
│     ينتهي:   (مستمر)                 │
└──────────────────────────────────────┘
    [ حفظ — سيتم جدولة ٢٤ جلسة للشهرين القادمين ]
```

### شاشة الحلقة المباشرة (أهم شاشة) ⭐⭐

ده اللي المعلّم بيفتحه وهو قاعد في الحلقة. لازم يكون **أسرع مسار في التطبيق**:

```
┌──────────────────────────────────────┐
│ ← حلقة الفاروق · السبت ٧ أغسطس       │
│   مسجد النور · ٦:٤٢ م               │
├──────────────────────────────────────┤
│  الحضور: ١٢/١٥        [تحضير الكل ✓] │  ← ضغطة واحدة = الكل حاضر
├──────────────────────────────────────┤
│ 👤 أحمد محمد        [✓][✗][⏰][📄]   │  ← Segmented: حاضر/غائب/متأخر/مستأذن
│    البقرة ١–٢٠ · آخر تسميع ٩٢٪        │
│    ▸ اضغط للتسميع                     │
├──────────────────────────────────────┤
│ 👤 عمر خالد         [✓][✗][⏰][📄]   │
│    آل عمران ١–١٥ · متأخر عن الخطة     │  ← تنبيه ذكي
├──────────────────────────────────────┤
│              [ إنهاء الحلقة ]         │
└──────────────────────────────────────┘
```

**قواعد UX:**
- الحضور بضغطة واحدة لكل طالب (Segmented Button، لا Dropdown ولا Dialog).
- «تحضير الكل» بيملأ الكل حاضر، والمعلّم بيعدّل الاستثناءات فقط (٩٠٪ من الوقت الطلاب حاضرين).
- التسميع في **Bottom Sheet** مش شاشة جديدة — يفضل سياق الحلقة موجود.
- حفظ تلقائي (auto-save) بعد كل تفاعل — المعلّم ممكن يقفل التطبيق فجأة.
- Haptic feedback عند التحضير.

---

# الجزء الثالث: مقترحات من منظور خبير تحفيظ

دي الميزات اللي هتخلي معلّم تحفيظ حقيقي يقول «التطبيق ده متعمول بواسطة حد فاهم».

## 3.1 🔴 نموذج المراجعة الثلاثي (سبق / حاضر / ماضي)

**أهم اقتراح في التقرير من الناحية التخصصية.**

المنهج المعتمد في كل حلقات التحفيظ المنظّمة (دور القرآن، الأزهر، الأوقاف) بيقسّم الورد اليومي لثلاثة:

| القسم | المعنى | الحجم المعتاد |
|-------|--------|---------------|
| **الحفظ الجديد (السبق)** | المقرر الجديد اليوم | ½ – ١ وجه |
| **المراجعة القريبة (الحاضر)** | آخر ٥ أجزاء محفوظة | ٢ – ٥ أوجه يومياً |
| **المراجعة البعيدة (الماضي)** | باقي المحفوظ بالتدوير | ١ – ٢ جزء يومياً |

**الحالي:** جدول `MemorizedRanges` بـ `revisionCycleDays` ثابت = ٧ لكل النطاقات. ده تبسيط مفرط — لا يفرّق بين المحفوظ حديثاً (يحتاج مراجعة كل يوم) والمحفوظ من سنة (يكفي كل شهر).

**المقترح:**
```dart
enum RevisionTier {
  sabq,      // السبق - الحفظ الجديد (مراجعة يومية، ٣ أيام)
  hadir,     // الحاضر - آخر ٥ أجزاء (كل ٣–٧ أيام)
  madi,      // الماضي - التثبيت (تدوير كل ٢١–٣٠ يوم)
}
```
+ ترقية تلقائية بين الطبقات: نطاق يتم تسميعه بنجاح (≥٩٠٪) ٣ مرات متتالية → يترقّى من `sabq` لـ `hadir`، وهكذا. نطاق يفشل فيه التسميع → يرجع طبقة للخلف.
+ خوارزمية SM-2 مبسّطة: `interval = interval × easeFactor` مع `easeFactor` يتعدّل حسب درجة التسميع.

**شاشة «ورد اليوم»** تعرض القراءات الثلاثة للطالب بشكل مباشر — دي الشاشة اللي الطالب/ولي الأمر هيفتحوها كل يوم.

## 3.2 🔴 التتبّع بالصفحات والأوجه — لا بالآيات

**المعلّمون لا يقولون «احفظ البقرة ١٤٢–١٦٠». يقولون «احفظ وجهين».**

النموذج الحالي كله بالآيات (`fromAyah`/`toAyah`). ده تقني وغير مألوف للمستخدم:
- ٦٠٤ صفحة في المصحف المدني، كل صفحة = وجه، كل وجه ١٥ سطر.
- «كم حفظت؟» الإجابة دايماً بالأجزاء والأوجه.
- الخطط تُكتب بالأوجه: «وجه يومياً = ختمة في سنتين».

**الحل:** جدول تعيين `MushafPages(pageNumber, surahId, fromAyah, toAyah, juzNumber, hizbNumber)` (بيانات ثابتة seed، ٦٠٤ صف تقريباً + التقسيمات) ثم:
- إدخال مزدوج: المعلّم يختار **صفحة/وجه** والنظام يحوّلها لآيات داخلياً.
- كل الإحصائيات تُعرض بالأوجه والأجزاء والأحزاب، مش بعدد الآيات.
- `Dashboard` الحالي بيعرض `totalPagesMemorized` — بس من غير جدول تعيين حقيقي، الرقم ده تقديري.

> ملاحظة: `QuranUtils.getAyahCount` بيكرّر بيانات موجودة في جدول `Surahs` — مصدرَي حقيقة لنفس البيانات. يُوحّد.

## 3.3 🟠 تصنيف أخطاء التلاوة (بدل درجة رقمية واحدة)

`SessionEvaluations.finalScore` رقم واحد. المعلّم الحقيقي بيسجّل **نوع الخطأ**:

| التصنيف | النوع | الوزن |
|---------|-------|-------|
| **لحن جليّ** | خطأ يغيّر المعنى (حركة إعراب، حرف) | خطير — يُعاد التسميع |
| **لحن خفيّ** | خطأ في التجويد (مدّ، غنّة، إخفاء) | متوسط |
| **تردّد / توقّف** | الطالب توقف واحتاج تلقين | خفيف |
| **نسيان آية** | حذف/تخطّي | خطير |

**المقترح:** جدول `RecitationErrors(sessionId, surahId, ayahNumber, wordIndex?, errorType, wasCorrected)`.

**العائد الكبير:** تقرير «الأخطاء المتكررة» لكل طالب — «أحمد يخطئ في المدّ المنفصل ١٤ مرة هذا الشهر» → المعلّم يعرف يركّز على إيه بالظبط. **دي ميزة ما فيش تطبيق عربي بيعملها كويس.**

## 3.4 🟠 معيار تقييم مركّب (Rubric)

بدل درجة واحدة، أربعة محاور بأوزان قابلة للضبط:

```
الحفظ (الإتقان)     ████████░░  ٤٠٪
التجويد             ██████░░░░  ٣٠٪
الأداء والصوت       ████░░░░░░  ١٥٪
الالتزام والسلوك    ██████████  ١٥٪
                    ─────────────
النهائي                     ٨٧٪
```

## 3.5 🟠 مخطّط الختمة والخطط الزمنية

- المعلّم يحدّد: «الطالب يختم ٣٠ جزء في ٣ سنوات» → النظام يحسب **الورد اليومي المطلوب** ويتابع الانحراف.
- مؤشّر «متقدّم/متأخر عن الخطة بـ X أوجه».
- **توقّع تاريخ الختمة** بناءً على المعدل الفعلي آخر ٣٠ يوم — رقم يحفّز الطلاب جداً.
- نظام `Goals` الحالي موجود (سورة/جزء) — يُوسّع ليشمل خطط زمنية بمعدّل يومي.

## 3.6 🟠 تسجيل التسميع صوتياً

- زر تسجيل في شاشة التسميع → ملف محلي مربوط بالجلسة (`record` + `just_audio`).
- الفائدة: ولي الأمر يسمع تسميع ابنه، والمعلّم يراجع عند الخلاف على الدرجة، وأرشيف للإجازات.
- إدارة المساحة: ضغط + حذف تلقائي بعد ٩٠ يوم (قابل للضبط).

## 3.7 🟡 بوابة ولي الأمر والتقرير الأسبوعي

`share_plus` و `url_launcher` **موجودين بالفعل في `pubspec`** — نستغلهم:

- زر «إرسال تقرير أسبوعي» → رسالة واتساب منسّقة لولي الأمر:
  ```
  📋 تقرير أحمد محمد — الأسبوع ٣٢
  الحضور: ٣/٣ ✅
  الحفظ الجديد: وجهان (البقرة ١٤٢–١٧٦)
  متوسط التقييم: ٩٢٪ ⭐
  ملاحظة المعلّم: أداء ممتاز، يحتاج تركيز في المدّ.
  ```
- تقرير PDF شهري للإدارة (`pdf` + `printing`).
- **شهادات إتمام** (سورة/جزء/ختمة) بتصميم إسلامي جاهز للطباعة — الأطفال بيحبوها والأهالي بيشاركوها.

## 3.8 🟡 التحفيز (Gamification) — للأطفال

- نقاط: حضور (+١٠)، تسميع متقن (+٢٥)، إتمام سورة (+١٠٠).
- أوسمة: «حافظ جزء عمّ» 🏅، «مواظب ٣٠ يوم» 🔥، «متقن التجويد» ✨.
- لوحة شرف الحلقة (اختيارية — بعض المعلّمين يرفضون المقارنة العلنية، فتُجعل قابلة للإطفاء).
- الـ `topStudents` الموجود في الـ Dashboard أساس جيد لده.

## 3.9 🟡 التقويم الهجري والسياق الإسلامي

- عرض مزدوج ميلادي/هجري (`hijri` package).
- وضع رمضان: تعليق تلقائي أو تحويل المواعيد + خطة ختمة رمضانية.
- إشعارات المراجعة **مجدولة حالياً على الساعة ٩ صباحاً بشكل ثابت** (`DateTime(..., 9)` في [notification_service.dart](lib/core/services/notification_service.dart)) — لازم تبقى قابلة للضبط، والأفضل ربطها بوقت صلاة.

## 3.10 🟡 الإجازة والسند

للحلقات المتقدمة: تتبّع الإجازات بالسند المتصل، الرواية (حفص/ورش/قالون)، وشجرة الإسناد. سوق نيش لكنه **عالي القيمة** ولا يخدمه أي تطبيق حالياً.

---

# الجزء الرابع: رفع الـ UI لمستوى Production

## 4.1 الوضع الحالي بصراحة

| البند | الحالة |
|-------|--------|
| أيقونة التطبيق | ❌ أيقونة Flutter الافتراضية (`ic_launcher.png` = **544 بايت**) |
| اسم التطبيق | ❌ `android:label="quran_mobile"` — اسم المشروع مش اسم المنتج |
| Splash Screen | ❌ شاشة بيضاء افتراضية |
| Dark Mode | ❌ `AppTheme.light` فقط، `darkTheme` غير موجود |
| اللون الأساسي | ⚠️ `#2563EB` أزرق — لون Tailwind الافتراضي، بلا هوية |
| الصور والرسوم | ❌ صفر — كل الحالات الفارغة أيقونات Material رمادية |
| صور الطلاب | ❌ غير مدعومة إطلاقاً |
| خط المصحف | ❌ الآيات (لو عُرضت) هتظهر بخط Cairo — **غير مقبول** |
| الحركات | ⚠️ `flutter_animate` + `flutter_staggered_animations` مثبّتين، استخدام محدود |

## 4.2 الهوية البصرية المقترحة

**اللوحة:** الأزرق الحالي بيدّي إحساس «لوحة تحكم SaaS». التحفيظ يستدعي **الأخضر والذهبي** — ألوان المصاحف والمساجد التقليدية:

```dart
class AppColors {
  // الهوية الأساسية — أخضر زيتوني عميق
  static const primary        = Color(0xFF1B5E4A);
  static const primaryDark    = Color(0xFF0F3D30);
  static const primaryLight   = Color(0xFFE6F2EE);

  // اللمسة الذهبية — للإنجازات والشهادات والأوسمة
  static const accent         = Color(0xFFC9A227);
  static const accentLight    = Color(0xFFFBF3D9);

  // ألوان دلالية
  static const success        = Color(0xFF16A34A);   // حاضر / متقن
  static const warning        = Color(0xFFD97706);   // متأخر / يحتاج مراجعة
  static const danger         = Color(0xFFDC2626);   // غائب / لحن جليّ
  static const info           = Color(0xFF2563EB);   // معلومة

  // طبقات ورقية (مستوحاة من ورق المصحف)
  static const surfaceCream   = Color(0xFFFAF8F3);
  static const surfaceRaised  = Color(0xFFFFFFFF);
}
```

**مبدأ حاكم:** توليد `ColorScheme` من الـ seed مرة واحدة، وكل الويدجتات تقرأ من `Theme.of(context).colorScheme` — **ممنوع** استخدام `AppColors.x` مباشرة في الويدجتات (زي `fillColor: Colors.white` الموجود دلوقتي في `inputDecorationTheme`، ده بيكسر الـ Dark Mode تماماً).

```dart
static ThemeData _base(Brightness b) => ThemeData(
  useMaterial3: true,
  brightness: b,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: b,
    secondary: AppColors.accent,
  ),
  ...
);
static ThemeData get light => _base(Brightness.light);
static ThemeData get dark  => _base(Brightness.dark);
```
+ `themeMode` من `SettingsProvider` (فاتح/داكن/تلقائي).

## 4.3 مشكلة الخطوط 🔴

```yaml
fonts:
  - family: Cairo
    fonts:
      - asset: assets/fonts/Cairo-VariableFont_wght.ttf
        weight: 400
      - asset: assets/fonts/Cairo-VariableFont_wght.ttf   # ← نفس الملف
        weight: 500
      - asset: assets/fonts/Cairo-VariableFont_wght.ttf   # ← نفس الملف
        weight: 600
      - asset: assets/fonts/Cairo-VariableFont_wght.ttf   # ← نفس الملف
        weight: 700
```

**المشكلة:** تسجيل نفس ملف الـ variable font لأربعة أوزان **لا يُنتج أوزاناً مختلفة**. Flutter بيحمّل الملف بالمحور الافتراضي (400) لكل الأوزان، والنتيجة إن `FontWeight.bold` بيتعمله **تعريض صناعي (synthetic bold)** — نص عربي مشوّه وثقيل بصرياً.

**الحل:**
```yaml
fonts:
  - family: Cairo
    fonts:
      - { asset: assets/fonts/Cairo-Regular.ttf,  weight: 400 }
      - { asset: assets/fonts/Cairo-Medium.ttf,   weight: 500 }
      - { asset: assets/fonts/Cairo-SemiBold.ttf, weight: 600 }
      - { asset: assets/fonts/Cairo-Bold.ttf,     weight: 700 }

  # خط المصحف — إلزامي لعرض الآيات
  - family: QuranHafs
    fonts:
      - asset: assets/fonts/UthmanicHafs.ttf
```

**قاعدة:** أي نص قرآني يُعرض بخط عثماني (`KFGQPC Uthmanic Hafs` مجاني من مجمع الملك فهد أو `Amiri Quran`)، بحجم أكبر (٢٠–٢٤sp) و `height: 2.0` للتباعد. عرض آية بخط Cairo زي عرض كود برمجي بخط Comic Sans — بيقتل المصداقية فوراً عند الجمهور المستهدف.

## 4.4 الأيقونات والأصول الحقيقية

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.1
  flutter_native_splash: ^2.4.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/branding/icon_1024.png"
  adaptive_icon_background: "#1B5E4A"
  adaptive_icon_foreground: "assets/branding/icon_foreground.png"
  min_sdk_android: 21

flutter_native_splash:
  color: "#1B5E4A"
  image: assets/branding/splash_logo.png
  android_12:
    image: assets/branding/splash_logo_android12.png
    color: "#1B5E4A"
```
+ `android:label="نور — إدارة حلقات التحفيظ"` (اسم منتج حقيقي).

**بنية الأصول المقترحة:**
```
assets/
├── branding/       icon_1024.png, icon_foreground.png, splash_logo.png, logo_wordmark.svg
├── illustrations/  empty_students.svg, empty_sessions.svg, empty_groups.svg,
│                   error_generic.svg, offline.svg, success_khatma.svg
├── patterns/       geometric_1..6.svg   ← أنماط إسلامية هندسية لأغلفة الحلقات
├── icons/          mushaf.svg, tajweed.svg, ijazah.svg, halaqa.svg  ← أيقونات مخصصة
└── fonts/          Cairo-*.ttf, UthmanicHafs.ttf
```

+ `flutter_svg` للرسوم، و **صور الطلاب**: `image_picker` + قصّ دائري + `Avatar` بالحروف الأولى كبديل (بلون مشتق من الاسم عبر hash — تنويع بصري مجاني بدون صور).

> **ملاحظة قانونية:** لا تستخدم صوراً من الإنترنت. استخدم مصادر مرخّصة (unDraw, Storyset, Freepik بترخيص) أو رسوم مخصصة، واحتفظ بإثبات الترخيص — Google Play بتسأل.

## 4.5 إعادة هيكلة التنقل (IA)

**الحالي:** شريط سفلي بـ ٥ عناصر (الرئيسية/الطلاب/الجلسات/التقارير/الإعدادات)، و**الجداول والأهداف وقائمة المراجعة مدفونة كـ `ListTile` جوّه الـ Dashboard** — ميزات أساسية مخبّية.

**المقترح:**
```
[ اليوم ]  [ الحلقات ]  [ الطلاب ]  [ التقارير ]  [ المزيد ]
```
- **اليوم** — يحلّ محل «الرئيسية»: حلقات النهاردة + المراجعات المستحقة + إجراء سريع. المعلّم بيفتح التطبيق عشان يعرف «أعمل إيه دلوقتي»، مش عشان يشوف KPIs.
- **الحلقات** — الشاشة الجديدة (وبداخلها الجداول).
- **المزيد** — الأهداف، قائمة المراجعة، النسخ الاحتياطي، الإعدادات، المستخدمون.
- زر `+` عائم (FAB) بقائمة سريعة: تسجيل جلسة / إضافة طالب / إنشاء حلقة.

## 4.6 تفاصيل الصنعة (Polish)

| العنصر | التنفيذ |
|--------|---------|
| **Hero transitions** | صورة/حرف الطالب من القائمة → شاشة التفاصيل |
| **KPI عدّاد متحرك** | `TweenAnimationBuilder` بدل رقم ثابت — `KpiCard` جاهز للتعديل |
| **حلقة تقدّم الحفظ** | دائرة تقدّم ٣٠ جزء (`CustomPainter`) في صفحة الطالب — أجمل من رقم |
| **خريطة المصحف** | شبكة ٦٠٤ مربع صغير ملوّنة حسب حالة الحفظ — بصرية ومُحفّزة جداً |
| **احتفال الختمة** | `confetti` + صوت + شهادة عند إتمام جزء/سورة |
| **Pull-to-refresh** | ✅ موجود في الـ Dashboard، يُعمّم |
| **Haptics** | `HapticFeedback.lightImpact()` عند التحضير والحفظ |
| **Optimistic UI** | تحديث فوري + تراجع عند الفشل — بدل `LoadingOverlay` |
| **Shimmer** | ✅ موجود، يُعمّم على كل الشاشات |
| **الأرقام العربية** | خيار في الإعدادات: `١٢٣` مقابل `123` (`NumberFormat` + locale) |
| **تكيّف الأجهزة اللوحية** | المعلّم غالباً بيستخدم تابلت في الحلقة → تخطيط عمودين (قائمة + تفاصيل) عند العرض > 900px |
| **إمكانية الوصول** | دعم تكبير الخط حتى ٢٠٠٪، تباين AA، `Semantics` على كل الأزرار |

---

# الجزء الخامس: صحة الكود والعمليات

| البند | الحالي | المقترح |
|-------|--------|---------|
| **الاختبارات** | ملف واحد (`widget_test.dart`) | Unit لـ `ProgressService` و `RecurrenceService` (منطق حرج)، Golden للويدجتات المشتركة، Integration للتدفقات الأساسية. هدف: ٦٠٪+ على `domain/` |
| **CI** | مفيش للموبايل (`e52cff0` كان للديسكتوب) | GitHub Actions: `analyze` + `test` + `build apk --debug` على كل PR |
| **تتبّع الأخطاء** | مفيش | Sentry أو Firebase Crashlytics |
| **التحليلات** | مفيش | أحداث خصوصية-أولاً: أي شاشات تُستخدم فعلاً |
| **Riverpod** | providers يدوية + codegen مثبّت وغير مستخدم | إما التحويل للـ codegen أو حذف `riverpod_generator`/`riverpod_annotation` |
| **حدود الطبقات** | بعض الشاشات بتستورد `drift` و `SchedulesCompanion` مباشرة ([schedule_create_screen.dart:1](lib/features/schedules/screens/schedule_create_screen.dart)) | الشاشات تتعامل مع الـ Repositories وكيانات الـ domain فقط |
| **المزامنة** | `PendingChanges` جدول ميّت | إما بناء مزامنة فعلية مع نظام WPF (نفس الـ schema أصلاً) أو حذف الجدول |
| **النسخ الاحتياطي** | `backup_service` موجود | نسخ سحابي اختياري (Drive/iCloud) + استعادة + تصدير Excel/PDF |
| **متجر التطبيقات** | غير مُجهّز | سياسة خصوصية، لقطات شاشة، وصف، توقيع الإصدار، ProGuard |

---

# الجزء السادس: خارطة الطريق المقترحة

### المرحلة ٠ — تثبيت الأساس (أسبوع ١–٢) 🔴 قبل أي ميزة
- [ ] نظام Migrations كامل + drift schema tests + تفعيل `PRAGMA foreign_keys`
- [ ] إصلاح حساب الأجزاء/الأهداف (interval union + intersection)
- [ ] إزالة الكتابة من `MemorizedRangeService.getByStudent`
- [ ] إصلاح N+1 في `ProgressService` بـ joins
- [ ] تحويل النصوص العربية في قاعدة البيانات لثوابت إنجليزية (+ migration)
- [ ] PBKDF2 لكلمات السر + تشفير قاعدة البيانات
- [ ] Unit tests لـ `ProgressService` (قبل التعديل — كـ characterization tests)

### المرحلة ١ — المجموعات والجدولة (أسبوع ٣–٦) 🎯 الميزة الرئيسية
- [ ] جداول `Groups` / `GroupMembers` / `GroupScheduleSlots` / `ScheduleExceptions` / `SessionAttendances`
- [ ] `RecurrenceService` + اختبارات وحدة شاملة (التوقيت الصيفي، الاستثناءات، effectiveFrom/To)
- [ ] شاشات: قائمة الحلقات، إنشاء، تفاصيل (٤ تبويبات)، محرّر الجدول الأسبوعي
- [ ] **شاشة الحلقة المباشرة** — الحضور الجماعي + التسميع في Bottom Sheet
- [ ] المواعيد المرتبطة بالصلاة (`adhan`) + إشعارات مجدولة عليها
- [ ] تقويم أسبوعي/شهري للمعلّم

### المرحلة ٢ — رفع الـ UI للمستوى الإنتاجي (أسبوع ٧–٩)
- [ ] هوية بصرية: لوحة ألوان + Dark Mode كامل + ColorScheme موحّد
- [ ] إصلاح الخطوط (أوزان ثابتة) + إضافة خط المصحف العثماني
- [ ] أيقونة تطبيق حقيقية (adaptive) + splash + اسم المنتج
- [ ] الرسوم التوضيحية (SVG) لكل الحالات الفارغة والأخطاء
- [ ] صور الطلاب + Avatars بالحروف الأولى
- [ ] إعادة هيكلة التنقل (اليوم/الحلقات/الطلاب/التقارير/المزيد)
- [ ] Hero transitions + عدّادات متحركة + حلقة تقدّم + خريطة المصحف
- [ ] تكيّف الأجهزة اللوحية (عمودين)

### المرحلة ٣ — عمق تخصّصي (أسبوع ١٠–١٢)
- [ ] نموذج المراجعة الثلاثي (سبق/حاضر/ماضي) + ترقية تلقائية بين الطبقات
- [ ] التتبّع بالصفحات/الأوجه + جدول `MushafPages`
- [ ] تصنيف أخطاء التلاوة + تقرير الأخطاء المتكررة
- [ ] معيار التقييم المركّب (٤ محاور)
- [ ] مخطّط الختمة + توقّع تاريخ الإتمام
- [ ] تقرير ولي الأمر (واتساب + PDF) + الشهادات

### المرحلة ٤ — التوسّع (ما بعد)
- تسجيل التسميع الصوتي · التحفيز والأوسمة · تعدّد المعلّمين والصلاحيات · التقويم الهجري ورمضان · التوطين (i18n) · المزامنة السحابية مع نظام WPF · الإجازة والسند

---

## خلاصة الأولويات — لو عندك وقت لثلاثة أشياء فقط

1. **المجموعات + الجدولة الأسبوعية المتكررة** — بدونها التطبيق غير قابل للاستخدام في حلقة حقيقية.
2. **نظام Migrations + إصلاح حساب التقدّم** — بدونهما أول تحديث يكسّر بيانات المستخدمين، والأرقام المعروضة خاطئة أصلاً.
3. **الهوية البصرية + خط المصحف + الأيقونة الحقيقية** — الفرق بين «مشروع تخرّج» و«منتج».
