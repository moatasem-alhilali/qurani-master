part of 'prayer_time_settings_screen.dart';

/// قسم الصامت: مفتاح التفعيل، ثم مدّة الصامت أو تنبيه iOS، ثم رابط الصلاحية.
class _SilentModeSection extends StatelessWidget {
  const _SilentModeSection({
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
    final skin = AppSkin.of(context);
    final isSupported = isAndroid || isIos;
    final enabled = settings.enabled && isSupported;
    final hint = isAndroid
        ? 'يحوّل الجهاز إلى صامت مع وقت الصلاة ثم يعيد الصوت تلقائيًا.'
        : 'يرسل تنبيهًا وقت الصلاة لتفعيل الصامت أو التركيز يدويًا.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrayerSettingsSwitchRow(
          icon: AppIcons.mute,
          label: isAndroid ? 'تفعيل الصامت تلقائيًا' : 'تنبيه وقت الصلاة',
          hint: hint,
          value: enabled,
          enabled: isSupported && !isSaving,
          onChanged: onEnabledChanged,
        ),
        AnimatedOpacity(
          opacity: enabled ? 1 : 0.5,
          duration: const Duration(milliseconds: 180),
          child: IgnorePointer(
            ignoring: !enabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isAndroid)
                  _DurationRow(
                    value: settings.durationMinutes,
                    enabled: !isSaving,
                    onChanged: onDurationChanged,
                  )
                else
                  const _IosAlternativeNote(),
                if (isAndroid && !hasPolicyAccess)
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'تحتاج الميزة صلاحية «عدم الإزعاج» من النظام.',
                            style: TextStyle(
                              color: skin.inkSoft.withValues(alpha: 0.78),
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.45,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        PrayerSettingsTextLink(
                          label: 'منح الصلاحية',
                          icon: AppIcons.shield,
                          onTap: onOpenPermission,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
