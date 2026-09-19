import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/onboarding/data/app_permissions.dart';
import 'package:quran_app/features/onboarding/presentation/onboarding_cubit.dart';
import 'package:quran_app/features/setting/presentation/view/widgets/settings_skin.dart';
import 'package:quran_app/l10n/l10n.dart';

enum _Step { notifications, location }

/// شاشات الصلاحيات بعد اختيار اللغة: الإشعارات ثم الموقع — مرّة واحدة.
///
/// - كل خطوة تشرح الفائدة **قبل** نافذة النظام؛ ضغطة «السماح» وحدها تعرضها.
/// - «ليس الآن» ينتقل دون سؤال، فلا يُستهلك طلب iOS الوحيد على مستخدم متردّد.
/// - صلاحية ممنوحة سلفًا (مستخدم قديم حدّث التطبيق) أو محجوبة نهائيًا تُتخطّى
///   خطوتها: لا فائدة من سؤال لن تعرضه المنصّة.
class PermissionsOnboardingScreen extends StatefulWidget {
  const PermissionsOnboardingScreen({super.key});

  @override
  State<PermissionsOnboardingScreen> createState() =>
      _PermissionsOnboardingScreenState();
}

class _PermissionsOnboardingScreenState
    extends State<PermissionsOnboardingScreen> {
  List<_Step>? _steps;
  int _index = 0;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    unawaited(_resolveSteps());
  }

  Future<void> _resolveSteps() async {
    final steps = <_Step>[
      if (await AppPermissions.notifications() == AppPermissionState.askable)
        _Step.notifications,
      if (await AppPermissions.location() == AppPermissionState.askable)
        _Step.location,
    ];
    if (!mounted) return;
    if (steps.isEmpty) {
      await context.read<OnboardingCubit>().completePermissions();
      return;
    }
    setState(() => _steps = steps);
  }

  Future<void> _allow() async {
    final steps = _steps;
    if (steps == null || _busy) return;
    setState(() => _busy = true);
    try {
      switch (steps[_index]) {
        case _Step.notifications:
          await AppPermissions.requestNotifications();
        case _Step.location:
          await AppPermissions.requestLocation();
      }
    } catch (_) {
      // نافذة لم تُعرض أو منصّة لا تدعمها — ننتقل كما لو قال «ليس الآن».
    }
    if (!mounted) return;
    setState(() => _busy = false);
    await _next();
  }

  Future<void> _next() async {
    final steps = _steps;
    if (steps == null) return;
    if (_index + 1 < steps.length) {
      setState(() => _index++);
      return;
    }
    await context.read<OnboardingCubit>().completePermissions();
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final steps = _steps;

    return Scaffold(
      backgroundColor: skin.ground,
      body: SafeArea(
        child: steps == null
            ? const SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 16.h),
                  // شاشة اللغة هي الخطوة الأولى، فالعدّ يبدأ من الثانية.
                  _StepDots(current: _index + 1, total: steps.length + 1),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 260),
                      switchInCurve: Curves.easeOutCubic,
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.04),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      ),
                      child: _StepPage(
                        key: ValueKey(steps[_index]),
                        step: steps[_index],
                      ),
                    ),
                  ),
                  SettingsPrimaryButton(
                    label: steps[_index] == _Step.notifications
                        ? context.l10n.onboardingNotificationsAllow
                        : context.l10n.onboardingLocationAllow,
                    icon: steps[_index] == _Step.notifications
                        ? AppIcons.notifications
                        : AppIcons.location,
                    busy: _busy,
                    onPressed: _allow,
                  ),
                  Center(
                    child: SettingsGhostButton(
                      label: context.l10n.coreNotNow,
                      onPressed: _busy
                          ? null
                          : () {
                              unawaited(HapticFeedback.selectionClick());
                              unawaited(_next());
                            },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 2.h, 24.w, 14.h),
                    child: Text(
                      steps[_index] == _Step.notifications
                          ? context.l10n.onboardingChangeLater
                          : context.l10n.onboardingLocationManualHint,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: skin.inkSoft.withValues(alpha: 0.85),
                        fontSize: 10.5.sp,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _StepPage extends StatelessWidget {
  const _StepPage({required this.step, super.key});

  final _Step step;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final l10n = context.l10n;
    final isNotifications = step == _Step.notifications;

    final title = isNotifications
        ? l10n.onboardingNotificationsTitle
        : l10n.onboardingLocationTitle;
    final body = isNotifications
        ? l10n.onboardingNotificationsBody
        : l10n.onboardingLocationBody;
    final points = isNotifications
        ? [
            (AppIcons.notifications, l10n.onboardingNotificationsPointAthan),
            (AppIcons.clock, l10n.onboardingNotificationsPointAdhkar),
            (AppIcons.check, l10n.onboardingNotificationsPointWird),
          ]
        : [
            (AppIcons.clock, l10n.onboardingLocationPointTimes),
            (AppIcons.mapPin, l10n.onboardingLocationPointTravel),
            (AppIcons.location, l10n.onboardingLocationPointQibla),
          ];

    return ListView(
      padding: EdgeInsets.fromLTRB(24.w, 36.h, 24.w, 12.h),
      children: [
        Center(
          child: Container(
            width: 84.w,
            height: 84.w,
            decoration: BoxDecoration(
              color: skin.iconChip,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: AppIcon(
              isNotifications ? AppIcons.notifications : AppIcons.location,
              size: 38.sp,
              color: skin.accent,
            ),
          ),
        ),
        SizedBox(height: 22.h),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: skin.ink,
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          body,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: skin.inkSoft,
            fontSize: 12.5.sp,
            height: 1.6,
          ),
        ),
        SizedBox(height: 22.h),
        for (final (icon, text) in points) _Point(icon: icon, text: text),
      ],
    );
  }
}

class _Point extends StatelessWidget {
  const _Point({required this.icon, required this.text});

  final HugeIconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
      child: Row(
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: skin.iconChip,
              borderRadius: BorderRadius.circular(9.r),
            ),
            alignment: Alignment.center,
            child: AppIcon(icon, size: 15.sp, color: skin.accent),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: skin.ink,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepDots extends StatelessWidget {
  const _StepDots({required this.current, required this.total});

  /// يبدأ من الصفر.
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    return Semantics(
      label: context.l10n.onboardingStepLabel(current + 1, total),
      child: ExcludeSemantics(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < total; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                width: i == current ? 20.w : 7.w,
                height: 7.w,
                decoration: BoxDecoration(
                  color: i <= current ? skin.accent : skin.hairline,
                  borderRadius: BorderRadius.circular(99.r),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
