import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/features/prayer_time/data/remote/prayer_time_repo.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_bundle_models.dart';
import 'package:quran_app/features/smart_outreach/data/service/smart_outreach_contacts_picker_service.dart';
import 'package:quran_app/features/smart_outreach/presentation/bloc/smart_outreach_schedules_bloc.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/widgets/smart_outreach_contacts_form_manager.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/widgets/smart_outreach_contacts_section.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/widgets/smart_outreach_phone_picker_sheet.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/widgets/smart_outreach_schedule_fields_section.dart';

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
  late final TextEditingController _titleController;
  late final TextEditingController _noteController;
  late final TextEditingController _scheduleSmsController;

  late TimeOfDay _time;
  late bool _isEnabled;

  late final SmartOutreachContactsFormManager _contactsManager;
  final SmartOutreachContactsPickerService _contactsPickerService =
      sl<SmartOutreachContactsPickerService>();
  final AdhanPrayerTimeService _prayerTimeService =
      sl<AdhanPrayerTimeService>();
  bool _isSettingTimeFromFajr = false;

  bool get _isEditing => widget.initialBundle?.schedule.id != null;

  @override
  void initState() {
    super.initState();

    final initial = widget.initialBundle;

    _titleController = TextEditingController(
      text: initial?.schedule.title ?? '',
    );
    _noteController = TextEditingController(
      text: initial?.schedule.note ?? '',
    );
    _scheduleSmsController = TextEditingController(
      text: initial?.schedule.smsTemplate ?? '',
    );

    _time = TimeOfDay(
      hour: initial?.schedule.hour ?? 9,
      minute: initial?.schedule.minute ?? 0,
    );

    _isEnabled = initial?.schedule.isEnabled ?? true;

    _contactsManager = SmartOutreachContactsFormManager.fromInitial(
      initial?.contacts ?? const [],
    );

    context
        .read<SmartOutreachSchedulesBloc>()
        .add(const ClearSmartOutreachScheduleFeedbackEvent());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _scheduleSmsController.dispose();
    _contactsManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              SnackBar(
                content: Text(state.validationErrors.join('\n')),
              ),
            );
          return;
        }

        if (state.saveState == RequestState.success) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'تعديل جدول التواصل' : 'إضافة جدول تواصل'),
          actions: [
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
        body: ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            SmartOutreachScheduleFieldsSection(
              titleController: _titleController,
              noteController: _noteController,
              scheduleSmsController: _scheduleSmsController,
              time: _time,
              isEnabled: _isEnabled,
              isSettingTimeFromFajr: _isSettingTimeFromFajr,
              onPickTime: _pickTime,
              onApplyTimeFromFajr: _applyTimeFromFajrPrayer,
              onEnabledChanged: (value) {
                setState(() {
                  _isEnabled = value;
                });
              },
            ),
            SizedBox(height: 18.h),
            SmartOutreachContactsSection(
              rows: _contactsManager.rows,
              onAddFromContacts: _contactsManager.rows.length >= 5
                  ? null
                  : _addContactFromDevice,
              onAddManual:
                  _contactsManager.rows.length >= 5 ? null : _addContactRow,
              onMoveContact: _moveContact,
              onRemoveContact: _removeContactRow,
              onPickContact: _fillContactFromDevice,
              onActionTypeChanged: (index, type) {
                setState(() {
                  _contactsManager.rows[index].actionType = type;
                });
              },
            ),
            SizedBox(height: 24.h),
            FilledButton(
              onPressed: _onSavePressed,
              child: const Text('حفظ الجدول'),
            ),
            SizedBox(height: 10.h),
            OutlinedButton.icon(
              onPressed: _previewFullScreenNotification,
              icon: const Icon(Icons.notification_important_outlined),
              label: const Text('تجربة إشعار ملء الشاشة (بعد 5 ثوانٍ)'),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  void _addContactRow() {
    if (_contactsManager.rows.length >= 5) {
      return;
    }

    setState(() {
      _contactsManager.addEmpty();
    });
  }

  Future<void> _applyTimeFromFajrPrayer() async {
    if (_isSettingTimeFromFajr) {
      return;
    }

    setState(() {
      _isSettingTimeFromFajr = true;
    });

    try {
      final prayerTimes = await _prayerTimeService.getTodayPrayerTimes();
      DateTime? fajrDateTime;
      String? fajrLabel;

      for (final prayer in prayerTimes) {
        if (prayer.type == Prayer.fajr) {
          fajrDateTime = prayer.time;
          fajrLabel = prayer.time12;
          break;
        }
      }

      if (fajrDateTime == null) {
        _showMessage('تعذر جلب موعد صلاة الفجر. تأكد من إعدادات الموقع.');
        return;
      }

      final resolvedFajr = fajrDateTime;

      setState(() {
        _time = TimeOfDay(
          hour: resolvedFajr.hour,
          minute: resolvedFajr.minute,
        );
      });

      final fallbackLabel =
          '${resolvedFajr.hour.toString().padLeft(2, '0')}:${resolvedFajr.minute.toString().padLeft(2, '0')}';
      _showMessage(
        'تم ضبط الوقت على الفجر (${fajrLabel ?? fallbackLabel}).',
      );
    } catch (_) {
      _showMessage('تعذر جلب وقت الفجر حاليًا. حاول مرة أخرى.');
    } finally {
      if (mounted) {
        setState(() {
          _isSettingTimeFromFajr = false;
        });
      }
    }
  }

  Future<void> _addContactFromDevice() async {
    final result = await _contactsPickerService.pickContact();
    if (!mounted || result.cancelled) {
      return;
    }

    if (!result.isSuccess || result.contact == null) {
      _showMessage(result.errorMessage ?? 'تعذر اختيار جهة الاتصال.');
      return;
    }

    final selectedPhone = await showSmartOutreachPhonePicker(
      context,
      result.contact!.phoneNumbers,
    );
    if (!mounted || selectedPhone == null) {
      return;
    }

    final emptyIndex = _contactsManager.firstEmptyIndex();

    if (emptyIndex >= 0) {
      _fillRow(
        index: emptyIndex,
        name: result.contact!.name,
        phone: selectedPhone,
      );
      return;
    }

    if (_contactsManager.rows.length >= 5) {
      _showMessage('وصلت إلى الحد الأقصى (5 جهات اتصال).');
      return;
    }

    setState(() {
      _contactsManager.appendPrefilled(
        name: result.contact!.name,
        phone: selectedPhone,
      );
    });
  }

  Future<void> _fillContactFromDevice(int index) async {
    if (index < 0 || index >= _contactsManager.rows.length) {
      return;
    }

    final result = await _contactsPickerService.pickContact();
    if (!mounted || result.cancelled) {
      return;
    }

    if (!result.isSuccess || result.contact == null) {
      _showMessage(result.errorMessage ?? 'تعذر اختيار جهة الاتصال.');
      return;
    }

    final selectedPhone = await showSmartOutreachPhonePicker(
      context,
      result.contact!.phoneNumbers,
    );
    if (!mounted || selectedPhone == null) {
      return;
    }

    _fillRow(
      index: index,
      name: result.contact!.name,
      phone: selectedPhone,
    );
  }

  void _fillRow({
    required int index,
    required String name,
    required String phone,
  }) {
    setState(() {
      _contactsManager.fillRow(
        index: index,
        name: name,
        phone: phone,
      );
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _removeContactRow(int index) {
    if (_contactsManager.rows.length <= 1) {
      return;
    }

    setState(() {
      _contactsManager.removeAt(index);
    });
  }

  void _moveContact(int index, int direction) {
    if (index + direction < 0 ||
        index + direction >= _contactsManager.rows.length) {
      return;
    }

    setState(() {
      _contactsManager.move(index, direction);
    });
  }

  Future<void> _pickTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if (selected == null) {
      return;
    }

    setState(() {
      _time = selected;
    });
  }

  void _onSavePressed() {
    final contacts = _contactsManager.buildDrafts();

    context.read<SmartOutreachSchedulesBloc>().add(
          SaveSmartOutreachScheduleEvent(
            scheduleId: widget.initialBundle?.schedule.id,
            title: _titleController.text,
            note: _noteController.text,
            hour: _time.hour,
            minute: _time.minute,
            isEnabled: _isEnabled,
            smsTemplate: _scheduleSmsController.text,
            contacts: contacts,
          ),
        );
  }

  void _previewFullScreenNotification() {
    final scheduleId = widget.initialBundle?.schedule.id;
    if (scheduleId == null) {
      _showMessage(
        'احفظ المهمة أولًا، ثم جرّب الإشعار من نفس الشاشة أو من قائمة المهام.',
      );
      return;
    }

    context.read<SmartOutreachSchedulesBloc>().add(
          PreviewSmartOutreachScheduleNotificationEvent(scheduleId),
        );
  }
}
