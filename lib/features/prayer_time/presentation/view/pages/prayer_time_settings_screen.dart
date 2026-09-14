import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_calculation_settings.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_silent_mode_settings.dart';
import 'package:quran_app/features/prayer_time/data/service/prayer_calculation_settings_store.dart';
import 'package:quran_app/features/prayer_time/data/service/prayer_silent_mode_native_service.dart';
import 'package:quran_app/features/prayer_time/data/service/prayer_silent_mode_settings_store.dart';
import 'package:quran_app/features/prayer_time/presentation/bloc/prayer_time_bloc.dart';
import 'package:quran_app/features/prayer_time/presentation/view/widgets/prayer_calculation_settings_card.dart';

/// إعدادات أوقات الصلاة: قسمان من صفوف نحيلة على أرضية الصفحة،
/// وزرّ حفظ واحد ذهبي في آخر الصفحة.
class PrayerTimeSettingsScreen extends StatefulWidget {
  const PrayerTimeSettingsScreen({super.key});

  @override
  State<PrayerTimeSettingsScreen> createState() =>
      _PrayerTimeSettingsScreenState();
}

class _PrayerTimeSettingsScreenState extends State<PrayerTimeSettingsScreen> {
  final PrayerSilentModeSettingsStore _settingsStore =
      PrayerSilentModeSettingsStore();
  final PrayerCalculationSettingsStore _calculationSettingsStore =
      PrayerCalculationSettingsStore();
  final PrayerSilentModeNativeService _nativeService =
      PrayerSilentModeNativeService();

  late PrayerSilentModeSettings _settings;
  late PrayerCalculationSettings _calculationSettings;
  late PrayerCalculationSettings _savedCalculationSettings;
  bool _hasNotificationPolicyAccess = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _settings = _settingsStore.load();
    _savedCalculationSettings = _calculationSettingsStore.load();
    _calculationSettings = _savedCalculationSettings;
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
    final skin = AppSkin.of(context);
    final isAndroid = Platform.isAndroid;
    final isIos = Platform.isIOS;

    return Theme(
      data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
      child: AppScaffoldWidget(
        title: 'إعدادات أوقات الصلاة',
        showLargeHeader: false,
        initialOffset: null,
        body: ColoredBox(
          color: skin.ground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HomeSectionHeader(title: 'طريقة حساب المواقيت'),
              PrayerCalculationSettingsCard(
                settings: _calculationSettings,
                isSaving: _isSaving,
                onChanged: (settings) {
                  setState(() {
                    _calculationSettings = settings;
                  });
                },
              ),
              skin.divider(),
              HomeSectionHeader(
                title: isAndroid ? 'الصامت وقت الصلاة' : 'تنبيه وضع الصلاة',
              ),
              _SilentModeSection(
                settings: _settings,
                isAndroid: isAndroid,
                isIos: isIos,
                hasPolicyAccess: _hasNotificationPolicyAccess,
                isSaving: _isSaving,
                onEnabledChanged: _handleEnabledChanged,
                onDurationChanged: _handleDurationChanged,
                onOpenPermission: _openNotificationPolicySettings,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 24.h),
                child: _SaveButton(
                  isSaving: _isSaving,
                  onTap: _isSaving ? null : _save,
                ),
              ),
            ],
          ),
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

  void _reloadPrayerTimesIfNeeded(bool calculationChanged) {
    if (!calculationChanged) {
      return;
    }
    context
        .read<PrayerTimeBloc>()
        .add(const PrayerTimeCalculationSettingsChanged());
  }

  Future<void> _save() async {
    setState(() {
      _isSaving = true;
    });

    try {
      // إعدادات الحساب مستقلة عن صلاحية عدم الإزعاج، فتُحفظ أولًا حتى لا
      // تضيع لو تعذّر تفعيل وضع الصامت.
      final calculationChanged =
          _calculationSettings != _savedCalculationSettings;
      if (calculationChanged) {
        await _calculationSettingsStore.save(_calculationSettings);
        _savedCalculationSettings = _calculationSettings;
      }

      await _refreshNativeState();
      final canEnable = !_settings.enabled ||
          !Platform.isAndroid ||
          _hasNotificationPolicyAccess;

      if (!canEnable) {
        if (mounted) {
          _reloadPrayerTimesIfNeeded(calculationChanged);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('امنح صلاحية عدم الإزعاج أولًا حتى تعمل الميزة.'),
            ),
          );
        }
        return;
      }

      await _settingsStore.save(_settings);
      if (!mounted) {
        return;
      }

      if (calculationChanged) {
        // إعادة احتساب المواقيت تتكفّل أيضًا بإعادة جدولة وضع الصامت،
        // لذلك لا نستخدم قائمة المواقيت القديمة هنا.
        _reloadPrayerTimesIfNeeded(true);
      } else {
        final state = context.read<PrayerTimeBloc>().state;
        await _nativeService.applySchedule(
          settings: _settings,
          prayers: state.prayerList,
          selectedLocation: state.selectedLocation,
        );
      }

      if (!mounted) {
        return;
      }
      await HapticFeedback.mediumImpact();
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

/// مدّة الصامت: رقم يُكتب مباشرة، مع زرّي نقصان وزيادة للتعديل السريع.
class _DurationRow extends StatefulWidget {
  const _DurationRow({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final int value;
  final bool enabled;
  final ValueChanged<int> onChanged;

  @override
  State<_DurationRow> createState() => _DurationRowState();
}

class _DurationRowState extends State<_DurationRow> {
  late final TextEditingController _controller =
      TextEditingController(text: '${widget.value}');

  @override
  void didUpdateWidget(covariant _DurationRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // لا نلمس الحقل ما دام المستخدم يكتب فيه القيمة نفسها.
    if (widget.value != oldWidget.value &&
        _controller.text != '${widget.value}') {
      _controller.text = '${widget.value}';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _step(int delta) {
    final next = (widget.value + delta).clamp(1, 360);
    HapticFeedback.selectionClick();
    _controller.text = '$next';
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: skin.hairline)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
      child: Row(
        children: [
          SizedBox(width: 38.w),
          Expanded(
            child: Text(
              'مدة الصامت بعد الصلاة',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: skin.ink,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _DurationStepButton(
            icon: Icons.remove_rounded,
            enabled: widget.enabled && widget.value > 1,
            onTap: () => _step(-5),
          ),
          SizedBox(
            width: 54.w,
            child: TextField(
              controller: _controller,
              enabled: widget.enabled,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              cursorColor: skin.accent,
              style: TextStyle(
                color: skin.accent,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
                fontFeatures: const [ui.FontFeature.tabularFigures()],
              ),
              decoration: InputDecoration(
                isDense: true,
                filled: false,
                suffixText: 'د',
                suffixStyle: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.7),
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w500,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 6.h),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: skin.hairline),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: skin.hairline),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: skin.accent),
                ),
              ),
              onChanged: (text) {
                final parsed = int.tryParse(text.trim());
                if (parsed != null) {
                  widget.onChanged(parsed);
                }
              },
            ),
          ),
          _DurationStepButton(
            icon: Icons.add_rounded,
            enabled: widget.enabled && widget.value < 360,
            onTap: () => _step(5),
          ),
        ],
      ),
    );
  }
}

class _DurationStepButton extends StatelessWidget {
  const _DurationStepButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(9.r),
      child: Container(
        width: 28.w,
        height: 28.w,
        decoration: BoxDecoration(
          color: enabled ? skin.iconChip : Colors.transparent,
          borderRadius: BorderRadius.circular(9.r),
          border: enabled ? null : Border.all(color: skin.hairline),
        ),
        child: Icon(
          icon,
          size: 15.sp,
          color: enabled ? skin.accent : skin.inkSoft.withValues(alpha: 0.38),
        ),
      ),
    );
  }
}

class _IosAlternativeNote extends StatelessWidget {
  const _IosAlternativeNote();

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PrayerSettingsIconChip(icon: AppIcons.notifications),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'سيتم إرسال تنبيه عند كل صلاة قادمة لتذكيرك بتفعيل الصامت '
              'أو وضع التركيز من النظام.',
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w500,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// زرّ الحفظ: التعبئة الذهبية المسموح بها للفعل الرئيسي في الشاشة.
class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.isSaving, required this.onTap});

  final bool isSaving;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Ink(
        decoration: BoxDecoration(
          color: onTap == null
              ? AppColors.gold.withValues(alpha: 0.5)
              : AppColors.gold,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: SizedBox(
          height: 40.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSaving)
                SizedBox.square(
                  dimension: 13.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.brandIvory,
                    ),
                  ),
                )
              else
                const AppIcon(
                  AppIcons.save,
                  color: AppColors.brandIvory,
                  size: 15,
                ),
              SizedBox(width: 8.w),
              Text(
                isSaving ? 'جارِ الحفظ' : 'حفظ الإعدادات',
                style: TextStyle(
                  color: AppColors.brandIvory,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [ui.FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
