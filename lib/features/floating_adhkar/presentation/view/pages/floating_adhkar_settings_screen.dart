import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/floating_adhkar/data/models/floating_adhkar_settings.dart';
import 'package:quran_app/features/floating_adhkar/presentation/bloc/floating_adhkar_bloc.dart';
import 'package:quran_app/features/floating_adhkar/presentation/view/widgets/floating_adhkar_widgets.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:quran_app/features/thikr/presentation/view/widgets/library_screen_kit.dart';

/// إعدادات الأذكار العائمة.
///
/// ثلاثة صناديق ملوّنة صارت: مفتاحًا واحدًا مرتفعًا، ثم أقسامًا تفصلها
/// خطوط شعرة. رقائق الاختيار تمتلئ ذهبًا عند الاختيار بدل تبديل لونها.
class FloatingAdhkarSettingsScreen extends StatefulWidget {
  const FloatingAdhkarSettingsScreen({super.key});

  @override
  State<FloatingAdhkarSettingsScreen> createState() =>
      _FloatingAdhkarSettingsScreenState();
}

class _FloatingAdhkarSettingsScreenState
    extends State<FloatingAdhkarSettingsScreen> {
  static const List<int> _intervalOptions = [1, 5, 10, 15, 30, 45, 60, 90, 120];
  static const List<int> _visibleOptions = [10, 15, 20, 30, 45, 60];

  late FloatingAdhkarSettings _draft;

  @override
  void initState() {
    super.initState();
    final state = context.read<FloatingAdhkarBloc>().state;
    _draft = state.settings ?? FloatingAdhkarSettings.defaults();
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final isIosReminderMode =
        context.watch<FloatingAdhkarBloc>().state.usesIosReminders;

    return GroundScaffoldTheme(
      child: AppScaffoldWidget(
        title: isIosReminderMode
            ? 'إعدادات تذكيرات الأذكار'
            : 'إعدادات الأذكار العائمة',
        showLargeHeader: false,
        initialOffset: null,
        body: ColoredBox(
          color: skin.ground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MasterSwitch(
                enabled: _draft.enabled,
                isIosReminderMode: isIosReminderMode,
                onChanged: (value) {
                  unawaited(HapticFeedback.selectionClick());
                  setState(() => _draft = _draft.copyWith(enabled: value));
                },
              ),
              skin.divider(),
              HomeSectionHeader(
                title: isIosReminderMode ? 'توقيت التذكير' : 'توقيت الظهور',
              ),
              _OptionGroup(
                label: isIosReminderMode
                    ? 'معدل تكرار التنبيه'
                    : 'معدل تكرار الظهور',
                options: [
                  for (final value in _intervalOptions)
                    _Option(
                      label: formatFloatingInterval(value),
                      selected: _draft.intervalMinutes == value,
                      onTap: () {
                        unawaited(HapticFeedback.selectionClick());
                        setState(
                          () =>
                              _draft = _draft.copyWith(intervalMinutes: value),
                        );
                      },
                    ),
                ],
              ),
              if (!isIosReminderMode)
                _OptionGroup(
                  label: 'مدة بقاء الذكر',
                  options: [
                    for (final value in _visibleOptions)
                      _Option(
                        label: '$value ثانية',
                        selected: _draft.visibleSeconds == value,
                        onTap: () {
                          unawaited(HapticFeedback.selectionClick());
                          setState(
                            () =>
                                _draft = _draft.copyWith(visibleSeconds: value),
                          );
                        },
                      ),
                  ],
                ),
              skin.divider(),
              const HomeSectionHeader(title: 'مصادر الأذكار'),
              FloatingAdhkarSwitchRow(
                icon: AppIcons.tasbih,
                title: 'الأذكار الافتراضية',
                subtitle: 'المصدر الداخلي الأساسي للتطبيق',
                value: _draft.includeBuiltIn,
                onChanged: (value) {
                  unawaited(HapticFeedback.selectionClick());
                  setState(() {
                    _draft = _draft.copyWith(includeBuiltIn: value);
                  });
                },
              ),
              FloatingAdhkarSwitchRow(
                icon: AppIcons.bookOpen,
                title: 'أذكاري الخاصة',
                subtitle: 'الأذكار التي أضفتها بنفسك',
                value: _draft.includeCustom,
                isLast: !(_draft.includeBuiltIn && _draft.includeCustom),
                onChanged: (value) {
                  unawaited(HapticFeedback.selectionClick());
                  setState(() {
                    _draft = _draft.copyWith(includeCustom: value);
                  });
                },
              ),
              if (_draft.includeBuiltIn && _draft.includeCustom)
                FloatingAdhkarSwitchRow(
                  icon: AppIcons.layers,
                  title: 'الخلط بين المصادر',
                  subtitle: _draft.mixSources
                      ? 'يتم الاختيار من قائمة موحدة'
                      : 'يتم التناوب بين الافتراضي والمخصص',
                  value: _draft.mixSources,
                  isLast: true,
                  onChanged: (value) {
                    unawaited(HapticFeedback.selectionClick());
                    setState(() => _draft = _draft.copyWith(mixSources: value));
                  },
                ),
              SizedBox(height: 18.h),
              Padding(
                padding: AppSkin.gutter,
                child: _SaveButton(onPressed: _saveSettings),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  void _saveSettings() {
    if (!_draft.hasAnySource) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فعّل مصدرًا واحدًا على الأقل قبل الحفظ.'),
        ),
      );
      return;
    }

    unawaited(HapticFeedback.mediumImpact());
    context.read<FloatingAdhkarBloc>().add(
          FloatingAdhkarUpdateSettingsEvent(_draft),
        );
    Navigator.of(context).pop();
  }
}

/// مفتاح تشغيل الميزة: العنصر المرتفع الوحيد في الشاشة.
class _MasterSwitch extends StatelessWidget {
  const _MasterSwitch({
    required this.enabled,
    required this.isIosReminderMode,
    required this.onChanged,
  });

  final bool enabled;
  final bool isIosReminderMode;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 2.h, 16.w, 6.h),
      child: Container(
        decoration: BoxDecoration(
          color: skin.raised,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: skin.raisedBorder.withValues(alpha: 0.55),
          ),
          boxShadow: skin.raisedShadow,
        ),
        padding: EdgeInsets.fromLTRB(12.w, 8.h, 10.w, 8.h),
        child: Row(
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: skin.iconChip,
                borderRadius: BorderRadius.circular(11.r),
              ),
              child: Center(
                child: AppIcon(
                  AppIcons.power,
                  color: skin.accent,
                  size: 16.sp,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'تشغيل الميزة بالكامل',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.ink,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    isIosReminderMode
                        ? 'تُجدول تنبيهات أذكار على iPhone'
                        : 'تبدأ الخدمة الخلفية في إظهار الأذكار',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.inkSoft.withValues(alpha: 0.78),
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: enabled,
              activeTrackColor: AppColors.gold,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _Option {
  const _Option({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
}

/// مجموعة رقائق اختيار تحت عنوان صغير.
class _OptionGroup extends StatelessWidget {
  const _OptionGroup({required this.label, required this.options});

  final String label;
  final List<_Option> options;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.8),
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 7.h),
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: [
              for (final option in options) _OptionChip(option: option),
            ],
          ),
        ],
      ),
    );
  }
}

/// رقاقة اختيار: تمتلئ ذهبًا حين تُختار، لا تُبدَّل دفعة واحدة.
class _OptionChip extends StatelessWidget {
  const _OptionChip({required this.option});

  final _Option option;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final selected = option.selected;

    return InkWell(
      onTap: option.onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.gold : skin.iconChip,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: selected
                ? AppColors.gold
                : skin.hairline.withValues(alpha: 0.9),
          ),
        ),
        child: Text(
          option.label,
          style: TextStyle(
            color: selected
                ? (skin.isDark ? AppColors.brandNight : AppColors.brandIvory)
                : skin.inkSoft,
            fontSize: 10.sp,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// زرّ الحفظ — التعبئة الذهبية المسموح بها للفعل الرئيسي.
class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final onGold = skin.isDark ? AppColors.brandNight : AppColors.brandIvory;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12.r),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 11.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIcon(AppIcons.save, color: onGold, size: 15.sp),
              SizedBox(width: 7.w),
              Text(
                'حفظ الإعدادات',
                style: TextStyle(
                  color: onGold,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
