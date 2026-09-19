import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:quran_app/features/smart_outreach/data/repo/smart_outreach_schedule_repository.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_settings_store.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/widgets/smart_outreach_ui_kit.dart';
import 'package:quran_app/l10n/l10n.dart';

class SmartOutreachSettingsScreen extends StatefulWidget {
  const SmartOutreachSettingsScreen({super.key});

  @override
  State<SmartOutreachSettingsScreen> createState() =>
      _SmartOutreachSettingsScreenState();
}

class _SmartOutreachSettingsScreenState
    extends State<SmartOutreachSettingsScreen> {
  final SmartOutreachSettingsStore _store = sl<SmartOutreachSettingsStore>();
  final SmartOutreachScheduleRepository _repository =
      sl<SmartOutreachScheduleRepository>();

  bool _loading = true;
  int _ringTimeout = 20;
  int _hangupDelay = 30;
  int _delayBetweenCalls = 3;
  bool _stopOnFirstAnswered = false;
  bool _retryEnabled = false;
  bool _repeatCycle = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _ringTimeout = await _store.getDefaultRingTimeout();
    _hangupDelay = await _store.getDefaultHangupDelay();
    _delayBetweenCalls = await _store.getDefaultDelayBetweenCalls();
    _stopOnFirstAnswered = await _store.getDefaultStopOnFirstAnswered();
    _retryEnabled = await _store.getDefaultRetryEnabled();
    _repeatCycle = await _store.getDefaultRepeatCycle();

    if (!mounted) return;
    setState(() {
      _loading = false;
    });
  }

  Future<void> _save() async {
    unawaited(HapticFeedback.mediumImpact());

    await _store.saveDefaults(
      ringTimeout: _ringTimeout,
      hangupDelay: _hangupDelay,
      delayBetweenCalls: _delayBetweenCalls,
      stopOnFirstAnswered: _stopOnFirstAnswered,
      retryEnabled: _retryEnabled,
      repeatCycle: _repeatCycle,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(context.l10n.outreachSettingsSaved)),
      );
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final l10n = context.l10n;

    return AppScaffoldWidget(
      title: l10n.outreachSettingsTitle,
      initialOffset: null,
      showLargeHeader: false,
      body: _loading
          ? const OutreachLoading()
          : OutreachGround(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 4.h),
                  child: Text(
                    l10n.outreachSettingsIntro,
                    style: TextStyle(
                      color: skin.inkSoft.withValues(alpha: 0.78),
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                  ),
                ),
                HomeSectionHeader(title: l10n.outreachDefaultDurationsHeader),
                OutreachSliderRow(
                  label: l10n.outreachRingTimeout,
                  value: _ringTimeout.toDouble(),
                  min: 5,
                  max: 60,
                  divisions: 55,
                  valueLabel: l10n.outreachSecondsValue(_ringTimeout),
                  onChanged: (value) {
                    setState(() => _ringTimeout = value.round());
                  },
                ),
                OutreachSliderRow(
                  label: l10n.outreachHangupDelay,
                  value: _hangupDelay.toDouble(),
                  min: 5,
                  max: 120,
                  divisions: 23,
                  valueLabel: l10n.outreachSecondsValue(_hangupDelay),
                  onChanged: (value) {
                    setState(() => _hangupDelay = value.round());
                  },
                ),
                OutreachSliderRow(
                  label: l10n.outreachDelayBetweenEach,
                  value: _delayBetweenCalls.toDouble(),
                  min: 1,
                  max: 30,
                  divisions: 29,
                  valueLabel: l10n.outreachSecondsValue(_delayBetweenCalls),
                  isLast: true,
                  onChanged: (value) {
                    setState(() => _delayBetweenCalls = value.round());
                  },
                ),
                skin.divider(),
                HomeSectionHeader(title: l10n.outreachBehaviorHeader),
                OutreachSwitchRow(
                  title: l10n.outreachStopAfterFirstAnswerList,
                  icon: AppIcons.stop,
                  value: _stopOnFirstAnswered,
                  onChanged: (value) {
                    setState(() => _stopOnFirstAnswered = value);
                  },
                ),
                OutreachSwitchRow(
                  title: l10n.outreachRetryIfNoAnswer,
                  icon: AppIcons.replay,
                  value: _retryEnabled,
                  onChanged: (value) {
                    setState(() => _retryEnabled = value);
                  },
                ),
                OutreachSwitchRow(
                  title: l10n.outreachRestartAfterFinish,
                  icon: AppIcons.refresh,
                  value: _repeatCycle,
                  isLast: true,
                  onChanged: (value) {
                    setState(() => _repeatCycle = value);
                  },
                ),
                OutreachPrimaryButton(
                  label: l10n.outreachSaveSettings,
                  icon: AppIcons.save,
                  onTap: _save,
                ),
                SizedBox(height: 4.h),
                HomeSectionHeader(title: l10n.outreachBackgroundHeader),
                OutreachRow(
                  title: l10n.outreachBatteryTitle,
                  icon: AppIcons.battery,
                  subtitle: l10n.outreachBatterySubtitle,
                  showChevron: true,
                  isLast: true,
                  onTap: _repository.openBatterySettings,
                ),
                SizedBox(height: 32.h),
              ],
            ),
    );
  }
}
