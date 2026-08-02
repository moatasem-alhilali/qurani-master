import 'dart:io';

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/notification/notification_permissions_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/prayer_time/presentation/bloc/prayer_time_bloc.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_bundle_models.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_contact_model.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_enums.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_contacts_picker_service.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_settings_store.dart';
import 'package:quran_app/features/smart_outreach/presentation/bloc/smart_outreach_schedules_bloc.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/widgets/smart_outreach_phone_picker_sheet.dart';

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
        title: _isEditing ? 'تعديل القائمة' : 'إضافة قائمة',
        showLargeHeader: false,
        initialOffset: null,
        body: _loadingDefaults
            ? Center(
                child: CircularProgressIndicator(color: context.primaryColor),
              )
            : Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _DraftHero(
                        isEditing: _isEditing,
                        time: _selectedTime.format(context),
                        contactsCount: _rows.length,
                      ),
                      SizedBox(height: 12.h),
                      _TitleField(controller: _titleController),
                      SizedBox(height: 12.h),
                      _ContactsPanel(
                        rows: _rows,
                        onAdd: _addFromContacts,
                        onRemove: _remove,
                      ),
                      SizedBox(height: 12.h),
                      _TimePanel(
                        selectedTime: _selectedTime.format(context),
                        fajrTime: fajrPrayer == null
                            ? null
                            : _formatPrayerTime(context, fajrPrayer),
                        onChange: _showTimeOptionsSheet,
                      ),
                      SizedBox(height: 12.h),
                      _AdvancedHeader(
                        expanded: _showAdvancedSettings,
                        onTap: () {
                          setState(() {
                            _showAdvancedSettings = !_showAdvancedSettings;
                          });
                        },
                      ),
                      if (_showAdvancedSettings) ...[
                        SizedBox(height: 10.h),
                        _AdvancedPanel(
                          isEnabled: _isEnabled,
                          isDaily: _isDaily,
                          selectedDays: _selectedDays,
                          ringTimeout: _ringTimeout,
                          hangupDelay: _hangupDelay,
                          delayBetweenCalls: _delayBetweenCalls,
                          stopOnFirstAnswered: _stopOnFirstAnswered,
                          retryEnabled: _retryEnabled,
                          repeatCycle: _repeatCycle,
                          onEnabledChanged: (value) {
                            setState(() => _isEnabled = value);
                          },
                          onDailyChanged: (value) {
                            setState(() => _isDaily = value);
                          },
                          onDayChanged: _toggleDay,
                          onRingChanged: (value) {
                            setState(() => _ringTimeout = value.round());
                          },
                          onHangupChanged: (value) {
                            setState(() => _hangupDelay = value.round());
                          },
                          onDelayChanged: (value) {
                            setState(() => _delayBetweenCalls = value.round());
                          },
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
                      ],
                      SizedBox(height: 14.h),
                      BlocBuilder<SmartOutreachSchedulesBloc,
                          SmartOutreachSchedulesState>(
                        builder: (context, state) {
                          return _SaveButton(
                            loading: state.saveState == RequestState.loading,
                            onTap: _onSavePressed,
                          );
                        },
                      ),
                      SizedBox(height: 36.h),
                    ],
                  ),
                ),
              ),
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
    final fajrPrayer = _getFajrPrayer(context);
    final selectedOption = await showModalBottomSheet<_ScheduleTimeOption>(
      context: context,
      backgroundColor: context.scaffoldBackgroundColor,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _SheetOption(
                  icon: AppIcons.clock,
                  title: 'اختيار وقت يدوي',
                  subtitle: 'حدد الساعة والدقيقة بنفسك',
                  onTap: () {
                    Navigator.of(context).pop(_ScheduleTimeOption.manual);
                  },
                ),
                SizedBox(height: 8.h),
                _SheetOption(
                  icon: AppIcons.moon,
                  title: fajrPrayer == null
                      ? 'استخدام وقت الفجر'
                      : 'استخدام وقت الفجر ('
                          '${_formatPrayerTime(context, fajrPrayer)})',
                  subtitle: fajrPrayer == null
                      ? 'مواقيت الصلاة غير جاهزة الآن'
                      : 'سيتم تعبئة الوقت تلقائيًا',
                  enabled: fajrPrayer != null,
                  onTap: () {
                    Navigator.of(context).pop(_ScheduleTimeOption.fajr);
                  },
                ),
              ],
            ),
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

  static String _weekdayLabel(int day) {
    switch (day) {
      case 1:
        return 'الإثنين';
      case 2:
        return 'الثلاثاء';
      case 3:
        return 'الأربعاء';
      case 4:
        return 'الخميس';
      case 5:
        return 'الجمعة';
      case 6:
        return 'السبت';
      case 7:
        return 'الأحد';
      default:
        return '$day';
    }
  }
}

class _DraftHero extends StatelessWidget {
  const _DraftHero({
    required this.isEditing,
    required this.time,
    required this.contactsCount,
  });

  final bool isEditing;
  final String time;
  final int contactsCount;

  @override
  Widget build(BuildContext context) {
    return _SoftPanel(
      padding: EdgeInsets.all(14.w),
      child: Row(
        children: [
          _IconBubble(icon: isEditing ? AppIcons.edit : AppIcons.add),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'تعديل قائمة اتصال' : 'قائمة اتصال جديدة',
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  '$time • $contactsCount رقم',
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

class _TitleField extends StatelessWidget {
  const _TitleField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(
        color: context.onSurfaceColor,
        fontSize: 12.5.sp,
        fontWeight: FontWeight.w800,
      ),
      decoration: InputDecoration(
        labelText: 'اسم المجموعة',
        hintText: 'مثال: تذكير الفجر',
        prefixIcon: Padding(
          padding: EdgeInsets.all(12.w),
          child: AppIcon(
            AppIcons.noteEdit,
            color: context.primaryColor,
            size: 15.sp,
            strokeWidth: 1.55,
          ),
        ),
        filled: true,
        fillColor: context.surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide:
              BorderSide(color: context.outlineVariant.withValues(alpha: 0.24)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide:
              BorderSide(color: context.outlineVariant.withValues(alpha: 0.24)),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'اكتب اسمًا للمجموعة';
        }
        return null;
      },
    );
  }
}

class _ContactsPanel extends StatelessWidget {
  const _ContactsPanel({
    required this.rows,
    required this.onAdd,
    required this.onRemove,
  });

  final List<_EditablePhoneRow> rows;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return _SoftPanel(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PanelHeader(
            icon: AppIcons.contacts,
            title: 'جهات الاتصال',
            trailing: '${rows.length}',
          ),
          SizedBox(height: 10.h),
          _SmallAction(
            label: 'اختيار من جهات الاتصال',
            icon: AppIcons.add,
            onTap: onAdd,
          ),
          if (rows.isEmpty) ...[
            SizedBox(height: 10.h),
            Text(
              'لم تضف أرقامًا بعد.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.onSurfaceVariant,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ] else ...[
            SizedBox(height: 10.h),
            ...List<Widget>.generate(rows.length, (index) {
              final row = rows[index];
              return _ContactTile(
                name: row.labelController.text.isNotEmpty
                    ? row.labelController.text
                    : 'بدون اسم',
                phone: row.phoneController.text,
                onRemove: () => onRemove(index),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.name,
    required this.phone,
    required this.onRemove,
  });

  final String name;
  final String phone;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 7.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: context.surfaceVariant.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(13.r),
        ),
        child: Row(
          children: [
            AppIcon(
              AppIcons.user,
              size: 14.sp,
              color: context.primaryColor,
              strokeWidth: 1.55,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: context.onSurfaceColor,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    phone,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      color: context.onSurfaceVariant,
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(10.r),
              onTap: onRemove,
              child: Padding(
                padding: EdgeInsets.all(7.w),
                child: AppIcon(
                  AppIcons.delete,
                  color: context.errorColor,
                  size: 13.sp,
                  strokeWidth: 1.55,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimePanel extends StatelessWidget {
  const _TimePanel({
    required this.selectedTime,
    required this.fajrTime,
    required this.onChange,
  });

  final String selectedTime;
  final String? fajrTime;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return _SoftPanel(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          const _IconBubble(icon: AppIcons.clock),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'وقت الاتصال',
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  fajrTime == null
                      ? selectedTime
                      : '$selectedTime • الفجر $fajrTime',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.onSurfaceVariant,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          _SmallAction(label: 'تغيير', icon: AppIcons.edit, onTap: onChange),
        ],
      ),
    );
  }
}

class _AdvancedHeader extends StatelessWidget {
  const _AdvancedHeader({
    required this.expanded,
    required this.onTap,
  });

  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15.r),
      onTap: onTap,
      child: _SoftPanel(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
        child: Row(
          children: [
            AppIcon(
              AppIcons.settings,
              color: context.primaryColor,
              size: 15.sp,
              strokeWidth: 1.55,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'إعدادات متقدمة',
                style: TextStyle(
                  color: context.onSurfaceColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            AppIcon(
              expanded ? AppIcons.up : AppIcons.down,
              color: context.onSurfaceVariant,
              size: 13.sp,
              strokeWidth: 1.55,
            ),
          ],
        ),
      ),
    );
  }
}

class _AdvancedPanel extends StatelessWidget {
  const _AdvancedPanel({
    required this.isEnabled,
    required this.isDaily,
    required this.selectedDays,
    required this.ringTimeout,
    required this.hangupDelay,
    required this.delayBetweenCalls,
    required this.stopOnFirstAnswered,
    required this.retryEnabled,
    required this.repeatCycle,
    required this.onEnabledChanged,
    required this.onDailyChanged,
    required this.onDayChanged,
    required this.onRingChanged,
    required this.onHangupChanged,
    required this.onDelayChanged,
    required this.onStopChanged,
    required this.onRetryChanged,
    required this.onRepeatChanged,
  });

  final bool isEnabled;
  final bool isDaily;
  final List<int> selectedDays;
  final int ringTimeout;
  final int hangupDelay;
  final int delayBetweenCalls;
  final bool stopOnFirstAnswered;
  final bool retryEnabled;
  final bool repeatCycle;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<bool> onDailyChanged;
  final void Function(int day, bool value) onDayChanged;
  final ValueChanged<double> onRingChanged;
  final ValueChanged<double> onHangupChanged;
  final ValueChanged<double> onDelayChanged;
  final ValueChanged<bool> onStopChanged;
  final ValueChanged<bool> onRetryChanged;
  final ValueChanged<bool> onRepeatChanged;

  @override
  Widget build(BuildContext context) {
    return _SoftPanel(
      padding: EdgeInsets.all(12.w),
      child: Column(
        children: [
          _SwitchRow(
            icon: AppIcons.power,
            title: 'تشغيل هذه القائمة',
            value: isEnabled,
            onChanged: onEnabledChanged,
          ),
          _SwitchRow(
            icon: AppIcons.calendar,
            title: 'تكرار يومي',
            value: isDaily,
            onChanged: onDailyChanged,
          ),
          if (!isDaily) ...[
            SizedBox(height: 8.h),
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: List<Widget>.generate(7, (index) {
                final day = index + 1;
                final selected = selectedDays.contains(day);
                return ChoiceChip(
                  selected: selected,
                  label: Text(
                    _SmartOutreachUpsertScheduleScreenState._weekdayLabel(day),
                    style: TextStyle(fontSize: 9.5.sp),
                  ),
                  onSelected: (value) => onDayChanged(day, value),
                );
              }),
            ),
          ],
          SizedBox(height: 8.h),
          _SliderField(
            label: 'مدة انتظار الرد',
            value: ringTimeout.toDouble(),
            min: 5,
            max: 60,
            divisions: 55,
            suffix: '$ringTimeout ث',
            onChanged: onRingChanged,
          ),
          _SliderField(
            label: 'الانتظار بعد الرد',
            value: hangupDelay.toDouble(),
            min: 5,
            max: 120,
            divisions: 23,
            suffix: '$hangupDelay ث',
            onChanged: onHangupChanged,
          ),
          _SliderField(
            label: 'الفاصل بين الأرقام',
            value: delayBetweenCalls.toDouble(),
            min: 1,
            max: 30,
            divisions: 29,
            suffix: '$delayBetweenCalls ث',
            onChanged: onDelayChanged,
          ),
          _SwitchRow(
            icon: AppIcons.stop,
            title: 'إيقاف بعد أول رد',
            value: stopOnFirstAnswered,
            onChanged: onStopChanged,
          ),
          _SwitchRow(
            icon: AppIcons.replay,
            title: 'إعادة عند عدم الرد',
            value: retryEnabled,
            onChanged: onRetryChanged,
          ),
          _SwitchRow(
            icon: AppIcons.refresh,
            title: 'تكرار الحلقة بالكامل',
            value: repeatCycle,
            onChanged: onRepeatChanged,
          ),
        ],
      ),
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({
    required this.icon,
    required this.title,
    this.trailing,
  });

  final HugeIconData icon;
  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppIcon(
          icon,
          color: context.primaryColor,
          size: 15.sp,
          strokeWidth: 1.55,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: context.onSurfaceColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: TextStyle(
              color: context.primaryColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
      ],
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
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
      contentPadding: EdgeInsets.zero,
      secondary: AppIcon(
        icon,
        size: 14.sp,
        color: value ? context.primaryColor : context.onSurfaceVariant,
        strokeWidth: 1.55,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: context.onSurfaceColor,
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}

class _SliderField extends StatelessWidget {
  const _SliderField({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.suffix,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String suffix;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                suffix,
                style: TextStyle(
                  color: context.primaryColor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          AdaptiveSlider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.loading,
    required this.onTap,
  });

  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: loading ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: context.primaryColor,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading)
              SizedBox(
                width: 15.w,
                height: 15.w,
                child: CircularProgressIndicator(
                  color: context.onPrimaryColor,
                  strokeWidth: 2.w,
                ),
              )
            else
              AppIcon(
                AppIcons.save,
                color: context.onPrimaryColor,
                size: 14.sp,
                strokeWidth: 1.55,
              ),
            SizedBox(width: 7.w),
            Text(
              loading ? 'جارِ الحفظ...' : 'حفظ القائمة',
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

class _SheetOption extends StatelessWidget {
  const _SheetOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.enabled = true,
  });

  final HugeIconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15.r),
      onTap: enabled ? onTap : null,
      child: _SoftPanel(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            AppIcon(
              icon,
              color: enabled ? context.primaryColor : context.onSurfaceVariant,
              size: 16.sp,
              strokeWidth: 1.55,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: context.onSurfaceColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: context.onSurfaceVariant,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallAction extends StatelessWidget {
  const _SmallAction({
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
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: context.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(
              icon,
              color: context.primaryColor,
              size: 13.sp,
              strokeWidth: 1.55,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: context.primaryColor,
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
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
      width: 38.w,
      height: 38.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(13.r),
      ),
      child: AppIcon(
        icon,
        color: context.primaryColor,
        size: 16.sp,
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
        border:
            Border.all(color: context.outlineVariant.withValues(alpha: 0.24)),
      ),
      child: child,
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
