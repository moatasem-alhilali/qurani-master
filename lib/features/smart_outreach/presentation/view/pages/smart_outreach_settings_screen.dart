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
      ..showSnackBar(const SnackBar(content: Text('تم حفظ الإعدادات.')));
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return AppScaffoldWidget(
      title: 'إعدادات الاتصال',
      initialOffset: null,
      showLargeHeader: false,
      body: _loading
          ? const OutreachLoading()
          : OutreachGround(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 4.h),
                  child: Text(
                    'تُطبَّق هذه القيم على كل قائمة جديدة.',
                    style: TextStyle(
                      color: skin.inkSoft.withValues(alpha: 0.78),
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                  ),
                ),
                const HomeSectionHeader(title: 'المدد الافتراضية'),
                OutreachSliderRow(
                  label: 'مدة انتظار الرد',
                  value: _ringTimeout.toDouble(),
                  min: 5,
                  max: 60,
                  divisions: 55,
                  valueLabel: '$_ringTimeout ث',
                  onChanged: (value) {
                    setState(() => _ringTimeout = value.round());
                  },
                ),
                OutreachSliderRow(
                  label: 'الانتظار بعد الرد',
                  value: _hangupDelay.toDouble(),
                  min: 5,
                  max: 120,
                  divisions: 23,
                  valueLabel: '$_hangupDelay ث',
                  onChanged: (value) {
                    setState(() => _hangupDelay = value.round());
                  },
                ),
                OutreachSliderRow(
                  label: 'الفاصل بين كل رقم',
                  value: _delayBetweenCalls.toDouble(),
                  min: 1,
                  max: 30,
                  divisions: 29,
                  valueLabel: '$_delayBetweenCalls ث',
                  isLast: true,
                  onChanged: (value) {
                    setState(() => _delayBetweenCalls = value.round());
                  },
                ),
                skin.divider(),
                const HomeSectionHeader(title: 'سلوك القوائم'),
                OutreachSwitchRow(
                  title: 'إيقاف القائمة بعد أول رد',
                  icon: AppIcons.stop,
                  value: _stopOnFirstAnswered,
                  onChanged: (value) {
                    setState(() => _stopOnFirstAnswered = value);
                  },
                ),
                OutreachSwitchRow(
                  title: 'إعادة الاتصال إذا لم يتم الرد',
                  icon: AppIcons.replay,
                  value: _retryEnabled,
                  onChanged: (value) {
                    setState(() => _retryEnabled = value);
                  },
                ),
                OutreachSwitchRow(
                  title: 'إعادة البدء بعد الانتهاء',
                  icon: AppIcons.refresh,
                  value: _repeatCycle,
                  isLast: true,
                  onChanged: (value) {
                    setState(() => _repeatCycle = value);
                  },
                ),
                OutreachPrimaryButton(
                  label: 'حفظ الإعدادات',
                  icon: AppIcons.save,
                  onTap: _save,
                ),
                SizedBox(height: 4.h),
                const HomeSectionHeader(title: 'التشغيل في الخلفية'),
                OutreachRow(
                  title: 'استثناء التطبيق من توفير البطارية',
                  icon: AppIcons.battery,
                  subtitle: 'إذا توقفت القوائم وهي في الخلفية، اسمح للتطبيق '
                      'بالعمل من إعدادات البطارية.',
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
