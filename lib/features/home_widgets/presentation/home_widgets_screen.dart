import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/home_widgets/home_widgets_service.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/home_widgets/presentation/widgets/widget_preview_card.dart';
import 'package:quran_app/features/home_widgets/presentation/widgets/widget_previews.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/settings_skin.dart';

/// التطبيقات المصغّرة — معرض معاينات لا قائمة أسماء.
///
/// كانت صفوفًا نصّية بأيقونة ووصف. ولا أحد يعرف من «ذكر عشوائي» كيف سيبدو
/// على شاشته ولا كم خانة سيأخذ، فيضيف ثم يحذف ثم يجرّب غيره.
///
/// كل ويدجت هنا يُعرض **كما سيظهر فعلًا**: بخلفيته وحدّه الذهبي وترتيب
/// أسطره نفسه، وبجانبه حجمه بخانات الشبكة. الاختيار يقع قبل الإضافة لا بعدها.
class HomeWidgetsScreen extends StatefulWidget {
  const HomeWidgetsScreen({super.key});

  @override
  State<HomeWidgetsScreen> createState() => _HomeWidgetsScreenState();
}

class _HomeWidgetsScreenState extends State<HomeWidgetsScreen> {
  final HomeWidgetsService _service = HomeWidgetsService();

  bool _isRefreshing = false;
  bool _isPinSupported = false;

  @override
  void initState() {
    super.initState();
    _loadSupport();
  }

  Future<void> _loadSupport() async {
    final supported = await _service.isAndroidPinSupported();
    if (!mounted) return;
    setState(() => _isPinSupported = supported);
  }

  Future<void> _refreshWidgets() async {
    setState(() => _isRefreshing = true);
    try {
      await _service.refreshAll();
      await _service.startBackgroundUpdates();
      _showMessage('حُدّثت التطبيقات المصغّرة وفُعّل التحديث بالخلفية');
    } catch (_) {
      _showMessage('تعذّر تحديث التطبيقات المصغّرة الآن', isError: true);
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  Future<void> _pin(HomeWidgetType type) async {
    final didRequest = await _service.requestPinWidget(type);
    _showMessage(
      didRequest
          ? 'أُرسل طلب الإضافة — أكّده من مُشغّل الشاشة'
          : 'التثبيت المباشر غير مدعوم هنا — أضفه بالضغط المطوّل على الشاشة',
      isError: !didRequest,
    );
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    AdaptiveSnackBar.show(
      context,
      message: message,
      type: isError ? AdaptiveSnackBarType.error : AdaptiveSnackBarType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isIos = defaultTargetPlatform == TargetPlatform.iOS;

    return SettingsScaffold(
      title: 'التطبيقات المصغّرة',
      children: [
        _HowToStrip(isIos: isIos, isPinSupported: _isPinSupported),
        SettingsGroup(
          title: 'الصيانة',
          children: [
            SettingsRow(
              icon: AppIcons.refresh,
              title: 'تحديث الآن',
              subtitle: 'يجدّد المحتوى ويفعّل التحديث بالخلفية',
              isLast: true,
              onTap: _isRefreshing ? null : _refreshWidgets,
              trailing: _isRefreshing ? const _RowSpinner() : null,
            ),
          ],
        ),
        const _SectionTitle(
          title: 'الصلاة',
          caption: 'تتحدّث عند كل حدّ صلاة، لا كل نصف ساعة.',
        ),
        WidgetPreviewCard(
          title: 'الصلاة القادمة',
          description: 'اسم الصلاة ووقتها والمتبقّي إليها.',
          footprint: WidgetFootprint.tiny,
          preview: WidgetPreviews.prayer(),
          canAdd: _isPinSupported,
          onAdd: () => _pin(HomeWidgetType.prayer),
        ),
        WidgetPreviewCard(
          title: 'مواقيت اليوم',
          description: 'الستّة كاملة في صفّ واحد مع اسم مدينتك.',
          footprint: WidgetFootprint.wide2,
          preview: WidgetPreviews.prayerTimes(),
          canAdd: _isPinSupported,
          onAdd: () => _pin(HomeWidgetType.prayerTimes),
        ),
        WidgetPreviewCard(
          title: 'صلوات اليوم',
          description: 'خمس علامات تمتلئ مع ما صلّيت، وتذكيرٌ بما بقي.',
          footprint: WidgetFootprint.wide2,
          preview: WidgetPreviews.tracker(),
          canAdd: _isPinSupported,
          onAdd: () => _pin(HomeWidgetType.tracker),
        ),
        WidgetPreviewCard(
          title: 'القبلة',
          description: 'جهة القبلة بالدرجات والمسافة إلى المسجد الحرام.',
          footprint: WidgetFootprint.small2,
          preview: WidgetPreviews.qibla(),
          canAdd: _isPinSupported,
          onAdd: () => _pin(HomeWidgetType.qibla),
        ),
        const _SectionTitle(
          title: 'الذكر والتلاوة',
          caption: 'محتوى متجدّد من مكتبة التطبيق نفسه.',
        ),
        WidgetPreviewCard(
          title: 'المسبحة',
          description: 'اضغط الرقم فيزيد — دون فتح التطبيق أصلًا.',
          footprint: WidgetFootprint.wide2,
          badge: 'تفاعلي',
          preview: WidgetPreviews.tasbih(),
          canAdd: _isPinSupported,
          onAdd: () => _pin(HomeWidgetType.tasbih),
        ),
        WidgetPreviewCard(
          title: 'ذكر اليوم',
          description: 'ذكر متجدّد من مصادر الأذكار الموثّقة.',
          footprint: WidgetFootprint.wide1,
          preview: WidgetPreviews.dhikr(),
          canAdd: _isPinSupported,
          onAdd: () => _pin(HomeWidgetType.dhikr),
        ),
        WidgetPreviewCard(
          title: 'آية عشوائية',
          description: 'آية من المصحف مع موضعها.',
          footprint: WidgetFootprint.wide1,
          preview: WidgetPreviews.ayah(),
          canAdd: _isPinSupported,
          onAdd: () => _pin(HomeWidgetType.ayah),
        ),
        WidgetPreviewCard(
          title: 'متابعة القراءة',
          description: 'آخر سورة وصفحة وقفت عندها — واللمس يفتحها.',
          footprint: WidgetFootprint.small1,
          preview: WidgetPreviews.reading(),
          canAdd: _isPinSupported,
          onAdd: () => _pin(HomeWidgetType.reading),
        ),
        WidgetPreviewCard(
          title: 'ورد اليوم',
          description: 'نسبة ما أنجزته من وردك اليومي.',
          footprint: WidgetFootprint.tiny,
          preview: WidgetPreviews.wird(),
          canAdd: _isPinSupported,
          onAdd: () => _pin(HomeWidgetType.wird),
        ),
        const _SectionTitle(
          title: 'التاريخ والوصول',
          caption: 'اختصارات لا تحتاج فتح التطبيق للوصول إليها.',
        ),
        WidgetPreviewCard(
          title: 'التاريخ الهجري',
          description: 'اليوم الهجري ويومه الميلادي واسم اليوم.',
          footprint: WidgetFootprint.small1,
          preview: WidgetPreviews.hijri(),
          canAdd: _isPinSupported,
          onAdd: () => _pin(HomeWidgetType.hijri),
        ),
        WidgetPreviewCard(
          title: 'اختصارات سريعة',
          description: 'أربعة أبواب، كلٌّ يفتح صفحته مباشرة.',
          footprint: WidgetFootprint.wide1,
          preview: WidgetPreviews.shortcuts(),
          canAdd: _isPinSupported,
          onAdd: () => _pin(HomeWidgetType.shortcuts),
        ),
        const _IosNotice(),
      ],
    );
  }
}

/// سطر واحد يشرح كيف تُضاف الويدجتات على هذه المنصّة.
class _HowToStrip extends StatelessWidget {
  const _HowToStrip({required this.isIos, required this.isPinSupported});

  final bool isIos;
  final bool isPinSupported;

  String get _message {
    if (isIos) {
      return 'اضغط مطوّلًا على الشاشة الرئيسية ثم «+» واختر طمأنينة.';
    }
    if (isPinSupported) {
      return 'اضغط «إضافة» تحت أي ويدجت، أو اضغط مطوّلًا على شاشتك الرئيسية.';
    }
    return 'اضغط مطوّلًا على شاشتك الرئيسية ثم «الأدوات» واختر طمأنينة.';
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 14.h),
      child: Row(
        children: [
          AppIcon(AppIcons.widgets, color: skin.accent, size: 15.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              _message,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.caption});

  final String title;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(height: 18.h, thickness: 1, color: skin.hairline),
          Text(
            title,
            style: TextStyle(
              color: skin.ink,
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            caption,
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.65),
              fontSize: 9.sp,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// حالة iOS.
///
/// تصاميم WidgetKit مكتوبة كاملةً في `ios/TamaneenaWidgets/`، لكن إضافة
/// الويدجت غير مضافة إلى مشروع Xcode — فلا تُبنى ولا تُشحن. هذا مقصود:
/// المطلوب كان تصميمها وإبقاؤها مطفأة.
class _IosNotice extends StatelessWidget {
  const _IosNotice();

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(height: 18.h, thickness: 1, color: skin.hairline),
          Row(
            children: [
              AppIcon(
                AppIcons.phone,
                color: skin.inkSoft.withValues(alpha: 0.5),
                size: 14.sp,
              ),
              SizedBox(width: 7.w),
              Text(
                'iOS — مصمَّمة وغير مفعّلة',
                style: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.8),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'تصاميم WidgetKit جاهزة في المشروع (الشاشة الرئيسية وشاشة القفل)، '
            'ولم تُضف إضافتها إلى Xcode بعد، فلا تظهر على الأجهزة.',
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.6),
              fontSize: 9.sp,
              fontWeight: FontWeight.w500,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _RowSpinner extends StatelessWidget {
  const _RowSpinner();

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return SizedBox(
      width: 15.w,
      height: 15.w,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation(skin.accent),
      ),
    );
  }
}
