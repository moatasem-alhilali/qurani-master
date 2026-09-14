import 'dart:async';
import 'dart:io';

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/notification/notification_permissions_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/prayer_time/presentation/bloc/prayer_time_bloc.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_bundle_models.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_contact_model.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_enums.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_contacts_picker_service.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_settings_store.dart';
import 'package:quran_app/features/smart_outreach/presentation/bloc/smart_outreach_schedules_bloc.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/widgets/smart_outreach_phone_picker_sheet.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/widgets/smart_outreach_ui_kit.dart';

class SmartOutreachUpsertScheduleScreen extends StatefulWidget {
  const SmartOutreachUpsertScheduleScreen({
    this.initialBundle,
    super.key,
  });

  final SmartOutreachScheduleBundle? initialBundle;

  @override
  State<SmartOutreachUpsertScheduleScreen> createState() =>
      _SmartOutreachUpsertScheduleScreenState();
}

class _SmartOutreachUpsertScheduleScreenState
    extends State<SmartOutreachUpsertScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  final SmartOutreachContactsPickerService _contactsPickerService =
      sl<SmartOutreachContactsPickerService>();
  final SmartOutreachSettingsStore _settingsStore =
      sl<SmartOutreachSettingsStore>();

  late final TextEditingController _titleController;
  late TimeOfDay _selectedTime;
  late bool _isEnabled;
  late bool _isDaily;
  late List<int> _selectedDays;
  late int _ringTimeout;
  late int _hangupDelay;
  late int _delayBetweenCalls;
  late bool _stopOnFirstAnswered;
  late bool _retryEnabled;
  late bool _repeatCycle;
  bool _loadingDefaults = false;
  bool _showAdvancedSettings = false;

  final List<_EditablePhoneRow> _rows = <_EditablePhoneRow>[];

  bool get _isEditing => widget.initialBundle?.schedule.id != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialBundle;

    _titleController = TextEditingController(
      text: initial?.schedule.title ?? '',
    );
    _selectedTime = TimeOfDay(
      hour: initial?.schedule.hour ?? 8,
      minute: initial?.schedule.minute ?? 0,
    );
    _isEnabled = initial?.schedule.isEnabled ?? true;
    _isDaily = initial?.schedule.isDaily ?? true;
    _selectedDays =
        List<int>.from(initial?.schedule.scheduleDays ?? const <int>[]);
    _ringTimeout = initial?.schedule.ringTimeout ?? 20;
    _hangupDelay = initial?.schedule.hangupDelay ?? 30;
    _delayBetweenCalls = initial?.schedule.delayBetweenCalls ?? 3;
    _stopOnFirstAnswered = initial?.schedule.stopOnFirstAnswered ?? false;
    _retryEnabled = initial?.schedule.retryEnabled ?? false;
    _repeatCycle = initial?.schedule.repeatCycle ?? false;

    for (final contact
        in initial?.contacts ?? const <SmartOutreachContactModel>[]) {
      _rows.add(
        _EditablePhoneRow(
          id: contact.id,
          labelController: TextEditingController(text: contact.name ?? ''),
          phoneController: TextEditingController(text: contact.phone),
        ),
      );
    }

    if (_rows.isEmpty) {
      _loadDefaults();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _useFajrTime(silent: true);
      });
    }
  }

  Future<void> _loadDefaults() async {
    setState(() => _loadingDefaults = true);

    _ringTimeout = await _settingsStore.getDefaultRingTimeout();
    _hangupDelay = await _settingsStore.getDefaultHangupDelay();
    _delayBetweenCalls = await _settingsStore.getDefaultDelayBetweenCalls();
    _stopOnFirstAnswered = await _settingsStore.getDefaultStopOnFirstAnswered();
    _retryEnabled = await _settingsStore.getDefaultRetryEnabled();
    _repeatCycle = await _settingsStore.getDefaultRepeatCycle();

    if (!mounted) return;
    setState(() => _loadingDefaults = false);
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final row in _rows) {
      row.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fajrPrayer = _getFajrPrayer(context);

    return BlocListener<SmartOutreachSchedulesBloc,
        SmartOutreachSchedulesState>(
      listenWhen: (previous, current) =>
          previous.saveState != current.saveState ||
          previous.validationErrors != current.validationErrors,
      listener: (context, state) {
        if (state.validationErrors.isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.validationErrors.join('\n'))),
            );
          return;
        }

        if (state.saveState == RequestState.success) {
          Navigator.of(context).pop();
        }
      },
      child: AppScaffoldWidget(
        title: _isEditing ? 'تعديل القائمة' : 'قائمة جديدة',
        showLargeHeader: false,
        initialOffset: null,
        body: _loadingDefaults
            ? const OutreachLoading()
            : Form(
                key: _formKey,
                child: OutreachGround(
                  children: _buildSections(context, fajrPrayer),
                ),
              ),
      ),
    );
  }

  List<Widget> _buildSections(
    BuildContext context,
    PrayerInfoModel? fajrPrayer,
  ) {
    final skin = AppSkin.of(context);
    final fajrTime =
        fajrPrayer == null ? null : _formatPrayerTime(context, fajrPrayer);

    return <Widget>[
      const HomeSectionHeader(title: 'اسم القائمة'),
      // خطّ الحقل نفسه هو الفاصل هنا، فلا داعي لشعرة ثانية تحته.
      _TitleField(controller: _titleController),
      const HomeSectionHeader(title: 'وقت الاتصال'),
      OutreachRow(
        title: 'موعد البدء',
        icon: AppIcons.clock,
        subtitle: fajrTime == null
            ? 'اختر وقتًا يدويًا أو استعمل وقت الفجر'
            : 'وقت الفجر اليوم $fajrTime',
        trailing: OutreachValue(text: _selectedTime.format(context)),
        showChevron: true,
        isLast: true,
        onTap: _showTimeOptionsSheet,
      ),
      skin.divider(),
      HomeSectionHeader(
        title: 'جهات الاتصال · ${_rows.length}',
      ),
      ..._buildContactRows(),
      OutreachRow(
        title: 'اختيار من جهات الاتصال',
        icon: AppIcons.add,
        subtitle: 'أضف رقمًا جديدًا إلى هذه القائمة',
        isLast: true,
        onTap: _addFromContacts,
      ),
      skin.divider(),
      OutreachRow(
        title: 'إعدادات متقدمة',
        icon: AppIcons.sliders,
        subtitle: 'الأيام، مدد الانتظار، وسلوك التكرار',
        isLast: !_showAdvancedSettings,
        trailing: AppIcon(
          _showAdvancedSettings ? AppIcons.up : AppIcons.down,
          color: skin.accent,
          size: 15.sp,
        ),
        onTap: () {
          unawaited(HapticFeedback.selectionClick());
          setState(() {
            _showAdvancedSettings = !_showAdvancedSettings;
          });
        },
      ),
      if (_showAdvancedSettings) ..._buildAdvancedRows(),
      BlocBuilder<SmartOutreachSchedulesBloc, SmartOutreachSchedulesState>(
        builder: (context, state) {
          return OutreachPrimaryButton(
            label: state.saveState == RequestState.loading
                ? 'جارِ الحفظ...'
                : 'حفظ القائمة',
            icon: AppIcons.save,
            loading: state.saveState == RequestState.loading,
            onTap: _onSavePressed,
          );
        },
      ),
      SizedBox(height: 32.h),
    ];
  }

  List<Widget> _buildContactRows() {
    if (_rows.isEmpty) {
      return <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 2.h, 16.w, 10.h),
          child: Text(
            'لم تُضف أرقام بعد.',
            style: TextStyle(
              color: AppSkin.of(context).inkSoft.withValues(alpha: 0.78),
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ];
    }

    return <Widget>[
      for (final entry in _rows.asMap().entries)
        _ContactRow(
          name: entry.value.labelController.text.trim().isEmpty
              ? 'بدون اسم'
              : entry.value.labelController.text.trim(),
          phone: entry.value.phoneController.text,
          onRemove: () => _remove(entry.key),
        ),
    ];
  }

  List<Widget> _buildAdvancedRows() {
    return <Widget>[
      OutreachSwitchRow(
        title: 'تشغيل هذه القائمة',
        icon: AppIcons.power,
        value: _isEnabled,
        onChanged: (value) => setState(() => _isEnabled = value),
      ),
      OutreachSwitchRow(
        title: 'تكرار يومي',
        icon: AppIcons.calendar,
        subtitle: _isDaily ? 'كل يوم' : 'أيام مختارة من الأسبوع',
        value: _isDaily,
        onChanged: (value) => setState(() => _isDaily = value),
      ),
      if (!_isDaily) _buildDaysPicker(),
      OutreachSliderRow(
        label: 'مدة انتظار الرد',
        value: _ringTimeout.toDouble(),
        min: 5,
        max: 60,
        divisions: 55,
        valueLabel: '$_ringTimeout ث',
        onChanged: (value) => setState(() => _ringTimeout = value.round()),
      ),
      OutreachSliderRow(
        label: 'الانتظار بعد الرد',
        value: _hangupDelay.toDouble(),
        min: 5,
        max: 120,
        divisions: 23,
        valueLabel: '$_hangupDelay ث',
        onChanged: (value) => setState(() => _hangupDelay = value.round()),
      ),
      OutreachSliderRow(
        label: 'الفاصل بين الأرقام',
        value: _delayBetweenCalls.toDouble(),
        min: 1,
        max: 30,
        divisions: 29,
        valueLabel: '$_delayBetweenCalls ث',
        onChanged: (value) =>
            setState(() => _delayBetweenCalls = value.round()),
      ),
      OutreachSwitchRow(
        title: 'إيقاف بعد أول رد',
        icon: AppIcons.stop,
        value: _stopOnFirstAnswered,
        onChanged: (value) => setState(() => _stopOnFirstAnswered = value),
      ),
      OutreachSwitchRow(
        title: 'إعادة عند عدم الرد',
        icon: AppIcons.replay,
        value: _retryEnabled,
        onChanged: (value) => setState(() => _retryEnabled = value),
      ),
      OutreachSwitchRow(
        title: 'تكرار الحلقة بالكامل',
        icon: AppIcons.refresh,
        value: _repeatCycle,
        isLast: true,
        onChanged: (value) => setState(() => _repeatCycle = value),
      ),
    ];
  }

  Widget _buildDaysPicker() {
    final skin = AppSkin.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 10.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: skin.hairline)),
      ),
      child: Wrap(
        spacing: 6.w,
        runSpacing: 6.h,
        children: <Widget>[
          for (var day = 1; day <= 7; day++)
            OutreachChoiceChip(
              label: outreachWeekdayLabel(day),
              selected: _selectedDays.contains(day),
              onTap: () => _toggleDay(day, !_selectedDays.contains(day)),
            ),
        ],
      ),
    );
  }

  PrayerInfoModel? _getFajrPrayer(BuildContext context) {
    try {
      final prayers = context.read<PrayerTimeBloc>().state.prayerList;
      for (final prayer in prayers) {
        if (prayer.type == Prayer.fajr) {
          return prayer;
        }
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  String _formatPrayerTime(BuildContext context, PrayerInfoModel prayer) {
    final time = TimeOfDay(
      hour: prayer.time.hour,
      minute: prayer.time.minute,
    );
    return time.format(context);
  }

  Future<void> _showTimeOptionsSheet() async {
    final skin = AppSkin.of(context);
    final fajrPrayer = _getFajrPrayer(context);
    final fajrTime =
        fajrPrayer == null ? null : _formatPrayerTime(context, fajrPrayer);

    final selectedOption = await showModalBottomSheet<_ScheduleTimeOption>(
      context: context,
      backgroundColor: skin.ground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 8.h, bottom: 6.h),
                child: Container(
                  width: 34.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: skin.hairline,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              ),
              const HomeSectionHeader(title: 'وقت الاتصال'),
              OutreachRow(
                title: 'اختيار وقت يدوي',
                icon: AppIcons.clock,
                subtitle: 'حدّد الساعة والدقيقة بنفسك',
                showChevron: true,
                onTap: () {
                  Navigator.of(sheetContext).pop(_ScheduleTimeOption.manual);
                },
              ),
              OutreachRow(
                title: fajrTime == null
                    ? 'استخدام وقت الفجر'
                    : 'استخدام وقت الفجر · $fajrTime',
                icon: AppIcons.moon,
                subtitle: fajrTime == null
                    ? 'مواقيت الصلاة غير جاهزة الآن'
                    : 'يُعبَّأ الوقت تلقائيًا من مواقيت اليوم',
                dimmed: fajrTime == null,
                showChevron: fajrTime != null,
                isLast: true,
                onTap: fajrTime == null
                    ? null
                    : () {
                        Navigator.of(sheetContext).pop(
                          _ScheduleTimeOption.fajr,
                        );
                      },
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );

    if (!mounted || selectedOption == null) return;

    if (selectedOption == _ScheduleTimeOption.manual) {
      await _pickTime();
      return;
    }

    _useFajrTime();
  }

  Future<void> _pickTime() async {
    final picked = await AdaptiveTimePicker.show(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      unawaited(HapticFeedback.selectionClick());
      setState(() => _selectedTime = picked);
    }
  }

  void _useFajrTime({bool silent = false}) {
    final fajrPrayer = _getFajrPrayer(context);
    if (fajrPrayer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('وقت الفجر غير متاح الآن. جرّب بعد قليل.'),
        ),
      );
      return;
    }

    setState(() {
      _selectedTime = TimeOfDay(
        hour: fajrPrayer.time.hour,
        minute: fajrPrayer.time.minute,
      );
    });

    if (!silent) {
      unawaited(HapticFeedback.selectionClick());
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'تم استخدام وقت الفجر: ${_formatPrayerTime(context, fajrPrayer)}',
            ),
          ),
        );
    }
  }

  Future<void> _addFromContacts() async {
    final result = await _contactsPickerService.pickContact();
    if (!mounted || result.cancelled) return;

    if (!result.isSuccess || result.contact == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.errorMessage ?? 'ما قدرنا نجيب جهة الاتصال الآن.',
          ),
        ),
      );
      return;
    }

    final selectedPhone = await showSmartOutreachPhonePicker(
      context,
      result.contact!.phoneNumbers,
    );

    if (!mounted || selectedPhone == null) return;

    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _rows.add(
        _EditablePhoneRow(
          labelController: TextEditingController(text: result.contact!.name),
          phoneController: TextEditingController(text: selectedPhone),
        ),
      );
    });
  }

  void _remove(int index) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _rows.removeAt(index).dispose();
    });
  }

  void _toggleDay(int day, bool value) {
    setState(() {
      if (value) {
        _selectedDays
          ..add(day)
          ..sort();
      } else {
        _selectedDays.remove(day);
      }
    });
  }

  Future<void> _onSavePressed() async {
    if (!_formKey.currentState!.validate()) return;

    unawaited(HapticFeedback.mediumImpact());

    if (_isEnabled && Platform.isAndroid) {
      final exactAlarmGranted = await sl<NotificationPermissionsService>()
          .requestExactAlarmPermission();
      if (!mounted) return;

      if (!exactAlarmGranted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                'لضمان صحبة الفجر في وقتها بدقة، '
                'فعّل إذن التنبيهات الدقيقة من إعدادات الجهاز.',
              ),
            ),
          );
      }
    }

    final contacts = _rows
        .map(
          (row) => SmartOutreachContactDraft(
            id: row.id,
            name: row.labelController.text.trim().isEmpty
                ? null
                : row.labelController.text.trim(),
            phone: row.phoneController.text.trim(),
            actionType: SmartOutreachActionType.callOnly,
          ),
        )
        .toList(growable: false);

    context.read<SmartOutreachSchedulesBloc>().add(
          SaveSmartOutreachScheduleEvent(
            scheduleId: widget.initialBundle?.schedule.id,
            title: _titleController.text.trim(),
            note: widget.initialBundle?.schedule.note,
            hour: _selectedTime.hour,
            minute: _selectedTime.minute,
            isEnabled: _isEnabled,
            isDaily: _isDaily,
            scheduleDays: List<int>.from(_selectedDays),
            ringTimeout: _ringTimeout,
            hangupDelay: _hangupDelay,
            delayBetweenCalls: _delayBetweenCalls,
            stopOnFirstAnswered: _stopOnFirstAnswered,
            retryEnabled: _retryEnabled,
            repeatCycle: _repeatCycle,
            contacts: contacts,
          ),
        );
  }
}

/// حقل الاسم: سطر واحد فوق خطّ شعرة، لا صندوق ممتلئ حوله.
class _TitleField extends StatelessWidget {
  const _TitleField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: const OutreachIconChip(icon: AppIcons.noteEdit),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: TextFormField(
              controller: controller,
              cursorColor: skin.accent,
              style: TextStyle(
                color: skin.ink,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                filled: false,
                isDense: true,
                hintText: 'مثال: تذكير الفجر',
                hintStyle: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.5),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                errorStyle: TextStyle(
                  color: AppColors.error,
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w600,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: skin.hairline),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: skin.accent),
                ),
                errorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.error),
                ),
                focusedErrorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.error),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'اكتب اسمًا للقائمة';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// رقم واحد في القائمة: الاسم فوق والرقم تحته بترتيب لاتيني.
class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.name,
    required this.phone,
    required this.onRemove,
  });

  final String name;
  final String phone;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 9.h, 16.w, 9.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: skin.hairline)),
      ),
      child: Row(
        children: [
          const OutreachIconChip(icon: AppIcons.user),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  phone,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.right,
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
          OutreachTextAction(
            label: 'حذف',
            icon: AppIcons.delete,
            danger: true,
            onTap: onRemove,
          ),
        ],
      ),
    );
  }
}

class _EditablePhoneRow {
  _EditablePhoneRow({
    required this.labelController,
    required this.phoneController,
    this.id,
  });

  final int? id;
  final TextEditingController labelController;
  final TextEditingController phoneController;

  void dispose() {
    labelController.dispose();
    phoneController.dispose();
  }
}

enum _ScheduleTimeOption {
  manual,
  fajr,
}
