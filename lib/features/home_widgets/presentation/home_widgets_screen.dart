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
import 'package:quran_app/l10n/l10n.dart';

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
      if (!mounted) return;
      _toast(context.l10n.homeWidgetsPinFailed);
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
      ok
          ? context.l10n.homeWidgetsSyncSuccess
          : context.l10n.homeWidgetsSyncFailed,
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
    final l10n = context.l10n;

    Widget? addButton(String provider) {
      if (!_canPin) return null;
      return IconButton(
        tooltip: l10n.homeWidgetsAddTooltip,
        onPressed: () => _pin(provider),
        icon: AppIcon(AppIcons.add, size: 18.sp, color: skin.accent),
      );
    }

    return SettingsScaffold(
      title: l10n.homeWidgetsTitle,
      children: [
        SettingsGroup(
          title: l10n.homeWidgetsHowToHeader,
          children: [
            SettingsParagraph(
              _isAndroid
                  ? l10n.homeWidgetsHowToAndroid(l10n.appName)
                  : l10n.homeWidgetsHowToIos(l10n.appName),
            ),
          ],
        ),
        SettingsGroup(
          title: l10n.homeWidgetsListHeader,
          children: [
            SettingsRow(
              icon: AppIcons.clock,
              title: l10n.homeWidgetsNextPrayerTitle,
              subtitle: _isAndroid
                  ? l10n.homeWidgetsNextPrayerSubtitleAndroid
                  : l10n.homeWidgetsNextPrayerSubtitleIos,
              trailing: addButton(HomeWidgetIds.androidNextPrayer),
            ),
            SettingsRow(
              icon: AppIcons.prayerRug,
              title: l10n.homeWidgetsTodayTimesTitle,
              subtitle: l10n.homeWidgetsTodayTimesSubtitle,
              trailing: addButton(HomeWidgetIds.androidPrayerTimes),
            ),
            SettingsRow(
              icon: AppIcons.bookOpen,
              title: l10n.homeWidgetsDailyAyahTitle,
              subtitle: l10n.homeWidgetsDailyAyahSubtitle,
              trailing: addButton(HomeWidgetIds.androidDailyAyah),
              isLast: true,
            ),
          ],
        ),
        SettingsGroup(
          title: l10n.homeWidgetsSyncHeader,
          children: [
            SettingsRow(
              icon: AppIcons.refresh,
              title: l10n.homeWidgetsSyncNow,
              subtitle: l10n.homeWidgetsSyncSubtitle(HomeWidgetIds.daysAhead),
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
            SettingsHint(l10n.homeWidgetsSyncHint(HomeWidgetIds.daysAhead)),
          ],
        ),
      ],
    );
  }
}
