import 'dart:ui' as ui;

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_calculation_settings.dart';

part 'prayer_calculation_settings_rows_part.dart';
part 'prayer_calculation_settings_atoms_part.dart';

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
