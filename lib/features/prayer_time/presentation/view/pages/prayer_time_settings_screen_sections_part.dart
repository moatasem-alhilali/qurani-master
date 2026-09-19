part of 'prayer_time_settings_screen.dart';

/// قسم الصامت (أندرويد فقط): مفتاح التفعيل، ثم مدّة الصامت، ثم رابط الصلاحية.
class _SilentModeSection extends StatelessWidget {
  const _SilentModeSection({
    required this.settings,
    required this.hasPolicyAccess,
    required this.isSaving,
    required this.onEnabledChanged,
    required this.onDurationChanged,
    required this.onOpenPermission,
  });

  final PrayerSilentModeSettings settings;
  final bool hasPolicyAccess;
  final bool isSaving;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<int> onDurationChanged;
  final Future<void> Function() onOpenPermission;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final enabled = settings.enabled;
    const hint = 'يحوّل الجهاز إلى صامت مع وقت الصلاة ثم يعيد الصوت تلقائيًا.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrayerSettingsSwitchRow(
          icon: AppIcons.mute,
          label: 'تفعيل الصامت تلقائيًا',
          hint: hint,
          value: enabled,
          enabled: !isSaving,
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
                _DurationRow(
                  value: settings.durationMinutes,
                  enabled: !isSaving,
                  onChanged: onDurationChanged,
                ),
                if (!hasPolicyAccess)
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
