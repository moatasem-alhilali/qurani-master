import 'dart:ui' as ui;

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_calculation_settings.dart';

/// إعدادات حساب المواقيت: طريقة الحساب والمذهب وخطوط العرض العالية
/// وتعديل رمضان والتعديلات اليدوية لكل وقت.
///
/// لا بطاقة حول المجموعة ولا حول كل حقل: صفوف نحيلة على أرضية الصفحة،
/// تفصلها خطوط شعرة، وعناوين مجموعات صغيرة بينها.
class PrayerCalculationSettingsCard extends StatefulWidget {
  const PrayerCalculationSettingsCard({
    required this.settings,
    required this.onChanged,
    super.key,
    this.isSaving = false,
  });

  final PrayerCalculationSettings settings;
  final ValueChanged<PrayerCalculationSettings> onChanged;
  final bool isSaving;

  @override
  State<PrayerCalculationSettingsCard> createState() =>
      _PrayerCalculationSettingsCardState();
}

class _PrayerCalculationSettingsCardState
    extends State<PrayerCalculationSettingsCard> {
  bool _showAdjustments = false;

  PrayerCalculationSettings get _settings => widget.settings;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
          child: Text(
            'اختر التقويم الذي تعتمده جهتك المحلية، وعدّل المواقيت يدويًا '
            'إن احتجت مطابقتها مع مسجد الحي.',
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.78),
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w500,
              height: 1.45,
            ),
          ),
        ),
        PrayerSettingsPickerRow(
          icon: AppIcons.mosque,
          label: 'طريقة الحساب',
          value: _settings.method.arabicLabel,
          hint: _settings.method.arabicDescription,
          enabled: !widget.isSaving,
          onTap: _pickMethod,
        ),
        PrayerSettingsSegmentedRow<Madhab>(
          icon: AppIcons.clock,
          label: 'مذهب حساب العصر',
          hint: _settings.madhab.arabicDescription,
          value: _settings.madhab,
          options: Madhab.values,
          labelOf: (madhab) => madhab == Madhab.shafi ? 'الشافعي' : 'الحنفي',
          enabled: !widget.isSaving,
          onChanged: (madhab) => _emit(_settings.copyWith(madhab: madhab)),
        ),
        if (_settings.isCustomMethod) ..._customAnglesSection(),
        PrayerSettingsPickerRow(
          icon: AppIcons.globe,
          label: 'خطوط العرض العالية',
          value: _settings.effectiveHighLatitudeOption.label,
          hint: _settings.effectiveHighLatitudeOption.description,
          enabled: !widget.isSaving,
          onTap: _pickHighLatitudeRule,
        ),
        if (_settings.supportsRamadanIshaAdjustment)
          PrayerSettingsSwitchRow(
            icon: AppIcons.moon,
            label: 'تأخير العشاء في رمضان',
            hint: 'يضيف ٣٠ دقيقة على العشاء طوال الشهر '
                'كما في تقويم أم القرى.',
            value: _settings.ramadanIshaAdjustmentEnabled,
            enabled: !widget.isSaving,
            onChanged: (value) => _emit(
              _settings.copyWith(ramadanIshaAdjustmentEnabled: value),
            ),
          ),
        ..._adjustmentsSection(),
        if (!_settings.isDefault)
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: PrayerSettingsTextLink(
                label: 'استعادة إعدادات أم القرى',
                icon: AppIcons.refresh,
                onTap: widget.isSaving
                    ? null
                    : () => _emit(PrayerCalculationSettings.defaults),
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> _customAnglesSection() {
    final custom = _settings.customAngles;
    final maghribAngle = custom.maghribAngle;

    return [
      const PrayerSettingsGroupTitle(title: 'زوايا الحساب المخصصة'),
      PrayerSettingsStepperRow(
        label: 'زاوية الفجر',
        display: '${_formatAngle(custom.fajrAngle)}°',
        canDecrease:
            !widget.isSaving && custom.fajrAngle > PrayerCustomAngles.minAngle,
        canIncrease:
            !widget.isSaving && custom.fajrAngle < PrayerCustomAngles.maxAngle,
        onDecrease: () => _emitCustom(
          custom.copyWith(
            fajrAngle: custom.fajrAngle - PrayerCustomAngles.angleStep,
          ),
        ),
        onIncrease: () => _emitCustom(
          custom.copyWith(
            fajrAngle: custom.fajrAngle + PrayerCustomAngles.angleStep,
          ),
        ),
      ),
      PrayerSettingsSegmentedRow<PrayerIshaMode>(
        icon: AppIcons.sun,
        label: 'حساب العشاء',
        hint: 'إمّا بزاوية الشفق، وإمّا بفاصل ثابت بعد المغرب.',
        value: custom.ishaMode,
        options: PrayerIshaMode.values,
        labelOf: (mode) => 'العشاء بـ${mode.label}',
        enabled: !widget.isSaving,
        onChanged: (mode) => _emitCustom(custom.copyWith(ishaMode: mode)),
      ),
      if (custom.ishaMode == PrayerIshaMode.angle)
        PrayerSettingsStepperRow(
          label: 'زاوية العشاء',
          display: '${_formatAngle(custom.ishaAngle)}°',
          canDecrease: !widget.isSaving &&
              custom.ishaAngle > PrayerCustomAngles.minAngle,
          canIncrease: !widget.isSaving &&
              custom.ishaAngle < PrayerCustomAngles.maxAngle,
          onDecrease: () => _emitCustom(
            custom.copyWith(
              ishaAngle: custom.ishaAngle - PrayerCustomAngles.angleStep,
            ),
          ),
          onIncrease: () => _emitCustom(
            custom.copyWith(
              ishaAngle: custom.ishaAngle + PrayerCustomAngles.angleStep,
            ),
          ),
        )
      else
        PrayerSettingsStepperRow(
          label: 'العشاء بعد المغرب',
          display: '${custom.ishaInterval} د',
          canDecrease: !widget.isSaving &&
              custom.ishaInterval > PrayerCustomAngles.minIshaInterval,
          canIncrease: !widget.isSaving &&
              custom.ishaInterval < PrayerCustomAngles.maxIshaInterval,
          onDecrease: () => _emitCustom(
            custom.copyWith(
              ishaInterval:
                  custom.ishaInterval - PrayerCustomAngles.ishaIntervalStep,
            ),
          ),
          onIncrease: () => _emitCustom(
            custom.copyWith(
              ishaInterval:
                  custom.ishaInterval + PrayerCustomAngles.ishaIntervalStep,
            ),
          ),
        ),
      PrayerSettingsSwitchRow(
        icon: AppIcons.sunset,
        label: 'زاوية المغرب بدل الغروب',
        hint: 'لِمن يعتمد زاوية شفق للمغرب بدل لحظة الغروب.',
        value: maghribAngle != null,
        enabled: !widget.isSaving,
        onChanged: (enabled) => _emitCustom(
          enabled
              ? custom.copyWith(
                  maghribAngle: PrayerCustomAngles.minMaghribAngle,
                )
              : custom.copyWith(clearMaghribAngle: true),
        ),
      ),
      if (maghribAngle != null)
        PrayerSettingsStepperRow(
          label: 'زاوية المغرب',
          display: '${_formatAngle(maghribAngle)}°',
          canDecrease: !widget.isSaving &&
              maghribAngle > PrayerCustomAngles.minMaghribAngle,
          canIncrease: !widget.isSaving &&
              maghribAngle < PrayerCustomAngles.maxMaghribAngle,
          onDecrease: () => _emitCustom(
            custom.copyWith(
              maghribAngle: maghribAngle - PrayerCustomAngles.angleStep,
            ),
          ),
          onIncrease: () => _emitCustom(
            custom.copyWith(
              maghribAngle: maghribAngle + PrayerCustomAngles.angleStep,
            ),
          ),
        ),
    ];
  }

  String _formatAngle(double value) =>
      value == value.roundToDouble() ? '${value.toInt()}' : '$value';

  List<Widget> _adjustmentsSection() {
    final adjustments = _settings.adjustments;
    final activeCount = [
      adjustments.fajr,
      adjustments.sunrise,
      adjustments.dhuhr,
      adjustments.asr,
      adjustments.maghrib,
      adjustments.isha,
    ].where((value) => value != 0).length;

    return [
      _AdjustmentsToggleRow(
        isOpen: _showAdjustments,
        activeCount: activeCount,
        enabled: !widget.isSaving,
        onTap: () => setState(() => _showAdjustments = !_showAdjustments),
      ),
      if (_showAdjustments) ...[
        _adjustmentRow(
          'الفجر',
          adjustments.fajr,
          (value) => _emitAdjustments(adjustments.copyWith(fajr: value)),
        ),
        _adjustmentRow(
          'الشروق',
          adjustments.sunrise,
          (value) => _emitAdjustments(adjustments.copyWith(sunrise: value)),
        ),
        _adjustmentRow(
          'الظهر',
          adjustments.dhuhr,
          (value) => _emitAdjustments(adjustments.copyWith(dhuhr: value)),
        ),
        _adjustmentRow(
          'العصر',
          adjustments.asr,
          (value) => _emitAdjustments(adjustments.copyWith(asr: value)),
        ),
        _adjustmentRow(
          'المغرب',
          adjustments.maghrib,
          (value) => _emitAdjustments(adjustments.copyWith(maghrib: value)),
        ),
        _adjustmentRow(
          'العشاء',
          adjustments.isha,
          (value) => _emitAdjustments(adjustments.copyWith(isha: value)),
        ),
      ],
    ];
  }

  Widget _adjustmentRow(String label, int value, ValueChanged<int> onChanged) {
    const max = PrayerManualAdjustments.maxMinutes;

    return PrayerSettingsStepperRow(
      label: label,
      display: _formatMinutes(value),
      isNeutral: value == 0,
      canDecrease: !widget.isSaving && value > -max,
      canIncrease: !widget.isSaving && value < max,
      onDecrease: () => onChanged(value - 1),
      onIncrease: () => onChanged(value + 1),
    );
  }

  String _formatMinutes(int value) {
    if (value == 0) return '٠ د';
    final sign = value > 0 ? '+' : '-';
    return '$sign${value.abs()} د';
  }

  void _emit(PrayerCalculationSettings settings) => widget.onChanged(settings);

  void _emitAdjustments(PrayerManualAdjustments adjustments) =>
      _emit(_settings.copyWith(adjustments: adjustments.clamped()));

  void _emitCustom(PrayerCustomAngles custom) =>
      _emit(_settings.copyWith(customAngles: custom.clamped()));

  Future<void> _pickMethod() async {
    final selected = await showPrayerSettingsOptionsSheet<CalculationMethod>(
      context: context,
      title: 'طريقة الحساب',
      options: PrayerCalculationMethodLabels.selectable,
      selected: _settings.method,
      labelOf: (method) => method.arabicLabel,
      descriptionOf: (method) => method.arabicDescription,
    );
    if (selected == null || selected == _settings.method) {
      return;
    }

    var updated = _settings.copyWith(method: selected);
    // بعض الطرق لا تدعم "زاوية الشفق"، فنُرجع الخيار للتلقائي بدل ترك
    // إعداد معروض لا يُطبَّق فعليًا.
    if (!updated.supportsTwilightAngleRule) {
      updated = updated.copyWith(
        highLatitudeOption: updated.effectiveHighLatitudeOption,
      );
    }
    _emit(updated);
  }

  Future<void> _pickHighLatitudeRule() async {
    final selected =
        await showPrayerSettingsOptionsSheet<PrayerHighLatitudeOption>(
      context: context,
      title: 'خطوط العرض العالية',
      options: _settings.availableHighLatitudeOptions,
      selected: _settings.effectiveHighLatitudeOption,
      labelOf: (option) => option.label,
      descriptionOf: (option) => option.description,
    );
    if (selected != null && selected != _settings.highLatitudeOption) {
      _emit(_settings.copyWith(highLatitudeOption: selected));
    }
  }
}

/// ورقة اختيار: صفوف نحيلة على أرضية الصفحة، والمختار يحمل علامة فقط.
Future<T?> showPrayerSettingsOptionsSheet<T>({
  required BuildContext context,
  required String title,
  required List<T> options,
  required T selected,
  required String Function(T) labelOf,
  required String Function(T) descriptionOf,
}) {
  final skin = AppSkin.of(context);

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: skin.ground,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.75,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 9.h),
              Container(
                width: 34.w,
                height: 3.h,
                decoration: BoxDecoration(
                  color: skin.hairline,
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: skin.ink,
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, thickness: 1, color: skin.hairline),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
                  itemCount: options.length,
                  itemBuilder: (_, index) {
                    final option = options[index];
                    return _OptionRow(
                      label: labelOf(option),
                      description: descriptionOf(option),
                      isSelected: option == selected,
                      isLast: index == options.length - 1,
                      onTap: () => Navigator.of(sheetContext).pop(option),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// صفّ يفتح ورقة اختيار: العنوان ووصفه، والقيمة المختارة عند الحافة.
class PrayerSettingsPickerRow extends StatelessWidget {
  const PrayerSettingsPickerRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.hint,
    required this.enabled,
    required this.onTap,
    super.key,
  });

  final HugeIconData icon;
  final String label;
  final String value;
  final String hint;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: enabled ? onTap : null,
      child: _RowFrame(
        child: Row(
          children: [
            PrayerSettingsIconChip(icon: icon),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.ink,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    hint,
                    maxLines: 2,
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
            SizedBox(width: 8.w),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 108.w),
              child: Text(
                value,
                maxLines: 2,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: skin.accent,
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
            ),
            AppIcon(AppIcons.chevronLeft, color: skin.accent, size: 15.sp),
          ],
        ),
      ),
    );
  }
}

/// صفّ خيارين: العنوان ووصفه، ثم زرّان يمتلئان ذهبًا عند الاختيار.
class PrayerSettingsSegmentedRow<T> extends StatelessWidget {
  const PrayerSettingsSegmentedRow({
    required this.icon,
    required this.label,
    required this.hint,
    required this.value,
    required this.options,
    required this.labelOf,
    required this.enabled,
    required this.onChanged,
    super.key,
  });

  final HugeIconData icon;
  final String label;
  final String hint;
  final T value;
  final List<T> options;
  final String Function(T) labelOf;
  final bool enabled;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return _RowFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              PrayerSettingsIconChip(icon: icon),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: skin.ink,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      hint,
                      maxLines: 2,
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
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              for (var i = 0; i < options.length; i++) ...[
                if (i != 0) SizedBox(width: 6.w),
                Expanded(
                  child: _SegmentButton(
                    label: labelOf(options[i]),
                    isSelected: options[i] == value,
                    enabled: enabled,
                    onTap: () => onChanged(options[i]),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// صفّ مفتاح: العنوان ووصفه ومفتاح النظام.
class PrayerSettingsSwitchRow extends StatelessWidget {
  const PrayerSettingsSwitchRow({
    required this.icon,
    required this.label,
    required this.hint,
    required this.value,
    required this.enabled,
    required this.onChanged,
    super.key,
  });

  final HugeIconData icon;
  final String label;
  final String hint;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return _RowFrame(
      child: Row(
        children: [
          PrayerSettingsIconChip(icon: icon),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                Text(
                  hint,
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
          SizedBox(width: 6.w),
          Transform.scale(
            scale: 0.82,
            child: Switch.adaptive(
              value: value,
              onChanged: enabled
                  ? (next) {
                      HapticFeedback.selectionClick();
                      onChanged(next);
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

/// صفّ قيمة برقم يتغيّر بزرّي نقصان وزيادة.
class PrayerSettingsStepperRow extends StatelessWidget {
  const PrayerSettingsStepperRow({
    required this.label,
    required this.display,
    required this.canDecrease,
    required this.canIncrease,
    required this.onDecrease,
    required this.onIncrease,
    this.isNeutral = false,
    super.key,
  });

  final String label;
  final String display;
  final bool canDecrease;
  final bool canIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  /// القيمة صفر: تُعرض بلون ثانوي حتى يبرز المعدَّل فعلًا.
  final bool isNeutral;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return _RowFrame(
      verticalPadding: 7.h,
      child: Row(
        children: [
          SizedBox(width: 38.w),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: skin.ink,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.remove_rounded,
            enabled: canDecrease,
            onTap: onDecrease,
          ),
          SizedBox(
            width: 54.w,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                display,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isNeutral
                      ? skin.inkSoft.withValues(alpha: 0.7)
                      : skin.accent,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w600,
                  fontFeatures: const [ui.FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add_rounded,
            enabled: canIncrease,
            onTap: onIncrease,
          ),
        ],
      ),
    );
  }
}

/// عنوان مجموعة صغير يليه خطّ شعرة إلى آخر السطر.
class PrayerSettingsGroupTitle extends StatelessWidget {
  const PrayerSettingsGroupTitle({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 7.h),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.8),
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Divider(height: 1, thickness: 1, color: skin.hairline),
          ),
        ],
      ),
    );
  }
}

/// رابط نصّي بأيقونة صغيرة — بديل الزرّ المحدَّد بإطار.
class PrayerSettingsTextLink extends StatelessWidget {
  const PrayerSettingsTextLink({
    required this.label,
    required this.onTap,
    this.icon,
    super.key,
  });

  final String label;
  final HugeIconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final color =
        onTap == null ? skin.inkSoft.withValues(alpha: 0.45) : skin.accent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              AppIcon(icon!, color: color, size: 14.sp),
              SizedBox(width: 5.w),
            ],
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// مربّع الأيقونة الصغير — بديل البطاقة حول الصفّ.
class PrayerSettingsIconChip extends StatelessWidget {
  const PrayerSettingsIconChip({required this.icon, super.key});

  final HugeIconData icon;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      width: 28.w,
      height: 28.w,
      decoration: BoxDecoration(
        color: skin.iconChip,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: AppIcon(icon, color: skin.accent, size: 15.sp),
      ),
    );
  }
}

/// إطار الصفّ: حشو موحّد وفاصل شعرة أسفله.
class _RowFrame extends StatelessWidget {
  const _RowFrame({required this.child, this.verticalPadding});

  final Widget child;
  final double? verticalPadding;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: skin.hairline)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: verticalPadding ?? 10.h,
      ),
      child: child,
    );
  }
}

class _AdjustmentsToggleRow extends StatelessWidget {
  const _AdjustmentsToggleRow({
    required this.isOpen,
    required this.activeCount,
    required this.enabled,
    required this.onTap,
  });

  final bool isOpen;
  final int activeCount;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: enabled ? onTap : null,
      child: _RowFrame(
        child: Row(
          children: [
            const PrayerSettingsIconChip(icon: AppIcons.clock),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'تعديل يدوي لكل وقت',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.ink,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    activeCount == 0
                        ? 'طابق المواقيت مع مسجد الحي دقيقة بدقيقة'
                        : '$activeCount من المواقيت معدّلة يدويًا',
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
            AppIcon(
              isOpen ? AppIcons.up : AppIcons.down,
              color: skin.accent,
              size: 15.sp,
            ),
          ],
        ),
      ),
    );
  }
}

/// زرّ ضمن مجموعة خيارين: يمتلئ ذهبًا عند الاختيار مع نبضة خفيفة.
class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.isSelected,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final radius = BorderRadius.circular(10.r);

    return InkWell(
      onTap: enabled
          ? () {
              HapticFeedback.selectionClick();
              onTap();
            }
          : null,
      borderRadius: radius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        height: 32.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold : Colors.transparent,
          borderRadius: radius,
          border: Border.all(
            color: isSelected ? AppColors.gold : skin.hairline,
          ),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isSelected
                ? AppColors.brandIvory
                : skin.ink.withValues(alpha: enabled ? 0.88 : 0.45),
            fontSize: 9.5.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
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
      onTap: enabled
          ? () {
              HapticFeedback.selectionClick();
              onTap();
            }
          : null,
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

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.label,
    required this.description,
    required this.isSelected,
    required this.isLast,
    required this.onTap,
  });

  final String label;
  final String description;
  final bool isSelected;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        padding: EdgeInsets.symmetric(vertical: 11.h),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? skin.accent : skin.ink,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    description,
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
            if (isSelected) ...[
              SizedBox(width: 8.w),
              AppIcon(AppIcons.check, color: skin.accent, size: 16.sp),
            ],
          ],
        ),
      ),
    );
  }
}
