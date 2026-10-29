import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/theme/app_skin.dart';
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
import 'package:quran_app/l10n/l10n.dart';

part 'prayer_time_settings_screen_sections_part.dart';
part 'prayer_time_settings_screen_duration_part.dart';

/// إعدادات أوقات الصلاة: قسمان من صفوف نحيلة على أرضية الصفحة،
/// وكل تغييرٍ يُحفظ من تلقاء نفسه.
@RoutePage()
class PrayerTimeSettingsScreen extends StatefulWidget
    implements AutoRouteWrapper {
  const PrayerTimeSettingsScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider<PrayerTimeBloc>(
        create: (_) => sl<PrayerTimeBloc>(),
        child: this,
      );

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

  /// How long a change waits before it is written.
  ///
  /// The minute steppers fire once per tap, so a user nudging Maghrib by a
  /// whole hour would otherwise write sixty times and recalculate the day's
  /// times sixty times behind them.
  static const Duration _autoSaveDelay = Duration(milliseconds: 600);

  late PrayerSilentModeSettings _settings;
  late PrayerSilentModeSettings _savedSettings;
  late PrayerCalculationSettings _calculationSettings;
  late PrayerCalculationSettings _savedCalculationSettings;
  bool _hasNotificationPolicyAccess = false;

  /// Held rather than read from `context`, because the last write runs from
  /// [dispose] — after the screen has left the tree and `context.read` is no
  /// longer allowed.
  late final PrayerTimeBloc _prayerTimeBloc;

  Timer? _autoSaveTimer;
  bool _isPersisting = false;
  bool _persistAgain = false;

  bool get _hasUnsavedChanges =>
      _calculationSettings != _savedCalculationSettings ||
      _settings != _savedSettings;

  @override
  void initState() {
    super.initState();
    _prayerTimeBloc = context.read<PrayerTimeBloc>();
    _savedSettings = _settingsStore.load();
    _settings = _savedSettings;
    _savedCalculationSettings = _calculationSettingsStore.load();
    _calculationSettings = _savedCalculationSettings;
    _refreshNativeState();
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    // A change made within the last [_autoSaveDelay] has not been written
    // yet, and leaving the page must not be what loses it.
    if (_hasUnsavedChanges) {
      unawaited(_persist());
    }
    super.dispose();
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
        title: context.l10n.prayerTimeSettingsTitle,
        showLargeHeader: false,
        initialOffset: null,
        body: ColoredBox(
          color: skin.ground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HomeSectionHeader(
                title: context.l10n.prayerTimeSettingsCalcHeader,
              ),
              PrayerCalculationSettingsCard(
                settings: _calculationSettings,
                onChanged: (settings) {
                  setState(() {
                    _calculationSettings = settings;
                  });
                  _scheduleAutoSave();
                },
              ),
              if (isAndroid) ...[
                skin.divider(),
                HomeSectionHeader(
                  title: context.l10n.prayerTimeSettingsSilentHeader,
                ),
                _SilentModeSection(
                  settings: _settings,
                  hasPolicyAccess: _hasNotificationPolicyAccess,
                  onEnabledChanged: _handleEnabledChanged,
                  onDurationChanged: _handleDurationChanged,
                  onOpenPermission: _openNotificationPolicySettings,
                ),
              ],
              SizedBox(height: 24.h),
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
    _scheduleAutoSave();
  }

  void _handleDurationChanged(int value) {
    setState(() {
      _settings = _settings.copyWith(durationMinutes: value.clamp(1, 360));
    });
    _scheduleAutoSave();
  }

  Future<void> _openNotificationPolicySettings() async {
    await _nativeService.openNotificationPolicySettings();
  }

  /// Puts the current settings on their way to disk after [_autoSaveDelay].
  ///
  /// There is no save button: the page used to end in one, and a user who
  /// changed the method or nudged a prayer and then went back lost it all
  /// without being told. Every change now writes itself.
  void _scheduleAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(_autoSaveDelay, () => unawaited(_persist()));
  }

  /// Serialised: a change arriving while a write is in flight is picked up by
  /// the loop rather than racing it to the same keys.
  Future<void> _persist() async {
    if (_isPersisting) {
      _persistAgain = true;
      return;
    }

    _isPersisting = true;
    try {
      do {
        _persistAgain = false;
        await _persistOnce();
      } while (_persistAgain);
    } finally {
      _isPersisting = false;
    }
  }

  Future<void> _persistOnce() async {
    // إعدادات الحساب مستقلة عن صلاحية عدم الإزعاج، فتُحفظ أولًا حتى لا
    // تضيع لو تعذّر تفعيل وضع الصامت.
    final calculation = _calculationSettings;
    final calculationChanged = calculation != _savedCalculationSettings;
    if (calculationChanged) {
      await _calculationSettingsStore.save(calculation);
      _savedCalculationSettings = calculation;
    }

    await _refreshNativeState();

    // A switch that is on without the access would promise a silence the app
    // cannot deliver, so it is not written.
    final silent = _settings;
    final canEnable = !silent.enabled ||
        !Platform.isAndroid ||
        _hasNotificationPolicyAccess;
    final silentSaved = silent != _savedSettings && canEnable;
    if (silentSaved) {
      await _settingsStore.save(silent);
      _savedSettings = silent;
    }

    if (calculationChanged) {
      // إعادة احتساب المواقيت تتكفّل أيضًا بإعادة جدولة وضع الصامت،
      // لذلك لا نستخدم قائمة المواقيت القديمة هنا.
      if (!_prayerTimeBloc.isClosed) {
        _prayerTimeBloc.add(const PrayerTimeCalculationSettingsChanged());
      }
    } else if (silentSaved) {
      final state = _prayerTimeBloc.state;
      await _nativeService.applySchedule(
        settings: silent,
        prayers: state.prayerList,
        selectedLocation: state.selectedLocation,
      );
    }

    if (!canEnable && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.prayerTimeSilentNeedsPermission)),
      );
    }
  }
}
