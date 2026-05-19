import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_silent_mode_settings.dart';
import 'package:quran_app/features/prayer_time/data/service/prayer_silent_mode_native_service.dart';
import 'package:quran_app/features/prayer_time/data/service/prayer_silent_mode_settings_store.dart';
import 'package:quran_app/features/prayer_time/presentation/bloc/prayer_time_bloc.dart';

class PrayerTimeSettingsScreen extends StatefulWidget {
  const PrayerTimeSettingsScreen({super.key});

  @override
  State<PrayerTimeSettingsScreen> createState() =>
      _PrayerTimeSettingsScreenState();
}

class _PrayerTimeSettingsScreenState extends State<PrayerTimeSettingsScreen> {
  final PrayerSilentModeSettingsStore _settingsStore =
      PrayerSilentModeSettingsStore();
  final PrayerSilentModeNativeService _nativeService =
      PrayerSilentModeNativeService();

  late PrayerSilentModeSettings _settings;
  bool _hasNotificationPolicyAccess = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _settings = _settingsStore.load();
    _refreshNativeState();
  }

  Future<void> _refreshNativeState() async {
    final hasAccess = await _nativeService.hasNotificationPolicyAccess();
    if (!mounted) {
      return;
    }
    setState(() {
      _hasNotificationPolicyAccess = hasAccess;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAndroid = Platform.isAndroid;
    final isIos = Platform.isIOS;

    return AppScaffoldWidget(
      title: 'إعدادات أوقات الصلاة',
      showLargeHeader: false,
      initialOffset: null,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SilentModeCard(
              settings: _settings,
              isAndroid: isAndroid,
              isIos: isIos,
              hasPolicyAccess: _hasNotificationPolicyAccess,
              isSaving: _isSaving,
              onEnabledChanged: _handleEnabledChanged,
              onDurationChanged: _handleDurationChanged,
              onOpenPermission: _openNotificationPolicySettings,
            ),
            SizedBox(height: 14.h),
            FilledButton.icon(
              onPressed: _isSaving ? null : _save,
              style: FilledButton.styleFrom(
                minimumSize: Size.fromHeight(38.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13.r),
                ),
              ),
              icon: _isSaving
                  ? SizedBox.square(
                      dimension: 13.w,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const AppIcon(AppIcons.save, size: 13),
              label: Text(
                'حفظ الإعدادات',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleEnabledChanged(bool value) async {
    if (value && Platform.isAndroid && !_hasNotificationPolicyAccess) {
      await _openNotificationPolicySettings();
    }
    setState(() {
      _settings = _settings.copyWith(enabled: value);
    });
  }

  void _handleDurationChanged(int value) {
    setState(() {
      _settings = _settings.copyWith(durationMinutes: value.clamp(1, 360));
    });
  }

  Future<void> _openNotificationPolicySettings() async {
    await _nativeService.openNotificationPolicySettings();
  }

  Future<void> _save() async {
    setState(() {
      _isSaving = true;
    });

    try {
      await _refreshNativeState();
      final canEnable = !_settings.enabled ||
          !Platform.isAndroid ||
          _hasNotificationPolicyAccess;

      if (!canEnable && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('امنح صلاحية عدم الإزعاج أولًا حتى تعمل الميزة.'),
          ),
        );
        return;
      }

      await _settingsStore.save(_settings);
      if (!mounted) {
        return;
      }
      final state = context.read<PrayerTimeBloc>().state;
      await _nativeService.applySchedule(
        settings: _settings,
        prayers: state.prayerList,
      );

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ إعدادات أوقات الصلاة.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}

class _SilentModeCard extends StatelessWidget {
  const _SilentModeCard({
    required this.settings,
    required this.isAndroid,
    required this.isIos,
    required this.hasPolicyAccess,
    required this.isSaving,
    required this.onEnabledChanged,
    required this.onDurationChanged,
    required this.onOpenPermission,
  });

  final PrayerSilentModeSettings settings;
  final bool isAndroid;
  final bool isIos;
  final bool hasPolicyAccess;
  final bool isSaving;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<int> onDurationChanged;
  final Future<void> Function() onOpenPermission;

  @override
  Widget build(BuildContext context) {
    final isSupported = isAndroid || isIos;
    final enabled = settings.enabled && isSupported;
    final title = isAndroid ? 'الصامت وقت الصلاة' : 'تنبيه وضع الصلاة';
    final subtitle = isAndroid
        ? 'يحوّل الجهاز إلى صامت مع وقت الصلاة ثم يعيد الصوت تلقائيًا.'
        : 'يرسل تنبيهًا وقت الصلاة لتفعيل الصامت أو التركيز يدويًا.';

    return Container(
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(
          color: context.primaryColor.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: context.shadow.withValues(alpha: 0.035),
            blurRadius: 10.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _IconBadge(
                icon: AppIcons.mute,
                color: context.primaryColor,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: context.onSurfaceColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: context.onSurfaceVariant,
                        fontSize: 10.sp,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: enabled,
                onChanged: isSupported && !isSaving ? onEnabledChanged : null,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          AnimatedOpacity(
            opacity: enabled ? 1 : 0.55,
            duration: const Duration(milliseconds: 180),
            child: IgnorePointer(
              ignoring: !enabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isAndroid)
                    _DurationField(
                      value: settings.durationMinutes,
                      onChanged: onDurationChanged,
                    )
                  else
                    const _IosAlternativeNotice(),
                  if (isAndroid && !hasPolicyAccess) ...[
                    SizedBox(height: 10.h),
                    _PermissionNotice(onOpenPermission: onOpenPermission),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DurationField extends StatelessWidget {
  const _DurationField({
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: '$value');

    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: context.surfaceVariant.withValues(alpha: 0.24),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: context.outlineVariant.withValues(alpha: 0.24),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'مدة الصامت بعد الصلاة',
              style: TextStyle(
                color: context.onSurfaceColor,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(
            width: 74.w,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w900,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 8.h,
                ),
                suffixText: 'د',
              ),
              onChanged: (text) {
                final parsed = int.tryParse(text.trim());
                if (parsed != null) {
                  onChanged(parsed);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _IosAlternativeNotice extends StatelessWidget {
  const _IosAlternativeNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: context.primaryColor.withValues(alpha: 0.14),
        ),
      ),
      child: Row(
        children: [
          AppIcon(
            AppIcons.notifications,
            size: 14.sp,
            color: context.primaryColor,
            strokeWidth: 1.55,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'سيتم إرسال تنبيه عند كل صلاة قادمة لتذكيرك بتفعيل الصامت '
              'أو وضع التركيز من النظام.',
              style: TextStyle(
                color: context.onSurfaceColor,
                fontSize: 10.5.sp,
                height: 1.45,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionNotice extends StatelessWidget {
  const _PermissionNotice({required this.onOpenPermission});

  final Future<void> Function() onOpenPermission;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onOpenPermission,
      style: OutlinedButton.styleFrom(
        minimumSize: Size.fromHeight(36.h),
        side: BorderSide(
          color: context.primaryColor.withValues(alpha: 0.25),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13.r),
        ),
      ),
      icon: const AppIcon(AppIcons.shield, size: 13),
      label: Text(
        'منح صلاحية عدم الإزعاج',
        style: TextStyle(
          fontSize: 11.5.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    required this.color,
  });

  final HugeIconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: AppIcon(
          icon,
          size: 18.sp,
          color: color,
          strokeWidth: 1.55,
        ),
      ),
    );
  }
}
