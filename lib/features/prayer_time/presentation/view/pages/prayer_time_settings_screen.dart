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

part 'prayer_time_settings_screen_sections_part.dart';
part 'prayer_time_settings_screen_duration_part.dart';
part 'prayer_time_settings_screen_footer_part.dart';

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
    // iOS لا يسمح للتطبيقات بتحويل الجهاز إلى الصامت، فالقسم لأندرويد وحده.
    final isAndroid = Platform.isAndroid;

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
              if (isAndroid) ...[
                skin.divider(),
                const HomeSectionHeader(title: 'الصامت وقت الصلاة'),
                _SilentModeSection(
                  settings: _settings,
                  hasPolicyAccess: _hasNotificationPolicyAccess,
                  isSaving: _isSaving,
                  onEnabledChanged: _handleEnabledChanged,
                  onDurationChanged: _handleDurationChanged,
                  onOpenPermission: _openNotificationPolicySettings,
                ),
              ],
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
