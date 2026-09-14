import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/home_widgets/home_widgets_service.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/settings_skin.dart';

/// التطبيقات المصغرة: شرح مرتفع واحد، ثم صفوف الويدجتات بأزرار التثبيت.
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
      _showMessage('تم تحديث التطبيقات المصغرة وتفعيل التحديث بالخلفية');
    } catch (_) {
      _showMessage('تعذر تحديث التطبيقات المصغرة الآن', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  Future<void> _pin(HomeWidgetType type) async {
    final didRequest = await _service.requestPinWidget(type);
    _showMessage(
      didRequest
          ? 'تم إرسال طلب إضافة التطبيق المصغر'
          : 'التثبيت المباشر غير مدعوم على هذا الجهاز',
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
      title: 'التطبيقات المصغرة',
      children: [
        _WidgetsIntro(isIos: isIos),
        SettingsGroup(
          title: 'الصيانة',
          children: [
            SettingsRow(
              icon: AppIcons.refresh,
              title: 'تحديث التطبيقات المصغرة',
              subtitle: 'تحديث المحتوى وتفعيل التحديث بالخلفية',
              isLast: true,
              onTap: _isRefreshing ? null : _refreshWidgets,
              trailing: _isRefreshing ? const _RowSpinner() : null,
            ),
          ],
        ),
        SettingsGroup(
          title: 'ويدجتات الشاشة الرئيسية',
          children: [
            _WidgetRow(
              title: 'الصلاة القادمة',
              subtitle: 'وقت الصلاة القادمة والوقت المتبقي',
              icon: AppIcons.clock,
              canPin: _isPinSupported,
              onPin: () => _pin(HomeWidgetType.prayer),
            ),
            _WidgetRow(
              title: 'مواقيت الصلاة',
              subtitle: 'الفجر، الشروق، الظهر، العصر، المغرب والعشاء',
              icon: AppIcons.calendar,
              canPin: _isPinSupported,
              onPin: () => _pin(HomeWidgetType.prayerTimes),
            ),
            _WidgetRow(
              title: 'ذكر عشوائي',
              subtitle: 'ذكر متجدد من مصادر الأذكار',
              icon: AppIcons.tasbih,
              canPin: _isPinSupported,
              onPin: () => _pin(HomeWidgetType.dhikr),
            ),
            _WidgetRow(
              title: 'آية عشوائية',
              subtitle: 'آية متجددة من مكتبة القرآن داخل التطبيق',
              icon: AppIcons.quran,
              canPin: _isPinSupported,
              onPin: () => _pin(HomeWidgetType.ayah),
            ),
            _WidgetRow(
              title: 'ورد اليوم',
              subtitle: 'متابعة مختصرة للتقدم اليومي',
              icon: AppIcons.check,
              canPin: _isPinSupported,
              onPin: () => _pin(HomeWidgetType.wird),
              isLast: true,
            ),
          ],
        ),
        if (isIos)
          const SettingsGroup(
            title: 'شاشة القفل',
            children: [
              SettingsParagraph(
                'أضفت ويدجت صلاة القفل وذكر القفل بصيغ iOS Lock Screen: '
                'Inline وRectangular وCircular.',
              ),
            ],
          ),
      ],
    );
  }
}

/// العنصر المرتفع الوحيد: يشرح كيف تُضاف الويدجتات على هذه المنصة.
class _WidgetsIntro extends StatelessWidget {
  const _WidgetsIntro({required this.isIos});

  final bool isIos;

  @override
  Widget build(BuildContext context) {
    return SettingsRaisedRow(
      icon: AppIcons.widgets,
      title: isIos ? 'ويدجتات iPhone جاهزة' : 'ويدجتات Android جاهزة',
      subtitle: isIos
          ? 'أضفها من شاشة التطبيقات المصغرة، وتشمل ويدجتات شاشة القفل '
              'للصلاة والذكر.'
          : 'يمكنك إضافتها يدوياً، أو تثبيتها مباشرة من زر التثبيت إذا كان '
              'المشغل يدعم ذلك.',
    );
  }
}

/// صفّ ويدجت واحد مع زر تثبيته.
class _WidgetRow extends StatelessWidget {
  const _WidgetRow({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.canPin,
    required this.onPin,
    this.isLast = false,
  });

  final String title;
  final String subtitle;
  final HugeIconData icon;
  final bool canPin;
  final VoidCallback onPin;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return SettingsRow(
      icon: icon,
      title: title,
      subtitle: subtitle,
      isLast: isLast,
      trailing: SettingsIconButton(
        icon: AppIcons.bookmarkAdd,
        tooltip: 'تثبيت',
        onTap: canPin ? onPin : null,
      ),
    );
  }
}

class _RowSpinner extends StatelessWidget {
  const _RowSpinner();

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return SizedBox.square(
      dimension: 15.w,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(skin.accent),
      ),
    );
  }
}
