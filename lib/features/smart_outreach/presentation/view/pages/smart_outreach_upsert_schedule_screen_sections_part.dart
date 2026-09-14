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
        onChanged: (value) => rebuild(() => _isEnabled = value),
      ),
      OutreachSwitchRow(
        title: 'تكرار يومي',
        icon: AppIcons.calendar,
        subtitle: _isDaily ? 'كل يوم' : 'أيام مختارة من الأسبوع',
        value: _isDaily,
        onChanged: (value) => rebuild(() => _isDaily = value),
      ),
      if (!_isDaily) _buildDaysPicker(),
      OutreachSliderRow(
        label: 'مدة انتظار الرد',
        value: _ringTimeout.toDouble(),
        min: 5,
        max: 60,
        divisions: 55,
        valueLabel: '$_ringTimeout ث',
        onChanged: (value) => rebuild(() => _ringTimeout = value.round()),
      ),
      OutreachSliderRow(
        label: 'الانتظار بعد الرد',
        value: _hangupDelay.toDouble(),
        min: 5,
        max: 120,
        divisions: 23,
        valueLabel: '$_hangupDelay ث',
        onChanged: (value) => rebuild(() => _hangupDelay = value.round()),
      ),
      OutreachSliderRow(
        label: 'الفاصل بين الأرقام',
        value: _delayBetweenCalls.toDouble(),
        min: 1,
        max: 30,
        divisions: 29,
        valueLabel: '$_delayBetweenCalls ث',
        onChanged: (value) => rebuild(() => _delayBetweenCalls = value.round()),
      ),
      OutreachSwitchRow(
        title: 'إيقاف بعد أول رد',
        icon: AppIcons.stop,
        value: _stopOnFirstAnswered,
        onChanged: (value) => rebuild(() => _stopOnFirstAnswered = value),
      ),
      OutreachSwitchRow(
        title: 'إعادة عند عدم الرد',
        icon: AppIcons.replay,
        value: _retryEnabled,
        onChanged: (value) => rebuild(() => _retryEnabled = value),
      ),
      OutreachSwitchRow(
        title: 'تكرار الحلقة بالكامل',
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
              label: outreachWeekdayLabel(day),
              selected: _selectedDays.contains(day),
              onTap: () => _toggleDay(day, !_selectedDays.contains(day)),
            ),
        ],
      ),
    );
  }
}
