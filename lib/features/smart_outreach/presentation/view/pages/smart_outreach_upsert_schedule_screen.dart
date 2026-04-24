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
      _rows.add(_EditablePhoneRow.empty());
      _loadDefaults();
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
                  padding: const EdgeInsets.all(16),
                  children: <Widget>[
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'اسم القائمة',
                        hintText: 'مثال: تذكير الفجر',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'اكتب اسمًا للقائمة';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('وقت الاتصال'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(_selectedTime.format(context)),
                          if (fajrPrayer != null)
                            Text(
                              'وقت الفجر اليوم: '
                              '${_formatPrayerTime(context, fajrPrayer)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      ),
                      trailing: OutlinedButton(
                        onPressed: _showTimeOptionsSheet,
                        child: const Text('اختيار'),
                      ),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _isEnabled,
                      onChanged: (value) {
                        setState(() {
                          _isEnabled = value;
                        });
                      },
                      title: const Text('تشغيل هذه القائمة'),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _isDaily,
                      onChanged: (value) {
                        setState(() {
                          _isDaily = value;
                        });
                      },
                      title: const Text('تكرار يومي'),
                    ),
                    if (!_isDaily) ...<Widget>[
                      const SizedBox(height: 8),
                      Text(
                        'اختر الأيام التي تريد تشغيل القائمة فيها',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: List<Widget>.generate(7, (index) {
                          final day = index + 1;
                          final selected = _selectedDays.contains(day);
                          return FilterChip(
                            selected: selected,
                            label: Text(_weekdayLabel(day)),
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
                    const SizedBox(height: 20),
                    Text(
                      'طريقة الاتصال',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    _SliderField(
                      label: 'مدة انتظار الرد',
                      value: _ringTimeout.toDouble(),
                      min: 5,
                      max: 60,
                      divisions: 55,
                      suffix: '$_ringTimeoutث',
                      onChanged: (value) {
                        setState(() {
                          _ringTimeout = value.round();
                        });
                      },
                    ),
                    _SliderField(
                      label: 'الانتظار بعد الرد',
                      value: _hangupDelay.toDouble(),
                      min: 5,
                      max: 120,
                      divisions: 23,
                      suffix: '$_hangupDelayث',
                      onChanged: (value) {
                        setState(() {
                          _hangupDelay = value.round();
                        });
                      },
                    ),
                    _SliderField(
                      label: 'الفاصل بين كل رقم',
                      value: _delayBetweenCalls.toDouble(),
                      min: 1,
                      max: 30,
                      divisions: 29,
                      suffix: '$_delayBetweenCallsث',
                      onChanged: (value) {
                        setState(() {
                          _delayBetweenCalls = value.round();
                        });
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _stopOnFirstAnswered,
                      onChanged: (value) {
                        setState(() {
                          _stopOnFirstAnswered = value;
                        });
                      },
                      title: const Text('إيقاف القائمة بعد أول رد'),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _retryEnabled,
                      onChanged: (value) {
                        setState(() {
                          _retryEnabled = value;
                        });
                      },
                      title: const Text('إعادة الاتصال إذا لم يتم الرد'),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _repeatCycle,
                      onChanged: (value) {
                        setState(() {
                          _repeatCycle = value;
                        });
                      },
                      title: const Text(
                        'إعادة البدء من أول القائمة بعد الانتهاء',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'الأرقام التي سيتم الاتصال بها',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _addManualRow,
                          icon: const Icon(Icons.add),
                          label: const Text('إضافة يدويًا'),
                        ),
                        TextButton.icon(
                          onPressed: _addFromContacts,
                          icon: const Icon(Icons.contacts_outlined),
                          label: const Text('من جهات الاتصال'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...List<Widget>.generate(_rows.length, (index) {
                      final row = _rows[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: row.labelController,
                                decoration: InputDecoration(
                                  labelText: 'اسم صاحب الرقم ${index + 1}',
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: row.phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  labelText: 'رقم الهاتف',
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'اكتب رقم الهاتف';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    onPressed: index == 0
                                        ? null
                                        : () => _move(index, index - 1),
                                    icon: const Icon(Icons.arrow_upward),
                                  ),
                                  IconButton(
                                    onPressed: index == _rows.length - 1
                                        ? null
                                        : () => _move(index, index + 1),
                                    icon: const Icon(Icons.arrow_downward),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: _rows.length == 1
                                        ? null
                                        : () => _remove(index),
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: _onSavePressed,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('حفظ القائمة'),
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

  void _useFajrTime() {
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

  void _addManualRow() {
    setState(() {
      _rows.add(_EditablePhoneRow.empty());
    });
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(child: Text(label)),
                Text(suffix),
              ],
            ),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
