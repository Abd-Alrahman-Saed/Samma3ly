# نظام التصميم والحركة — `quran_mobile`

**ملحق لـ** [PRODUCT_IMPROVEMENT_REPORT.md](PRODUCT_IMPROVEMENT_REPORT.md)
مبني على مخرجات `ui-ux-pro-max` + مراجعة الكود الفعلي + تحليل تطبيق منافس.

---

## 0. تنبيه أول: Framer Motion غير متاح هنا

`framer-motion` مكتبة **React/JavaScript** — بتشتغل على DOM. مشروعك **Flutter**، ومفيش أي واجهة ويب فيه:

```
D:/OpenCode/QURAN_SYSTEM/
├── src/                    ← WPF/.NET  (QM.Application, QM.Core, QM.Infrastructure, QM.UI, QM.Tests)
├── quran_mobile/           ← Flutter    (المشروع الحالي)
└── Quran Revision mentor/  ← لقطات شاشة مرجعية
```
> `find … -name package.json` → **صفر نتائج**. لا يوجد React في المشروع.

**لكن الخبر الحلو:** المكتبة اللي بتلعب نفس الدور بالظبط في Flutter — **`flutter_animate`** — **مثبّتة عندك بالفعل** (`^4.5.0` في `pubspec.yaml`) ومستخدمة بشكل محدود جداً. نفس الفلسفة: API تصريحي متسلسل بدل `AnimationController` يدوي.

### جدول التحويل من Framer Motion إلى Flutter

| Framer Motion | مكافئه في Flutter | ملاحظة |
|---|---|---|
| `<motion.div animate={{opacity:1}}>` | `.animate().fadeIn()` | `flutter_animate` — مثبّت ✅ |
| تسلسل `transition={{delay}}` | `.then(delay: …)` | تسلسل مدمج |
| `variants` (حالات مسمّاة) | `class MotionTokens` (أسفل) | ثوابت مركزية |
| `<AnimatePresence>` (حركة الخروج) | `AnimatedSwitcher` / `PageTransitionSwitcher` | حزمة `animations` من فريق Flutter |
| `layoutId` (عنصر مشترك) | `Hero(tag: …)` | مدمج في Flutter |
| `layout` (حركة تلقائية للتخطيط) | `AnimatedContainer` / `AnimatedPositioned` | مدمج |
| `type:"spring", stiffness, damping` | `SpringDescription` + `SpringSimulation` | أو `Curves.easeOutBack` كتبسيط |
| `useReducedMotion()` | `MediaQuery.of(context).disableAnimations` | ⚠️ **مهم — مفقود حالياً** |
| `whileTap={{scale:0.97}}` | `InkWell` + `AnimatedScale` | + `HapticFeedback` |
| `useScroll` / parallax | `SliverAppBar` + `FlexibleSpaceBar` | مدمج |
| Stagger للقوائم | `flutter_staggered_animations` | **مثبّت بالفعل** ✅ |

**الخلاصة:** مش محتاج تضيف أي حزمة حركة جديدة. الحزم موجودة، ناقصها **نظام** يحكمها.

---

## 1. نظام الحركة (Motion System)

### 1.1 القواعد الحاكمة

مخرجات `ui-ux-pro-max` (نطاق `ux`، فئة Animation) — مرتّبة بالخطورة:

| القاعدة | الخطورة | الحالة عندك |
|---|---|---|
| **احترام تقليل الحركة** (`prefers-reduced-motion`) | 🔴 High | ❌ غير مطبّق إطلاقاً |
| **حركة مفرطة** — عنصران متحركان كحد أقصى لكل شاشة | 🔴 High | ⚠️ منخفض الاستخدام حالياً (فرصة، مش مشكلة) |
| **حالات التحميل** — skeletons | 🔴 High | ✅ مطبّق (`skeletons.dart` + `shimmer`) |
| **الحركة المستمرة** — للتحميل فقط | 🟠 Medium | ✅ سليم |
| **دوال التخفيف** — `easeOut` للدخول، `easeIn` للخروج | 🟡 Low | ⚠️ افتراضي |
| **المدة** — ١٥٠–٣٠٠ms للتفاعلات الدقيقة | 🟡 Medium | ⚠️ غير موحّد |

> 🔴 **الأهم:** احترام تقليل الحركة. مستخدم عنده حساسية دوار (motion sickness) مفعّل «تقليل الحركة» في إعدادات الهاتف — لو تجاهلته، التطبيق بيسبّبله غثيان حرفياً. ودي كمان **متطلب من Google Play** لتقييم إمكانية الوصول.

### 1.2 ملف الرموز — `lib/core/theme/app_motion.dart`

```dart
import 'package:flutter/material.dart';

/// رموز الحركة المركزية — مكافئ `variants` في Framer Motion.
/// ممنوع كتابة Duration أو Curve حرفية في الويدجتات.
class AppMotion {
  const AppMotion._();

  // ── المُدد ──────────────────────────────────────────────
  static const instant = Duration(milliseconds: 100);  // ردّ فعل اللمس
  static const fast    = Duration(milliseconds: 180);  // تبديل الحالة
  static const base    = Duration(milliseconds: 250);  // الافتراضي
  static const slow    = Duration(milliseconds: 350);  // انتقال الشاشات
  static const deliberate = Duration(milliseconds: 600); // الاحتفالات

  // ── المنحنيات ───────────────────────────────────────────
  static const enter = Curves.easeOutCubic;   // دخول
  static const exit  = Curves.easeInCubic;    // خروج
  static const move  = Curves.easeInOutCubic; // تحرّك
  static const pop   = Curves.easeOutBack;    // نابض (للإنجازات فقط)

  // ── الإزاحات ────────────────────────────────────────────
  static const slideIn = Offset(0, 0.06);
  static const stagger = Duration(milliseconds: 45);
}

/// مكافئ `useReducedMotion()` من Framer Motion.
extension MotionQuery on BuildContext {
  bool get reduceMotion => MediaQuery.maybeOf(this)?.disableAnimations ?? false;

  /// يُرجع صفر لو المستخدم طالب تقليل الحركة.
  Duration motion(Duration d) => reduceMotion ? Duration.zero : d;
}
```

### 1.3 غلاف موحّد — `lib/core/widgets/app_motion_wrappers.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quran_mobile/core/theme/app_motion.dart';

/// دخول موحّد للعناصر — مكافئ <motion.div initial animate>.
/// يحترم تقليل الحركة تلقائياً.
class FadeSlideIn extends StatelessWidget {
  final Widget child;
  final int index;   // للتتابع داخل القوائم

  const FadeSlideIn({super.key, required this.child, this.index = 0});

  @override
  Widget build(BuildContext context) {
    if (context.reduceMotion) return child;   // ← الحارس الإلزامي
    return child
        .animate(delay: AppMotion.stagger * index)
        .fadeIn(duration: AppMotion.base, curve: AppMotion.enter)
        .slideY(begin: AppMotion.slideIn.dy, curve: AppMotion.enter);
  }
}

/// ردّ فعل اللمس — مكافئ whileTap={{scale:0.97}}.
class PressableScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const PressableScale({super.key, required this.child, this.onTap});

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:   (_) => setState(() => _down = true),
      onTapUp:     (_) => setState(() => _down = false),
      onTapCancel: ()  => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down && !context.reduceMotion ? 0.97 : 1.0,
        duration: AppMotion.instant,
        curve: AppMotion.enter,
        child: widget.child,
      ),
    );
  }
}
```

### 1.4 أين تُستخدم الحركة — وأين لا تُستخدم

**نعم ✅**

| الموضع | الحركة | السبب |
|---|---|---|
| قوائم الطلاب/الحلقات | Stagger fade+slide (٤٥ms تتابع) | يوجّه العين لترتيب القراءة |
| القائمة ← التفاصيل | `Hero` على الصورة/الحرف | استمرارية مكانية |
| أرقام الـ KPI | `TweenAnimationBuilder` عدّاد | الرقم المتحرك يُقرأ كـ«حيّ» |
| حلقة تقدّم الحفظ | رسم تدريجي عند الظهور | إحساس بالإنجاز |
| تحضير طالب | `AnimatedScale` + `HapticFeedback.selectionClick()` | تأكيد فوري |
| إتمام سورة/جزء/ختمة | `pop` + confetti + صوت | لحظة تستحق الاحتفال |
| تبديل الشاشات | `SharedAxisTransition` (حزمة `animations`) | اتجاه = تسلسل هرمي |

**لا ❌**

- حركة على أكثر من عنصرين لكل شاشة (قاعدة «الحركة المفرطة» — خطورة High).
- Parallax أو scroll-jacking (يسبّب غثيان — خطورة High).
- حركات ديكورية مستمرة (`animate-bounce` على الأيقونات).
- أي حركة تزيد عن ٣٥٠ms في مسار متكرر — **شاشة الحلقة المباشرة تحديداً لازم تبقى فورية**؛ المعلّم بيحضّر ٢٠ طالب ورا بعض، أي تأخير ×٢٠ = إحباط.

---

## 2. اللوحة اللونية

### 2.1 ما اقترحه المحرّك مقابل التوصية النهائية

| المصدر | Primary | ملاحظة |
|---|---|---|
| `ui-ux-pro-max` — «Online Course/E-learning» | `#0D9488` تركوازي + `#F97316` برتقالي | «تقدّم تركوازي + إنجاز برتقالي» |
| `ui-ux-pro-max` — «Language Learning» | `#4F46E5` نيلي + `#22C55E` | «تعلّم نيلي + تقدّم أخضر» |
| الحالي في المشروع | `#2563EB` أزرق | لون Tailwind الافتراضي، بلا هوية |
| **✅ التوصية** | `#1B5E4A` أخضر زيتوني + `#C9A227` ذهبي | أسفل |

**لماذا خالفتُ المحرّك:** قاعدة بيانات المحرّك مبنية على منتجات غربية عامة، وما فيهاش فئة «محتوى إسلامي». التركوازي والنيلي بيدّوا إحساس «تطبيق لغات» (Duolingo-esque) — ده مناسب لطفل بيتعلّم إسبانية، مش لمعلّم في حلقة مسجد. **الأخضر والذهبي** هما لغة المصاحف والمساجد البصرية، وبيدّوا وقاراً فورياً عند الجمهور المستهدف.

**اللي أخدته من المحرّك:** بنية «أساسي + لون إنجاز منفصل». الذهبي عندي بيلعب دور البرتقالي عنده — لون مخصص للإنجازات والشهادات والأوسمة، منفصل عن اللون الأساسي.

### 2.2 الرموز النهائية

```dart
class AppPalette {
  const AppPalette._();

  static const primary      = Color(0xFF1B5E4A);   // أخضر زيتوني
  static const primaryDark  = Color(0xFF0F3D30);
  static const accent       = Color(0xFFC9A227);   // ذهبي — الإنجازات فقط

  // دلالية — تُستخدم مع أيقونة دائماً، لا لوناً وحده
  static const present      = Color(0xFF16A34A);   // حاضر / متقن
  static const late         = Color(0xFFD97706);   // متأخر / يحتاج مراجعة
  static const absent       = Color(0xFFDC2626);   // غائب / لحن جليّ
  static const excused      = Color(0xFF64748B);   // مستأذن

  static const surfaceCream = Color(0xFFFAF8F3);   // ورق المصحف
}
```

> ⚠️ **قاعدة إمكانية وصول (خطورة CRITICAL):** «اللون ليس المؤشّر الوحيد». حالة الحضور لازم تحمل **أيقونة + نص** مع اللون — ٨٪ من الذكور عندهم عمى ألوان أحمر/أخضر، وشاشة الحضور كلها أحمر/أخضر.

### 2.3 الوضع الداكن — أخالف المحرّك مرة تانية

المحرّك أوصى بنمط Claymorphism وضمن الـ anti-patterns بتاعه: **"Dark modes"** (تجنّبها).

**أرفض التوصية دي**، لسببين:
1. تطبيق بيُستخدم **بعد المغرب والعشاء في المسجد** — إضاءة منخفضة. الوضع الفاتح في الظلام مؤذٍ للعين.
2. التطبيق المنافس ([لقطات الشاشة](#5-تحليل-المنافس)) داكن بالكامل — التوقّع البصري في هذه الفئة موجود بالفعل.

الوضع الداكن **إلزامي** (مع `themeMode` تلقائي). وكمان Claymorphism (٣D ناعم، حواف سميكة، ألوان لعب) مناسب لتطبيقات الأطفال — **مش** لأداة يستخدمها معلّم أمام إدارة المسجد. النمط الصحيح هنا: **Minimalism هادئ + لمسات ذهبية للإنجاز**.

---

## 3. الطباعة (Typography)

### 3.1 توصية المحرّك — مقبولة بتعديل

المحرّك رجّع «Arabic Elegant»: **Noto Naskh Arabic** (عناوين) + **Noto Sans Arabic** (متن). توصية صحيحة ومناسبة للـ RTL.

**التعديل:** `Cairo` عندك بالفعل وهو خط ممتاز للواجهات (هندسي، واضح في الأحجام الصغيرة). فبدل ما أستبدله، السلّم النهائي:

| الدور | الخط | الاستخدام |
|---|---|---|
| **الواجهة والمتن** | `Cairo` (موجود ✅) | كل نصوص التطبيق |
| **العناوين الكبيرة** | `Noto Naskh Arabic` | عناوين الشاشات، الشهادات — يدّي طابعاً تقليدياً |
| **الآيات** | `KFGQPC Uthmanic Hafs` | 🔴 **إلزامي** — أي نص قرآني |

### 3.2 إصلاح إعداد الخط — تذكير 🔴

كما ورد في التقرير الأصلي، `pubspec.yaml` بيسجّل **نفس ملف الـ variable font لأربعة أوزان** → Flutter بيعمل تعريضاً صناعياً والنص العربي بيطلع مشوّه. لازم ملفات ثابتة منفصلة:

```yaml
fonts:
  - family: Cairo
    fonts:
      - { asset: assets/fonts/Cairo-Regular.ttf,  weight: 400 }
      - { asset: assets/fonts/Cairo-Medium.ttf,   weight: 500 }
      - { asset: assets/fonts/Cairo-SemiBold.ttf, weight: 600 }
      - { asset: assets/fonts/Cairo-Bold.ttf,     weight: 700 }
  - family: NotoNaskhArabic
    fonts:
      - { asset: assets/fonts/NotoNaskhArabic-Regular.ttf, weight: 400 }
      - { asset: assets/fonts/NotoNaskhArabic-Bold.ttf,    weight: 700 }
  - family: QuranHafs
    fonts:
      - { asset: assets/fonts/UthmanicHafs.ttf }
```

### 3.3 قواعد النص

- **الحد الأدنى للمتن: 16sp** (قاعدة `readable-font-size`). حالياً `AppTextStyles.body` = **14** و `small`/`muted` = **12** — أصغر من الموصى به، والعربية بتعاني أكتر من اللاتينية في الأحجام الصغيرة بسبب التشكيل والنقاط.
- **`height: 1.6–1.75`** للمتن العربي (أعلى من اللاتيني بسبب علامات التشكيل).
- **الآيات:** 22sp، `height: 2.0`، `QuranHafs`.
- **الأرقام:** خيار في الإعدادات بين `١٢٣` و `123`. لاحظ في لقطات المنافس إن الأرقام لاتينية داخل نص عربي وبتكسر اتجاه القراءة — تجنّب ده.

---

## 4. أهداف اللمس — تصحيح على تصميم شاشة الحلقة

قاعدة `touch-target-size` (خطورة **CRITICAL**): الحد الأدنى **44×44** نقطة.

ده بيمسّ مباشرةً شاشة الحلقة المباشرة اللي اقترحتها في التقرير الأصلي — أربعة أزرار حضور `[✓][✗][⏰][📄]` في صف واحد جنب اسم الطالب **مش هيعدّوا** على شاشة 375px:

```
375 − 32 (هوامش) − 120 (اسم) = 223px ÷ 4 = 55px  ← على الحافة تماماً
```
مع أي اسم أطول أو خط أكبر، المقاس بيقلّ عن ٤٤ → أخطاء تحضير. والمعلّم بيدوس بسرعة وبإبهام واحد.

**التصميم المعدّل:**
```
┌────────────────────────────────────────┐
│ 👤 أحمد محمد                    ✓ حاضر │  ← الحالة الحالية كـ Chip
│    البقرة ١–٢٠ · آخر تسميع ٩٢٪          │
└────────────────────────────────────────┘
   ← سحب لليمين = حاضر (أخضر)
   ← سحب لليسار = غائب (أحمر)
   ← ضغطة على الـ Chip = قائمة (متأخر/مستأذن)
```
- **السحب (Dismissible)** للحالتين الأكثر تكراراً — هدف اللمس بقى **الصف كله**، مش زر ٥٥px.
- الحالتان النادرتان (متأخر/مستأذن) وراء ضغطة إضافية — ده صحيح، التردّد هو اللي بيحدد التكلفة.
- `HapticFeedback.selectionClick()` مع كل تغيير.
- «تحضير الكل» يفضل موجود فوق.

---

## 5. تحليل المنافس

اللقطات في `Quran Revision mentor/` هي تطبيق **«رفيق حفظ القرآن»**. ما تعلّمناه منها:

### ✅ يؤكّد توصياتنا
- **التتبّع بالصفحات:** المنافس بيعرض «الجزء ٢٧ : الصفحات [٥٢٢، ٥٢٣… ٥٢٩]» — **بالصفحات لا بالآيات**. ده يثبّت التوصية 3.2 في التقرير الأصلي: نموذجك القائم على `fromAyah`/`toAyah` مخالف لعُرف المجال.
- **حالة ثلاثية للحفظ:** محفوظ / يحتاج مراجعة / غير محفوظ — نفس تصميم `MemorizedRanges` عندك. ✅
- **جدول مراجعة بتواريخ مستقبلية** ملوّنة حسب الاستحقاق. ✅

### ❌ فجوات نستغلها
| ضعف المنافس | فرصتنا |
|---|---|
| **فردي بحت** — لا مجموعات ولا معلّم ولا حِلَق | ميزتك الأساسية بالكامل |
| أحمر/أخضر مشبع على أسود — تباين قاسٍ ومُجهد | لوحة هادئة + وضع داكن مصمَّم |
| جدول نصّي كثيف، صفوف غير متساوية | كروت + تسلسل بصري |
| أرقام لاتينية داخل نص عربي (`[522,523]`) تكسر الاتجاه | التزام RTL كامل + خيار أرقام عربية |
| مخطط دائري بثلاث شرائح فقط | **خريطة المصحف ٦٠٤ مربع** — أوقع بصرياً بكثير |
| صفر حركة | نظام حركة منضبط |

> **الخلاصة الاستراتيجية:** المنافس بيحلّ مشكلة «الحافظ الفرد». مفيش حد بيحلّ مشكلة **«المعلّم ومعاه ٣ حلقات و٦٠ طالب»** — دي مساحتك.

---

## 6. ترجمة قائمة المحرّك من الويب إلى Flutter

قائمة التسليم في المهارة مكتوبة للويب/Tailwind. الترجمة الصحيحة:

| بند المحرّك (ويب) | المكافئ في Flutter | الحالة |
|---|---|---|
| `cursor-pointer` على العناصر القابلة للنقر | `InkWell` + تأثير التموّج | غير منطبق (لمس) |
| حالات hover | حالات الضغط + `WidgetStateProperty` | يُطبَّق |
| `prefers-reduced-motion` | `MediaQuery.disableAnimations` | ❌ **مفقود — يُطبَّق** |
| `alt-text` للصور | `Semantics(label:)` | ⚠️ جزئي |
| `aria-label` لأزرار الأيقونات | `IconButton(tooltip:)` + `Semantics` | ⚠️ جزئي |
| ترتيب التنقل بلوحة المفاتيح | `FocusTraversalOrder` | منخفض الأولوية (لمس) |
| متجاوب 375/768/1024/1440 | `LayoutBuilder` + نقاط توقّف | ❌ مفقود (مهم للتابلت) |
| لا انزلاق أفقي | `SingleChildScrollView` بحذر | يُراجع |
| تباين ٤.٥:١ | `ColorScheme` مُتحقَّق منه | يُراجع في الوضعين |
| **لا إيموجي كأيقونات** | أيقونات SVG (`flutter_svg`) | ⚠️ **تصحيح لتقريري السابق** |

> ✏️ **تصحيح على تقريري الأول:** اقترحت أوسمة بإيموجي (🏅 🔥 ✨). ده يخالف قاعدة `no-emoji-icons` — الإيموجي بيتغيّر شكله بين أندرويد وiOS ونسخ النظام، وبيطلع غير متّسق. الأوسمة لازم تبقى **SVG مخصصة** بهوية التطبيق.

---

## 7. خطة التنفيذ (تندمج مع المرحلة ٢ في التقرير الأصلي)

**الأسبوع ١ — الأساس**
- [ ] `app_motion.dart` + `MotionQuery` extension (احترام تقليل الحركة)
- [ ] `AppPalette` + `ColorScheme.fromSeed` + `darkTheme` + `themeMode`
- [ ] تنظيف `AppColors` الحرفية من الويدجتات (`fillColor: Colors.white` أولاً)
- [ ] إصلاح أوزان خط Cairo + إضافة `QuranHafs` و `NotoNaskhArabic`
- [ ] رفع أحجام المتن إلى ١٦sp وضبط `height`

**الأسبوع ٢ — الحركة والأصول**
- [ ] `FadeSlideIn` + `PressableScale` معمّمة على القوائم
- [ ] `Hero` من قائمة الطلاب للتفاصيل
- [ ] عدّادات KPI متحركة + حلقة تقدّم الحفظ
- [ ] أيقونة تطبيق حقيقية (`flutter_launcher_icons`) + splash + اسم المنتج
- [ ] رسوم SVG للحالات الفارغة

**الأسبوع ٣ — التخطيط وإمكانية الوصول**
- [ ] إعادة هيكلة التنقل (اليوم/الحلقات/الطلاب/التقارير/المزيد)
- [ ] تخطيط عمودين للتابلت (>900px)
- [ ] شاشة الحلقة المباشرة بالسحب (Dismissible) لا الأزرار الصغيرة
- [ ] تدقيق التباين في الوضعين + `Semantics` على كل زر أيقونة
- [ ] اختبار على تكبير خط ٢٠٠٪
