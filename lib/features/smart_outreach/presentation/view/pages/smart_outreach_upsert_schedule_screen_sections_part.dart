part of 'smart_outreach_upsert_schedule_screen.dart';

/// بناء أقسام النموذج.
///
/// امتداد على الحالة لا ودجت مستقلّة: هذه الدوالّ تقرأ عشرات الحقول
/// الخاصّة، وتمريرها معاملاتٍ كان سيضخّم التوقيع بلا فائدة.
extension _UpsertScheduleSections on _SmartOutreachUpsertScheduleScreenState {
  List<Widget> _buildSections(
    BuildContext context,
    PrayerInfoModel? fajrPrayer,
  ) {
    final skin = AppSkin.of(context);
    final fajrTime =
        fajrPrayer == null ? null : _formatPrayerTime(context, fajrPrayer);
    final l10n = context.l10n;

    return <Widget>[
      HomeSectionHeader(title: l10n.outreachListNameHeader),
      // خطّ الحقل نفسه هو الفاصل هنا، فلا داعي لشعرة ثانية تحته.
      _TitleField(controller: _titleController),
      HomeSectionHeader(title: l10n.outreachCallTimeHeader),
      OutreachRow(
        title: l10n.outreachStartTime,
        icon: AppIcons.clock,
        subtitle: fajrTime == null
            ? l10n.outreachStartTimeHint
            : l10n.outreachFajrTimeToday(fajrTime),
        trailing: OutreachValue(text: _selectedTime.format(context)),
        showChevron: true,
        isLast: true,
        onTap: _showTimeOptionsSheet,
      ),
      skin.divider(),
      HomeSectionHeader(
        title: l10n.outreachContactsHeader(_rows.length),
      ),
      ..._buildContactRows(),
      OutreachRow(
        title: l10n.outreachPickFromContacts,
        icon: AppIcons.add,
        subtitle: l10n.outreachPickFromContactsSubtitle,
        isLast: true,
        onTap: _addFromContacts,
      ),
      skin.divider(),
      OutreachRow(
        title: l10n.outreachAdvancedSettings,
        icon: AppIcons.sliders,
        subtitle: l10n.outreachAdvancedSettingsSubtitle,
        isLast: !_showAdvancedSettings,
        trailing: AppIcon(
          _showAdvancedSettings ? AppIcons.up : AppIcons.down,
          color: skin.accent,
          size: 15.sp,
        ),
        onTap: () {
          unawaited(HapticFeedback.selectionClick());
          rebuild(() {
            _showAdvancedSettings = !_showAdvancedSettings;
          });
        },
      ),
      if (_showAdvancedSettings) ..._buildAdvancedRows(),
      BlocBuilder<SmartOutreachSchedulesBloc, SmartOutreachSchedulesState>(
        builder: (context, state) {
          return OutreachPrimaryButton(
            label: state.saveState == RequestState.loading
                ? l10n.outreachSaving
                : l10n.outreachSaveList,
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
            context.l10n.outreachNoNumbersYet,
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
              ? context.l10n.outreachUnnamed
              : entry.value.labelController.text.trim(),
          phone: entry.value.phoneController.text,
          onRemove: () => _remove(entry.key),
        ),
    ];
  }

  List<Widget> _buildAdvancedRows() {
    final l10n = context.l10n;

    return <Widget>[
      OutreachSwitchRow(
        title: l10n.outreachEnableList,
        icon: AppIcons.power,
        value: _isEnabled,
        onChanged: (value) => rebuild(() => _isEnabled = value),
      ),
      OutreachSwitchRow(
        title: l10n.outreachDailyRepeat,
        icon: AppIcons.calendar,
        subtitle:
            _isDaily ? l10n.outreachEveryDay : l10n.outreachSelectedWeekdays,
        value: _isDaily,
        onChanged: (value) => rebuild(() => _isDaily = value),
      ),
      if (!_isDaily) _buildDaysPicker(),
      OutreachSliderRow(
        label: l10n.outreachRingTimeout,
        value: _ringTimeout.toDouble(),
        min: 5,
        max: 60,
        divisions: 55,
        valueLabel: l10n.outreachSecondsValue(_ringTimeout),
        onChanged: (value) => rebuild(() => _ringTimeout = value.round()),
      ),
      OutreachSliderRow(
        label: l10n.outreachHangupDelay,
        value: _hangupDelay.toDouble(),
        min: 5,
        max: 120,
        divisions: 23,
        valueLabel: l10n.outreachSecondsValue(_hangupDelay),
        onChanged: (value) => rebuild(() => _hangupDelay = value.round()),
      ),
      OutreachSliderRow(
        label: l10n.outreachDelayBetweenNumbers,
        value: _delayBetweenCalls.toDouble(),
        min: 1,
        max: 30,
        divisions: 29,
        valueLabel: l10n.outreachSecondsValue(_delayBetweenCalls),
        onChanged: (value) => rebuild(() => _delayBetweenCalls = value.round()),
      ),
      OutreachSwitchRow(
        title: l10n.outreachStopAfterFirstAnswer,
        icon: AppIcons.stop,
        value: _stopOnFirstAnswered,
        onChanged: (value) => rebuild(() => _stopOnFirstAnswered = value),
      ),
      OutreachSwitchRow(
        title: l10n.outreachRetryOnNoAnswer,
        icon: AppIcons.replay,
        value: _retryEnabled,
        onChanged: (value) => rebuild(() => _retryEnabled = value),
      ),
      OutreachSwitchRow(
        title: l10n.outreachRepeatWholeCycle,
        icon: AppIcons.refresh,
        value: _repeatCycle,
        isLast: true,
        onChanged: (value) => rebuild(() => _repeatCycle = value),
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
              label: outreachWeekdayLabel(context.l10n, day),
              selected: _selectedDays.contains(day),
              onTap: () => _toggleDay(day, !_selectedDays.contains(day)),
            ),
        ],
      ),
    );
  }
}
