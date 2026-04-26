import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_info.dart';
import 'package:quran_app/features/prayer_time/presentation/bloc/prayer_time_bloc.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_bundle_models.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_contact_model.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_enums.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_contacts_picker_service.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_settings_store.dart';
import 'package:quran_app/features/smart_outreach/presentation/bloc/smart_outreach_schedules_bloc.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/widgets/smart_outreach_phone_picker_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    setState(() {
      _loadingDefaults = true;
    });

    _ringTimeout = await _settingsStore.getDefaultRingTimeout();
    _hangupDelay = await _settingsStore.getDefaultHangupDelay();
    _delayBetweenCalls = await _settingsStore.getDefaultDelayBetweenCalls();
    _stopOnFirstAnswered = await _settingsStore.getDefaultStopOnFirstAnswered();
    _retryEnabled = await _settingsStore.getDefaultRetryEnabled();
    _repeatCycle = await _settingsStore.getDefaultRepeatCycle();

    if (!mounted) {
      return;
    }

    setState(() {
      _loadingDefaults = false;
    });
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
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isEditing ? 'تعديل قائمة المكالمات' : 'إضافة قائمة مكالمات',
          ),
          actions: <Widget>[
            BlocBuilder<SmartOutreachSchedulesBloc,
                SmartOutreachSchedulesState>(
              builder: (context, state) {
                return TextButton(
                  onPressed: state.saveState == RequestState.loading
                      ? null
                      : _onSavePressed,
                  child: state.saveState == RequestState.loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('حفظ'),
                );
              },
            ),
          ],
        ),
        body: _loadingDefaults
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16.w),
                  children: <Widget>[
                    TextFormField(
                      controller: _titleController,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        labelText: 'اسم المجموعة',
                        hintText: 'مثال: تذكير الفجر',
                        isDense: true,
                        filled: true,
                        fillColor: Theme.of(context).primaryColor.withOpacity(0.08),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.edit_note_outlined, size: 20.r),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'اكتب اسمًا للمجموعة';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'جهات الاتصال',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: 1.sw,
                      child: OutlinedButton.icon(
                        onPressed: _addFromContacts,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.2)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        icon: Icon(Icons.person_add_outlined, size: 18.r),
                        label: Text(
                          'اختيار من جهات الاتصال',
                          style: TextStyle(fontSize: 13.sp),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...List<Widget>.generate(_rows.length, (index) {
                      final row = _rows[index];
                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.1)),
                        ),
                        margin: EdgeInsets.only(bottom: 10.h),
                        color: Colors.transparent,
                        child: ListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          leading: CircleAvatar(
                            radius: 14.r,
                            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                            child: Icon(Icons.person_outline, size: 14.r, color: Theme.of(context).primaryColor),
                          ),
                          title: Text(
                            row.labelController.text.isNotEmpty
                                ? row.labelController.text
                                : 'بدون اسم',
                            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            row.phoneController.text,
                            style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
                          ),
                          trailing: IconButton(
                            onPressed: () => _remove(index),
                            icon: Icon(Icons.delete_outline_rounded,
                                color: Colors.red[400], size: 18.r),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.15)),
                      ),
                      child: ListTile(
                        dense: true,
                        leading: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(Icons.access_time_rounded, color: Theme.of(context).primaryColor, size: 20.r),
                        ),
                        title: Text('وقت الاتصال',
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(_selectedTime.format(context),
                                style: TextStyle(fontSize: 16.sp, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                            if (fajrPrayer != null)
                              Padding(
                                padding: EdgeInsets.only(top: 2.h),
                                child: Text(
                                  'وقت الفجر: ${_formatPrayerTime(context, fajrPrayer)}',
                                  style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                                ),
                              ),
                          ],
                        ),
                        trailing: Container(
                          height: 30.h,
                          child: TextButton(
                            onPressed: _showTimeOptionsSheet,
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                            ),
                            child: Text('تغيير', style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _showAdvancedSettings = !_showAdvancedSettings;
                          });
                        },
                        borderRadius: BorderRadius.circular(12.r),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                          child: Row(
                            children: [
                              Icon(
                                _showAdvancedSettings
                                    ? Icons.settings_suggest_rounded
                                    : Icons.settings_outlined,
                                size: 18.r,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'إعدادات متقدمة',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                _showAdvancedSettings
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.grey,
                                size: 20.r,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (_showAdvancedSettings) ...[
                      Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.12)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SwitchListTile(
                              dense: true,
                              secondary: Icon(Icons.power_settings_new_rounded,
                                  size: 18.r, color: _isEnabled ? Theme.of(context).primaryColor : Colors.grey),
                              contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                              value: _isEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _isEnabled = value;
                                });
                              },
                              title: Text('تشغيل هذه القائمة',
                                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500)),
                            ),
                            Divider(height: 1.h),
                            SwitchListTile(
                              dense: true,
                              secondary: Icon(Icons.calendar_today_rounded,
                                  size: 18.r, color: _isDaily ? Theme.of(context).primaryColor : Colors.grey),
                              contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                              value: _isDaily,
                              onChanged: (value) {
                                setState(() {
                                  _isDaily = value;
                                });
                              },
                              title: Text('تكرار يومي',
                                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500)),
                            ),
                            if (!_isDaily) ...<Widget>[
                              SizedBox(height: 8.h),
                              Text(
                                'الأيام المختارة:',
                                style: TextStyle(fontSize: 11.sp, color: Theme.of(context).textTheme.bodySmall?.color),
                              ),
                              SizedBox(height: 8.h),
                              Wrap(
                                spacing: 6.w,
                                runSpacing: 0,
                                children: List<Widget>.generate(7, (index) {
                                  final day = index + 1;
                                  final selected = _selectedDays.contains(day);
                                  return ChoiceChip(
                                    selected: selected,
                                    label: Text(_weekdayLabel(day),
                                        style: TextStyle(
                                            fontSize: 11.sp,
                                            color: selected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color)),
                                    selectedColor: Theme.of(context).primaryColor,
                                    onSelected: (value) {
                                      setState(() {
                                        if (value) {
                                          _selectedDays
                                            ..add(day)
                                            ..sort();
                                        } else {
                                          _selectedDays.remove(day);
                                        }
                                      });
                                    },
                                  );
                                }),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.12)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SliderField(
                              label: 'مدة انتظار الرد',
                              value: _ringTimeout.toDouble(),
                              min: 5,
                              max: 60,
                              divisions: 55,
                              suffix: '$_ringTimeout ثانية',
                              onChanged: (value) {
                                setState(() {
                                  _ringTimeout = value.round();
                                });
                              },
                            ),
                            Divider(height: 24.h),
                            _SliderField(
                              label: 'الانتظار بعد الرد',
                              value: _hangupDelay.toDouble(),
                              min: 5,
                              max: 120,
                              divisions: 23,
                              suffix: '$_hangupDelay ثانية',
                              onChanged: (value) {
                                setState(() {
                                  _hangupDelay = value.round();
                                });
                              },
                            ),
                            Divider(height: 24.h),
                            _SliderField(
                              label: 'الفاصل بين الأرقام',
                              value: _delayBetweenCalls.toDouble(),
                              min: 1,
                              max: 30,
                              divisions: 29,
                              suffix: '$_delayBetweenCalls ثانية',
                              onChanged: (value) {
                                setState(() {
                                  _delayBetweenCalls = value.round();
                                });
                              },
                            ),
                            Divider(height: 24.h),
                            SwitchListTile(
                              dense: true,
                              secondary: Icon(Icons.stop_circle_outlined, size: 18.r),
                              contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                              value: _stopOnFirstAnswered,
                              onChanged: (value) {
                                setState(() {
                                  _stopOnFirstAnswered = value;
                                });
                              },
                              title: Text('إيقاف بعد أول رد',
                                  style: TextStyle(fontSize: 12.sp)),
                            ),
                            SwitchListTile(
                              dense: true,
                              secondary: Icon(Icons.replay_circle_filled_rounded, size: 18.r),
                              contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                              value: _retryEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _retryEnabled = value;
                                });
                              },
                              title: Text('إعادة عند عدم الرد',
                                  style: TextStyle(fontSize: 12.sp)),
                            ),
                            SwitchListTile(
                              dense: true,
                              secondary: Icon(Icons.loop_rounded, size: 18.r),
                              contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                              value: _repeatCycle,
                              onChanged: (value) {
                                setState(() {
                                  _repeatCycle = value;
                                });
                              },
                              title: Text('تكرار الحلقة بالكامل',
                                  style: TextStyle(fontSize: 12.sp)),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed: _onSavePressed,
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      icon: Icon(Icons.save_outlined, size: 20.r),
                      label: Text(
                        'حفظ القائمة',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
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
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                title: Text('اختيار الوقت'),
                subtitle: Text(
                  'يمكنك اختيار الوقت يدويًا أو تعبئة وقت الفجر مباشرة',
                ),
              ),
              ListTile(
                leading: const Icon(Icons.schedule_outlined),
                title: const Text('اختيار وقت يدوي'),
                onTap: () {
                  Navigator.of(context).pop(_ScheduleTimeOption.manual);
                },
              ),
              ListTile(
                leading: const Icon(Icons.wb_twilight_outlined),
                title: Text(
                  fajrPrayer == null
                      ? 'استخدام وقت الفجر'
                      : 'استخدام وقت الفجر ('
                          '${_formatPrayerTime(context, fajrPrayer)})',
                ),
                subtitle: fajrPrayer == null
                    ? const Text('مواقيت الصلاة غير جاهزة الآن')
                    : const Text('سيتم تعبئة الوقت تلقائيًا'),
                onTap: fajrPrayer == null
                    ? null
                    : () {
                        Navigator.of(context).pop(_ScheduleTimeOption.fajr);
                      },
              ),
            ],
          ),
        );
      },
    );

    if (!mounted || selectedOption == null) {
      return;
    }

    if (selectedOption == _ScheduleTimeOption.manual) {
      await _pickTime();
      return;
    }

    _useFajrTime();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
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
    if (!mounted || result.cancelled) {
      return;
    }

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

    if (!mounted || selectedPhone == null) {
      return;
    }

    setState(() {
      _rows.add(
        _EditablePhoneRow(
          labelController: TextEditingController(
            text: result.contact!.name,
          ),
          phoneController: TextEditingController(text: selectedPhone),
        ),
      );
    });
  }

  void _move(int oldIndex, int newIndex) {
    setState(() {
      final item = _rows.removeAt(oldIndex);
      _rows.insert(newIndex, item);
    });
  }

  void _remove(int index) {
    setState(() {
      _rows.removeAt(index).dispose();
    });
  }

  void _onSavePressed() {
    if (!_formKey.currentState!.validate()) {
      return;
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

class _EditablePhoneRow {
  _EditablePhoneRow({
    required this.labelController,
    required this.phoneController,
    this.id,
  });

  factory _EditablePhoneRow.empty() {
    return _EditablePhoneRow(
      labelController: TextEditingController(),
      phoneController: TextEditingController(),
    );
  }

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8)),
              ),
            ),
            Text(
              suffix,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 2.h,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 12.r),
            activeTrackColor: Theme.of(context).primaryColor,
            inactiveTrackColor: Theme.of(context).primaryColor.withOpacity(0.1),
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
    );
  }
}
