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

part 'smart_outreach_upsert_schedule_screen_sections_part.dart';
part 'smart_outreach_upsert_schedule_screen_actions_part.dart';
part 'smart_outreach_upsert_schedule_screen_widgets_part.dart';

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

  /// بوّابة [setState] لامتدادات هذه الحالة في ملفّات الأجزاء.
  ///
  /// `setState` معلَّم `@protected`، فنداؤه من امتداد — ولو كان في المكتبة
  /// نفسها — يرفع `invalid_use_of_protected_member`. تمريره من داخل الصنف
  /// يبقي التحذير مطفأً دون تعطيل قاعدة التحليل.
  void rebuild(VoidCallback fn) => setState(fn);

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
}
