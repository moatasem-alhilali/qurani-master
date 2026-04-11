import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_bundle_models.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_contact_model.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_enums.dart';
import 'package:quran_app/features/smart_outreach/presentation/bloc/smart_outreach_schedules_bloc.dart';

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

  final List<_ContactFormRow> _contactRows = <_ContactFormRow>[];

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

    if (initial == null || initial.contacts.isEmpty) {
      _contactRows.add(_ContactFormRow.empty());
    } else {
      for (final contact in initial.contacts) {
        _contactRows.add(_ContactFormRow.fromContact(contact));
      }
    }

    context
        .read<SmartOutreachSchedulesBloc>()
        .add(const ClearSmartOutreachScheduleFeedbackEvent());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _scheduleSmsController.dispose();
    for (final row in _contactRows) {
      row.dispose();
    }
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
            TextField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'عنوان الجدول *',
                hintText: 'تواصل الصباح',
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _noteController,
              textInputAction: TextInputAction.next,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'ملاحظة (اختياري)',
              ),
            ),
            SizedBox(height: 12.h),
            InkWell(
              onTap: _pickTime,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'الوقت اليومي',
                ),
                child: Text(_time.format(context)),
              ),
            ),
            SizedBox(height: 12.h),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _isEnabled,
              onChanged: (val) => setState(() => _isEnabled = val),
              title: const Text('تفعيل الجدول'),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _scheduleSmsController,
              maxLines: 2,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'قالب الرسالة النصية الافتراضي (اختياري)',
              ),
            ),
            SizedBox(height: 18.h),
            Row(
              children: [
                const Text(
                  'جهات الاتصال (الحد الأقصى 5)',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _contactRows.length >= 5 ? null : _addContactRow,
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة جهة اتصال'),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            ..._buildContacts(),
            SizedBox(height: 24.h),
            FilledButton(
              onPressed: _onSavePressed,
              child: const Text('حفظ الجدول'),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildContacts() {
    return _contactRows.asMap().entries.map((entry) {
      final index = entry.key;
      final row = entry.value;

      return Card(
        margin: EdgeInsets.only(bottom: 12.h),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'الأولوية ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed:
                        index == 0 ? null : () => _moveContact(index, -1),
                    icon: const Icon(Icons.arrow_upward),
                  ),
                  IconButton(
                    onPressed: index == _contactRows.length - 1
                        ? null
                        : () => _moveContact(index, 1),
                    icon: const Icon(Icons.arrow_downward),
                  ),
                  IconButton(
                    onPressed: _contactRows.length <= 1
                        ? null
                        : () => _removeContactRow(index),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
              TextField(
                controller: row.nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'الاسم / التسمية (اختياري)',
                ),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: row.phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'رقم الهاتف *',
                  hintText: '+9665XXXXXXX',
                ),
              ),
              SizedBox(height: 10.h),
              DropdownButtonFormField<SmartOutreachActionType>(
                value: row.actionType,
                items: SmartOutreachActionType.values
                    .map(
                      (type) => DropdownMenuItem<SmartOutreachActionType>(
                        value: type,
                        child: Text(type.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    row.actionType = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'نوع الإجراء',
                ),
              ),
              if (row.actionType.includesSms) ...[
                SizedBox(height: 10.h),
                TextField(
                  controller: row.smsTemplateController,
                  textInputAction: TextInputAction.next,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'قالب رسالة نصية خاص (اختياري)',
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }).toList();
  }

  void _addContactRow() {
    if (_contactRows.length >= 5) {
      return;
    }

    setState(() {
      _contactRows.add(_ContactFormRow.empty());
    });
  }

  void _removeContactRow(int index) {
    if (_contactRows.length <= 1) {
      return;
    }

    setState(() {
      final removed = _contactRows.removeAt(index);
      removed.dispose();
    });
  }

  void _moveContact(int index, int direction) {
    final target = index + direction;
    if (target < 0 || target >= _contactRows.length) {
      return;
    }

    setState(() {
      final row = _contactRows.removeAt(index);
      _contactRows.insert(target, row);
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
    final contacts = _contactRows
        .map(
          (row) => SmartOutreachContactDraft(
            id: row.id,
            name: row.nameController.text,
            phone: row.phoneController.text,
            actionType: row.actionType,
            smsTemplate: row.smsTemplateController.text,
          ),
        )
        .toList(growable: false);

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
}

class _ContactFormRow {
  _ContactFormRow({
    required this.id,
    required this.nameController,
    required this.phoneController,
    required this.smsTemplateController,
    required this.actionType,
  });

  factory _ContactFormRow.empty() {
    return _ContactFormRow(
      id: null,
      nameController: TextEditingController(),
      phoneController: TextEditingController(),
      smsTemplateController: TextEditingController(),
      actionType: SmartOutreachActionType.callOnly,
    );
  }

  factory _ContactFormRow.fromContact(SmartOutreachContactModel contact) {
    return _ContactFormRow(
      id: contact.id,
      nameController: TextEditingController(text: contact.name ?? ''),
      phoneController: TextEditingController(text: contact.phone),
      smsTemplateController:
          TextEditingController(text: contact.smsTemplate ?? ''),
      actionType: contact.actionType,
    );
  }

  final int? id;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController smsTemplateController;
  SmartOutreachActionType actionType;

  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    smsTemplateController.dispose();
  }
}
