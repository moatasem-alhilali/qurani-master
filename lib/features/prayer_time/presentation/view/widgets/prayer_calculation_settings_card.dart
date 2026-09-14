import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_calculation_settings.dart';

/// بطاقة إعدادات حساب المواقيت: طريقة الحساب والمذهب وخطوط العرض العالية
/// وتعديل رمضان والتعديلات اليدوية لكل وقت.
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
    return Container(
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(
          color: context.primaryColor.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: context.shadow.withValues(alpha: 0.035),
            blurRadius: 10.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(context),
          SizedBox(height: 12.h),
          _PickerTile(
            icon: AppIcons.mosque,
            label: 'طريقة الحساب',
            value: _settings.method.arabicLabel,
            hint: _settings.method.arabicDescription,
            enabled: !widget.isSaving,
            onTap: _pickMethod,
          ),
          SizedBox(height: 10.h),
          _SegmentedField<Madhab>(
            icon: AppIcons.clock,
            label: 'مذهب حساب العصر',
            hint: _settings.madhab.arabicDescription,
            value: _settings.madhab,
            options: Madhab.values,
            labelOf: (madhab) =>
                madhab == Madhab.shafi ? 'الجمهور' : 'الحنفي',
            enabled: !widget.isSaving,
            onChanged: (madhab) => _emit(_settings.copyWith(madhab: madhab)),
          ),
          if (_settings.isCustomMethod) ...[
            SizedBox(height: 10.h),
            _customAnglesSection(context),
          ],
          SizedBox(height: 10.h),
          _PickerTile(
            icon: AppIcons.globe,
            label: 'خطوط العرض العالية',
            value: _settings.effectiveHighLatitudeOption.label,
            hint: _settings.effectiveHighLatitudeOption.description,
            enabled: !widget.isSaving,
            onTap: _pickHighLatitudeRule,
          ),
          if (_settings.supportsRamadanIshaAdjustment) ...[
            SizedBox(height: 10.h),
            _SwitchField(
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
          ],
          SizedBox(height: 10.h),
          _adjustmentsSection(context),
          if (!_settings.isDefault) ...[
            SizedBox(height: 10.h),
            _resetButton(context),
          ],
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        _IconBadge(icon: AppIcons.sliders, color: context.primaryColor),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'طريقة حساب المواقيت',
                style: TextStyle(
                  color: context.onSurfaceColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'اختر التقويم الذي تعتمده جهتك المحلية، وعدّل المواقيت يدويًا '
                'إن احتجت مطابقتها مع مسجد الحي.',
                style: TextStyle(
                  color: context.onSurfaceVariant,
                  fontSize: 10.sp,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _customAnglesSection(BuildContext context) {
    final custom = _settings.customAngles;
    final maghribAngle = custom.maghribAngle;

    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: context.primaryColor.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppIcon(
                AppIcons.sun,
                size: 15.sp,
                color: context.primaryColor,
                strokeWidth: 1.55,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'زوايا الحساب المخصصة',
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          _ValueStepperRow(
            label: 'زاوية الفجر',
            display: '${_formatAngle(custom.fajrAngle)}°',
            canDecrease: !widget.isSaving &&
                custom.fajrAngle > PrayerCustomAngles.minAngle,
            canIncrease: !widget.isSaving &&
                custom.fajrAngle < PrayerCustomAngles.maxAngle,
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
          SizedBox(height: 8.h),
          Row(
            children: [
              for (final mode in PrayerIshaMode.values) ...[
                Expanded(
                  child: _SegmentButton(
                    label: 'العشاء بـ${mode.label}',
                    isSelected: custom.ishaMode == mode,
                    enabled: !widget.isSaving,
                    onTap: () => _emitCustom(custom.copyWith(ishaMode: mode)),
                  ),
                ),
                if (mode != PrayerIshaMode.values.last) SizedBox(width: 8.w),
              ],
            ],
          ),
          if (custom.ishaMode == PrayerIshaMode.angle)
            _ValueStepperRow(
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
            _ValueStepperRow(
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
          SizedBox(height: 6.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  'زاوية المغرب بدل الغروب',
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Switch.adaptive(
                value: maghribAngle != null,
                onChanged: widget.isSaving
                    ? null
                    : (enabled) => _emitCustom(
                          enabled
                              ? custom.copyWith(
                                  maghribAngle:
                                      PrayerCustomAngles.minMaghribAngle,
                                )
                              : custom.copyWith(clearMaghribAngle: true),
                        ),
              ),
            ],
          ),
          if (maghribAngle != null)
            _ValueStepperRow(
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
        ],
      ),
    );
  }

  String _formatAngle(double value) =>
      value == value.roundToDouble() ? '${value.toInt()}' : '$value';

  Widget _adjustmentsSection(BuildContext context) {
    final adjustments = _settings.adjustments;
    final activeCount = [
      adjustments.fajr,
      adjustments.sunrise,
      adjustments.dhuhr,
      adjustments.asr,
      adjustments.maghrib,
      adjustments.isha,
    ].where((value) => value != 0).length;

    return Container(
      decoration: BoxDecoration(
        color: context.surfaceVariant.withValues(alpha: 0.24),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: context.outlineVariant.withValues(alpha: 0.24),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14.r),
            onTap: widget.isSaving
                ? null
                : () => setState(() => _showAdjustments = !_showAdjustments),
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Row(
                children: [
                  AppIcon(
                    AppIcons.clock,
                    size: 15.sp,
                    color: context.primaryColor,
                    strokeWidth: 1.55,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'تعديل يدوي لكل وقت',
                      style: TextStyle(
                        color: context.onSurfaceColor,
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (activeCount > 0)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 7.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '$activeCount معدّل',
                        style: TextStyle(
                          color: context.primaryColor,
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  SizedBox(width: 6.w),
                  AppIcon(
                    _showAdjustments ? AppIcons.up : AppIcons.down,
                    size: 14.sp,
                    color: context.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          if (_showAdjustments)
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.h),
              child: Column(
                children: [
                  _AdjustmentRow(
                    label: 'الفجر',
                    value: adjustments.fajr,
                    enabled: !widget.isSaving,
                    onChanged: (value) => _emitAdjustments(
                      adjustments.copyWith(fajr: value),
                    ),
                  ),
                  _AdjustmentRow(
                    label: 'الشروق',
                    value: adjustments.sunrise,
                    enabled: !widget.isSaving,
                    onChanged: (value) => _emitAdjustments(
                      adjustments.copyWith(sunrise: value),
                    ),
                  ),
                  _AdjustmentRow(
                    label: 'الظهر',
                    value: adjustments.dhuhr,
                    enabled: !widget.isSaving,
                    onChanged: (value) => _emitAdjustments(
                      adjustments.copyWith(dhuhr: value),
                    ),
                  ),
                  _AdjustmentRow(
                    label: 'العصر',
                    value: adjustments.asr,
                    enabled: !widget.isSaving,
                    onChanged: (value) => _emitAdjustments(
                      adjustments.copyWith(asr: value),
                    ),
                  ),
                  _AdjustmentRow(
                    label: 'المغرب',
                    value: adjustments.maghrib,
                    enabled: !widget.isSaving,
                    onChanged: (value) => _emitAdjustments(
                      adjustments.copyWith(maghrib: value),
                    ),
                  ),
                  _AdjustmentRow(
                    label: 'العشاء',
                    value: adjustments.isha,
                    enabled: !widget.isSaving,
                    onChanged: (value) => _emitAdjustments(
                      adjustments.copyWith(isha: value),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _resetButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: widget.isSaving
          ? null
          : () => _emit(PrayerCalculationSettings.defaults),
      style: OutlinedButton.styleFrom(
        minimumSize: Size.fromHeight(36.h),
        side: BorderSide(
          color: context.primaryColor.withValues(alpha: 0.25),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13.r),
        ),
      ),
      icon: const AppIcon(AppIcons.refresh, size: 13),
      label: Text(
        'استعادة إعدادات أم القرى',
        style: TextStyle(
          fontSize: 11.5.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  void _emit(PrayerCalculationSettings settings) => widget.onChanged(settings);

  void _emitAdjustments(PrayerManualAdjustments adjustments) =>
      _emit(_settings.copyWith(adjustments: adjustments.clamped()));

  void _emitCustom(PrayerCustomAngles custom) =>
      _emit(_settings.copyWith(customAngles: custom.clamped()));

  Future<void> _pickMethod() async {
    final selected = await _showOptionsSheet<CalculationMethod>(
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
    final selected = await _showOptionsSheet<PrayerHighLatitudeOption>(
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

  Future<T?> _showOptionsSheet<T>({
    required String title,
    required List<T> options,
    required T selected,
    required String Function(T) labelOf,
    required String Function(T) descriptionOf,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
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
                SizedBox(height: 10.h),
                Container(
                  width: 38.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: sheetContext.outlineVariant.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  title,
                  style: TextStyle(
                    color: sheetContext.onSurfaceColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 10.h),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.fromLTRB(14.w, 4.h, 14.w, 14.h),
                    itemCount: options.length,
                    separatorBuilder: (_, __) => SizedBox(height: 8.h),
                    itemBuilder: (_, index) {
                      final option = options[index];
                      final isSelected = option == selected;
                      return _OptionRow(
                        label: labelOf(option),
                        description: descriptionOf(option),
                        isSelected: isSelected,
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
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.hint,
    required this.enabled,
    required this.onTap,
  });

  final HugeIconData icon;
  final String label;
  final String value;
  final String hint;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: enabled ? onTap : null,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: context.surfaceVariant.withValues(alpha: 0.24),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: context.outlineVariant.withValues(alpha: 0.24),
          ),
        ),
        child: Row(
          children: [
            AppIcon(
              icon,
              size: 15.sp,
              color: context.primaryColor,
              strokeWidth: 1.55,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: context.onSurfaceVariant,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value,
                    style: TextStyle(
                      color: context.onSurfaceColor,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    hint,
                    style: TextStyle(
                      color: context.onSurfaceVariant,
                      fontSize: 9.5.sp,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            AppIcon(
              AppIcons.down,
              size: 14.sp,
              color: context.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentedField<T> extends StatelessWidget {
  const _SegmentedField({
    required this.icon,
    required this.label,
    required this.hint,
    required this.value,
    required this.options,
    required this.labelOf,
    required this.enabled,
    required this.onChanged,
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
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: context.surfaceVariant.withValues(alpha: 0.24),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: context.outlineVariant.withValues(alpha: 0.24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppIcon(
                icon,
                size: 15.sp,
                color: context.primaryColor,
                strokeWidth: 1.55,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              for (final option in options) ...[
                Expanded(
                  child: _SegmentButton(
                    label: labelOf(option),
                    isSelected: option == value,
                    enabled: enabled,
                    onTap: () => onChanged(option),
                  ),
                ),
                if (option != options.last) SizedBox(width: 8.w),
              ],
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            hint,
            style: TextStyle(
              color: context.onSurfaceVariant,
              fontSize: 9.5.sp,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

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
    return InkWell(
      borderRadius: BorderRadius.circular(11.r),
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.symmetric(vertical: 9.h),
        decoration: BoxDecoration(
          color: isSelected
              ? context.primaryColor.withValues(alpha: 0.13)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(11.r),
          border: Border.all(
            color: isSelected
                ? context.primaryColor.withValues(alpha: 0.45)
                : context.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? context.primaryColor : context.onSurfaceColor,
              fontSize: 11.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _SwitchField extends StatelessWidget {
  const _SwitchField({
    required this.icon,
    required this.label,
    required this.hint,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final HugeIconData icon;
  final String label;
  final String hint;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: context.surfaceVariant.withValues(alpha: 0.24),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: context.outlineVariant.withValues(alpha: 0.24),
        ),
      ),
      child: Row(
        children: [
          AppIcon(
            icon,
            size: 15.sp,
            color: context.primaryColor,
            strokeWidth: 1.55,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  hint,
                  style: TextStyle(
                    color: context.onSurfaceVariant,
                    fontSize: 9.5.sp,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: enabled ? onChanged : null,
          ),
        ],
      ),
    );
  }
}

class _AdjustmentRow extends StatelessWidget {
  const _AdjustmentRow({
    required this.label,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final String label;
  final int value;
  final bool enabled;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const max = PrayerManualAdjustments.maxMinutes;
    final canDecrease = enabled && value > -max;
    final canIncrease = enabled && value < max;

    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: context.onSurfaceColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.remove_rounded,
            enabled: canDecrease,
            onTap: () => onChanged(value - 1),
          ),
          SizedBox(
            width: 54.w,
            child: Text(
              _formatMinutes(value),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: value == 0
                    ? context.onSurfaceVariant
                    : context.primaryColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add_rounded,
            enabled: canIncrease,
            onTap: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }

  String _formatMinutes(int value) {
    if (value == 0) return '٠ د';
    final sign = value > 0 ? '+' : '-';
    return '$sign${value.abs()} د';
  }
}

/// صف قيمة مع زرّي زيادة ونقصان، يُستخدم لزوايا الحساب المخصصة.
class _ValueStepperRow extends StatelessWidget {
  const _ValueStepperRow({
    required this.label,
    required this.display,
    required this.canDecrease,
    required this.canIncrease,
    required this.onDecrease,
    required this.onIncrease,
  });

  final String label;
  final String display;
  final bool canDecrease;
  final bool canIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: context.onSurfaceColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.remove_rounded,
            enabled: canDecrease,
            onTap: onDecrease,
          ),
          SizedBox(
            width: 58.w,
            child: Text(
              display,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.primaryColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.w900,
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
    return InkWell(
      borderRadius: BorderRadius.circular(9.r),
      onTap: enabled ? onTap : null,
      child: Container(
        width: 28.w,
        height: 28.w,
        decoration: BoxDecoration(
          color: context.primaryColor.withValues(alpha: enabled ? 0.1 : 0.04),
          borderRadius: BorderRadius.circular(9.r),
        ),
        child: Icon(
          icon,
          size: 15.sp,
          color: enabled
              ? context.primaryColor
              : context.onSurfaceVariant.withValues(alpha: 0.4),
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
    required this.onTap,
  });

  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(11.w),
        decoration: BoxDecoration(
          color: isSelected
              ? context.primaryColor.withValues(alpha: 0.09)
              : context.surfaceVariant.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected
                ? context.primaryColor.withValues(alpha: 0.45)
                : context.outlineVariant.withValues(alpha: 0.22),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: context.onSurfaceColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    description,
                    style: TextStyle(
                      color: context.onSurfaceVariant,
                      fontSize: 10.sp,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              AppIcon(
                AppIcons.check,
                size: 17.sp,
                color: context.primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    required this.color,
  });

  final HugeIconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: AppIcon(
          icon,
          size: 18.sp,
          color: color,
          strokeWidth: 1.55,
        ),
      ),
    );
  }
}
