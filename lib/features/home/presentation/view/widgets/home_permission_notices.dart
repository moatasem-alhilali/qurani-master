import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/notification/notification_orchestrator_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/onboarding/data/app_permissions.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/settings_skin.dart';
import 'package:quran_app/l10n/l10n.dart';

/// تنبيهات الرئيسية لما يحتاجه الأذان ولم يُسمح به.
///
/// - الإشعارات متوقفة: لا أذان ولا أذكار.
/// - (أندرويد) «المنبّهات والتذكيرات» ممنوعة: يصل الأذان متأخّرًا دقائق.
///
/// الموقع ليس هنا: بطاقة المواقيت تعرض تنبيهه وأزراره بنفسها، وقد يختار
/// المستخدم مدينته يدويًا فلا يحتاج الإذن أصلًا.
///
/// يُعاد الفحص عند الرجوع للتطبيق، فمن فعّلها من الإعدادات يختفي تنبيهه فورًا.
class HomePermissionNotices extends StatefulWidget {
  const HomePermissionNotices({super.key});

  @override
  State<HomePermissionNotices> createState() => _HomePermissionNoticesState();
}

class _HomePermissionNoticesState extends State<HomePermissionNotices>
    with WidgetsBindingObserver {
  AppPermissionState _notifications = AppPermissionState.granted;
  bool _exactAlarms = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_refresh());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(_refresh());
  }

  Future<void> _refresh() async {
    try {
      final notifications = await AppPermissions.notifications();
      final exactAlarms = await AppPermissions.exactAlarmsAllowed();
      if (!mounted) return;
      final changedToGranted = _notifications != AppPermissionState.granted &&
          notifications == AppPermissionState.granted;
      setState(() {
        _notifications = notifications;
        _exactAlarms = exactAlarms;
      });
      // إشعارات جُدولت والإذن مرفوض لا تظهر على بعض الأجهزة؛ نعيد جدولتها
      // حين يُمنح الإذن.
      if (changedToGranted) unawaited(_reschedule());
    } catch (_) {
      // فحص فاشل لا يستحقّ تنبيهًا خاطئًا.
    }
  }

  Future<void> _reschedule() async {
    if (sl.isRegistered<NotificationOrchestratorService>()) {
      await sl<NotificationOrchestratorService>().rescheduleAllNotifications();
    }
  }

  Future<void> _enableNotifications() async {
    if (_notifications == AppPermissionState.blocked) {
      await AppPermissions.openSettings();
      return; // الرجوع للتطبيق يعيد الفحص.
    }
    await AppPermissions.requestNotifications();
    await _refresh();
  }

  Future<void> _allowExactAlarms() async {
    await AppPermissions.requestExactAlarms();
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final notificationsOff = _notifications != AppPermissionState.granted;
    // المنبّهات الدقيقة بلا معنى والإشعارات نفسها متوقفة: تنبيه واحد يكفي.
    final exactAlarmsOff = !notificationsOff && !_exactAlarms;

    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      alignment: AlignmentDirectional.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (notificationsOff)
            _NoticeTile(
              icon: AppIcons.notifications,
              title: l10n.homeNoticeNotificationsTitle,
              body: l10n.homeNoticeNotificationsBody,
              action: l10n.homeNoticeNotificationsAction,
              onAction: _enableNotifications,
            ),
          if (exactAlarmsOff)
            _NoticeTile(
              icon: AppIcons.clock,
              title: l10n.homeNoticeExactAlarmsTitle,
              body: l10n.homeNoticeExactAlarmsBody,
              action: l10n.homeNoticeExactAlarmsAction,
              onAction: _allowExactAlarms,
            ),
        ],
      ),
    );
  }
}

class _NoticeTile extends StatelessWidget {
  const _NoticeTile({
    required this.icon,
    required this.title,
    required this.body,
    required this.action,
    required this.onAction,
  });

  final HugeIconData icon;
  final String title;
  final String body;
  final String action;
  final Future<void> Function() onAction;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: skin.iconChip,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: skin.accent.withValues(alpha: 0.35)),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(12.w, 10.h, 6.w, 10.h),
          child: Row(
            children: [
              AppIcon(icon, size: 20.sp, color: skin.accent),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: skin.ink,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      body,
                      style: TextStyle(
                        color: skin.inkSoft,
                        fontSize: 10.5.sp,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              SettingsGhostButton(
                label: action,
                onPressed: () => unawaited(onAction()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
