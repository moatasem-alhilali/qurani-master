part of 'smart_outreach_upsert_schedule_screen.dart';

/// إجراءات النموذج: اختيار الوقت وجهات الاتصال والأيام ثم الحفظ.
extension _UpsertScheduleActions on _SmartOutreachUpsertScheduleScreenState {
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
      rebuild(() => _selectedTime = picked);
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

    rebuild(() {
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
    rebuild(() {
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
    rebuild(() {
      _rows.removeAt(index).dispose();
    });
  }

  void _toggleDay(int day, bool value) {
    rebuild(() {
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
