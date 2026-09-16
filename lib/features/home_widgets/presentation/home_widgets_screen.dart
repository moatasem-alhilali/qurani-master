import 'dart:async';

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_widget/home_widget.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/home_widgets/data/home_widget_ids.dart';
import 'package:quran_app/features/home_widgets/data/home_widget_sync.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/settings_skin.dart';

/// شاشة ودجات الشاشة الرئيسية: ما المتاح، وكيف يُضاف، والمزامنة اليدوية.
class HomeWidgetsScreen extends StatefulWidget {
  const HomeWidgetsScreen({super.key});

  @override
  State<HomeWidgetsScreen> createState() => _HomeWidgetsScreenState();
}

class _HomeWidgetsScreenState extends State<HomeWidgetsScreen> {
  bool _canPin = false;
  bool _syncing = false;

  bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;

  @override
  void initState() {
    super.initState();
    if (_isAndroid) {
      unawaited(_checkPinSupport());
    }
  }

  Future<void> _checkPinSupport() async {
    try {
      final supported = await HomeWidget.isRequestPinWidgetSupported() ?? false;
      if (mounted) setState(() => _canPin = supported);
    } catch (_) {}
  }

  Future<void> _pin(String provider) async {
    unawaited(HapticFeedback.selectionClick());
    // البيانات أوّلًا: الودجت المضافة للتوّ ترسم فورًا بمحتوى حقيقي.
    await HomeWidgetSync.syncNow(reason: 'pin');
    try {
      await HomeWidget.requestPinWidget(qualifiedAndroidName: provider);
    } catch (_) {
      _toast('تعذّر فتح نافذة الإضافة. أضفها يدويًا من الشاشة الرئيسية.');
    }
  }

  Future<void> _syncNow() async {
    if (_syncing) return;
    unawaited(HapticFeedback.selectionClick());
    setState(() => _syncing = true);
    final ok = await HomeWidgetSync.syncNow(reason: 'manual');
    if (!mounted) return;
    setState(() => _syncing = false);
    _toast(
      ok ? 'تم تحديث الودجات' : 'تعذّر التحديث. تأكّد من تحديد موقعك.',
      success: ok,
    );
  }

  void _toast(String message, {bool success = false}) {
    if (!mounted) return;
    AdaptiveSnackBar.show(
      context,
      message: message,
      type: success ? AdaptiveSnackBarType.success : AdaptiveSnackBarType.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    Widget? addButton(String provider) {
      if (!_canPin) return null;
      return IconButton(
        tooltip: 'إضافة إلى الشاشة الرئيسية',
        onPressed: () => _pin(provider),
        icon: AppIcon(AppIcons.add, size: 18.sp, color: skin.accent),
      );
    }

    return SettingsScaffold(
      title: 'ودجات الشاشة الرئيسية',
      children: [
        SettingsGroup(
          title: 'طريقة الإضافة',
          children: [
            SettingsParagraph(
              _isAndroid
                  ? 'اضغط زر الإضافة بجانب الودجت، أو اضغط مطوّلًا على مساحة '
                      'فارغة في الشاشة الرئيسية ثم «التطبيقات المصغّرة» '
                      'وابحث عن «طمأنينة».'
                  : 'اضغط مطوّلًا على مساحة فارغة في الشاشة الرئيسية، ثم زر «+» '
                      'أعلى الشاشة، وابحث عن «طمأنينة». ودجت الصلاة القادمة '
                      'متاحة أيضًا لشاشة القفل.',
            ),
          ],
        ),
        SettingsGroup(
          title: 'الودجات',
          children: [
            SettingsRow(
              icon: AppIcons.clock,
              title: 'الصلاة القادمة',
              subtitle: _isAndroid
                  ? 'اسم الصلاة ووقتها مع عدّ تنازلي حيّ'
                  : 'صغيرة · وشاشة القفل بثلاثة أشكال',
              trailing: addButton(HomeWidgetIds.androidNextPrayer),
            ),
            SettingsRow(
              icon: AppIcons.prayerRug,
              title: 'مواقيت اليوم',
              subtitle: 'الصلوات الستّ مع التاريخ الهجري والمدينة',
              trailing: addButton(HomeWidgetIds.androidPrayerTimes),
            ),
            SettingsRow(
              icon: AppIcons.bookOpen,
              title: 'آية اليوم',
              subtitle: 'آية قصيرة تتجدّد كل يوم',
              trailing: addButton(HomeWidgetIds.androidDailyAyah),
              isLast: true,
            ),
          ],
        ),
        SettingsGroup(
          title: 'المزامنة',
          children: [
            SettingsRow(
              icon: AppIcons.refresh,
              title: 'تحديث الودجات الآن',
              subtitle: 'يحسب مواقيت ${HomeWidgetIds.daysAhead} يومًا '
                  'بموقعك وإعداداتك الحالية',
              onTap: _syncing ? null : _syncNow,
              trailing: _syncing
                  ? SizedBox.square(
                      dimension: 16.sp,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: skin.accent,
                      ),
                    )
                  : null,
              isLast: true,
            ),
            const SettingsHint(
              'الودجات تعمل ${HomeWidgetIds.daysAhead} يومًا دون فتح التطبيق، '
              'وتتجدّد تلقائيًا في الخلفية. تتحدّث وحدها عند تغيير موقعك أو '
              'طريقة الحساب.',
            ),
          ],
        ),
      ],
    );
  }
}
