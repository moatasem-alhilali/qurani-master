import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/smart_outreach/data/repo/smart_outreach_schedule_repository.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_settings_store.dart';

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
    await _store.saveDefaults(
      ringTimeout: _ringTimeout,
      hangupDelay: _hangupDelay,
      delayBetweenCalls: _delayBetweenCalls,
      stopOnFirstAnswered: _stopOnFirstAnswered,
      retryEnabled: _retryEnabled,
      repeatCycle: _repeatCycle,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ الإعدادات.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      title: 'إعدادات المكالمات',
      initialOffset: null,
      showLargeHeader: false,
      body: _loading
          ? Center(
              child: CircularProgressIndicator(color: context.primaryColor),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _SettingsHero(
                    ringTimeout: _ringTimeout,
                    hangupDelay: _hangupDelay,
                    delayBetweenCalls: _delayBetweenCalls,
                  ),
                  SizedBox(height: 12.h),
                  _SliderTile(
                    icon: AppIcons.notifications,
                    label: 'مدة انتظار الرد',
                    value: _ringTimeout.toDouble(),
                    min: 5,
                    max: 60,
                    divisions: 55,
                    suffix: '$_ringTimeout ث',
                    onChanged: (value) {
                      setState(() => _ringTimeout = value.round());
                    },
                  ),
                  SizedBox(height: 10.h),
                  _SliderTile(
                    icon: AppIcons.phone,
                    label: 'الانتظار بعد الرد',
                    value: _hangupDelay.toDouble(),
                    min: 5,
                    max: 120,
                    divisions: 23,
                    suffix: '$_hangupDelay ث',
                    onChanged: (value) {
                      setState(() => _hangupDelay = value.round());
                    },
                  ),
                  SizedBox(height: 10.h),
                  _SliderTile(
                    icon: AppIcons.clock,
                    label: 'الفاصل بين كل رقم',
                    value: _delayBetweenCalls.toDouble(),
                    min: 1,
                    max: 30,
                    divisions: 29,
                    suffix: '$_delayBetweenCalls ث',
                    onChanged: (value) {
                      setState(() => _delayBetweenCalls = value.round());
                    },
                  ),
                  SizedBox(height: 12.h),
                  _TogglePanel(
                    stopOnFirstAnswered: _stopOnFirstAnswered,
                    retryEnabled: _retryEnabled,
                    repeatCycle: _repeatCycle,
                    onStopChanged: (value) {
                      setState(() => _stopOnFirstAnswered = value);
                    },
                    onRetryChanged: (value) {
                      setState(() => _retryEnabled = value);
                    },
                    onRepeatChanged: (value) {
                      setState(() => _repeatCycle = value);
                    },
                  ),
                  SizedBox(height: 14.h),
                  _PrimaryAction(
                    label: 'حفظ الإعدادات',
                    icon: AppIcons.save,
                    onTap: _save,
                  ),
                  SizedBox(height: 10.h),
                  _BatteryPanel(onTap: _repository.openBatterySettings),
                  SizedBox(height: 34.h),
                ],
              ),
            ),
    );
  }
}

class _SettingsHero extends StatelessWidget {
  const _SettingsHero({
    required this.ringTimeout,
    required this.hangupDelay,
    required this.delayBetweenCalls,
  });

  final int ringTimeout;
  final int hangupDelay;
  final int delayBetweenCalls;

  @override
  Widget build(BuildContext context) {
    return _SoftPanel(
      padding: EdgeInsets.all(14.w),
      child: Row(
        children: [
          _IconBubble(icon: AppIcons.sliders),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الإعدادات الافتراضية',
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'انتظار $ringTimeoutث، بعد الرد $hangupDelayث، بين الأرقام $delayBetweenCallsث',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.onSurfaceVariant,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.suffix,
    required this.onChanged,
  });

  final HugeIconData icon;
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String suffix;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return _SoftPanel(
      padding: EdgeInsets.fromLTRB(12.w, 11.h, 12.w, 7.h),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              AppIcon(
                icon,
                size: 14.sp,
                color: context.primaryColor,
                strokeWidth: 1.55,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                suffix,
                style: TextStyle(
                  color: context.primaryColor,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2.5.h,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 13.r),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _TogglePanel extends StatelessWidget {
  const _TogglePanel({
    required this.stopOnFirstAnswered,
    required this.retryEnabled,
    required this.repeatCycle,
    required this.onStopChanged,
    required this.onRetryChanged,
    required this.onRepeatChanged,
  });

  final bool stopOnFirstAnswered;
  final bool retryEnabled;
  final bool repeatCycle;
  final ValueChanged<bool> onStopChanged;
  final ValueChanged<bool> onRetryChanged;
  final ValueChanged<bool> onRepeatChanged;

  @override
  Widget build(BuildContext context) {
    return _SoftPanel(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        children: [
          _CompactSwitchTile(
            icon: AppIcons.stop,
            title: 'إيقاف القائمة بعد أول رد',
            value: stopOnFirstAnswered,
            onChanged: onStopChanged,
          ),
          _CompactSwitchTile(
            icon: AppIcons.replay,
            title: 'إعادة الاتصال إذا لم يتم الرد',
            value: retryEnabled,
            onChanged: onRetryChanged,
          ),
          _CompactSwitchTile(
            icon: AppIcons.refresh,
            title: 'إعادة البدء بعد الانتهاء',
            value: repeatCycle,
            onChanged: onRepeatChanged,
          ),
        ],
      ),
    );
  }
}

class _CompactSwitchTile extends StatelessWidget {
  const _CompactSwitchTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final HugeIconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
      value: value,
      onChanged: onChanged,
      secondary: AppIcon(
        icon,
        size: 15.sp,
        color: value ? context.primaryColor : context.onSurfaceVariant,
        strokeWidth: 1.55,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: context.onSurfaceColor,
          fontSize: 11.5.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _BatteryPanel extends StatelessWidget {
  const _BatteryPanel({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _SoftPanel(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          AppIcon(
            AppIcons.battery,
            size: 16.sp,
            color: context.primaryColor,
            strokeWidth: 1.55,
          ),
          SizedBox(width: 9.w),
          Expanded(
            child: Text(
              'إذا توقفت القوائم في الخلفية، اسمح للتطبيق من إعدادات البطارية.',
              style: TextStyle(
                color: context.onSurfaceVariant,
                fontSize: 10.sp,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          _SmallButton(label: 'فتح', onTap: onTap),
        ],
      ),
    );
  }
}

class _PrimaryAction extends StatelessWidget {
  const _PrimaryAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final HugeIconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: context.primaryColor,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(
              icon,
              color: context.onPrimaryColor,
              size: 14.sp,
              strokeWidth: 1.55,
            ),
            SizedBox(width: 7.w),
            Text(
              label,
              style: TextStyle(
                color: context.onPrimaryColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  const _SmallButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: context.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: context.primaryColor,
            fontSize: 10.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({required this.icon});

  final HugeIconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(13.r),
      ),
      child: AppIcon(
        icon,
        color: context.primaryColor,
        size: 17.sp,
        strokeWidth: 1.55,
      ),
    );
  }
}

class _SoftPanel extends StatelessWidget {
  const _SoftPanel({
    required this.child,
    required this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(color: context.outlineVariant.withValues(alpha: 0.25)),
      ),
      child: child,
    );
  }
}
