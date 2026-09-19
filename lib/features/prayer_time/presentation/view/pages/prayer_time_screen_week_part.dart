part of 'prayer_time_screen.dart';

class _PrayerWeekView extends StatelessWidget {
  const _PrayerWeekView({
    required this.state,
    required this.week,
    required this.now,
    required this.selectedDay,
    required this.onSelectDay,
    required this.onOpenCell,
    required this.onChangeLocation,
    required this.onUseCurrentLocation,
    required this.onOpenSettings,
    required this.onRetry,
  });

  final PrayerTimeState state;
  final List<_DayTimes>? week;
  final DateTime now;
  final int selectedDay;
  final ValueChanged<int> onSelectDay;
  final void Function(int dayIndex, int prayerIndex) onOpenCell;
  final VoidCallback onChangeLocation;
  final VoidCallback onUseCurrentLocation;
  final Future<void> Function() onOpenSettings;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final days = week;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (days == null || days.isEmpty)
          _EmptyWeekState(onChangeLocation: onChangeLocation)
        else ...[
          _WeekTable(
            days: days,
            currentPrayer: _currentPrayerIndex(days.first),
            selectedDay: selectedDay,
            onSelectDay: onSelectDay,
            onOpenCell: onOpenCell,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
            child: Text(
              days.length == 1
                  ? context.l10n.prayerTimeWeekNeedsCity
                  : context.l10n.prayerTimeWeekHint,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.7),
                fontSize: 9.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          skin.divider(),
          HomeSectionHeader(
            title: context.l10n.prayerTimeNightPrayerHeader(
              _selectedLabel(context, days),
            ),
          ),
          Padding(
            padding: AppSkin.gutter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _InfoRow(
                  icon: AppIcons.moon,
                  label: context.l10n.prayerTimeMidnight,
                  hint: context.l10n.prayerTimeMidnightHint,
                  time: days[selectedDay].middleOfTheNight,
                ),
                _InfoRow(
                  icon: AppIcons.star,
                  label: context.l10n.prayerTimeLastThird,
                  hint: context.l10n.prayerTimeLastThirdHint,
                  time: days[selectedDay].lastThirdOfTheNight,
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
        skin.divider(),
        HomeSectionHeader(title: context.l10n.prayerTimeLocationHeader),
        _LocationRow(
          selectedLocation: state.selectedLocation,
          onChangeLocation: onChangeLocation,
          onUseCurrentLocation: onUseCurrentLocation,
        ),
        if (_shouldShowNotice(state))
          _LocationNoticeRow(
            message: (state.locationStatusMessage ?? '').trim().isEmpty
                ? context.l10n.prayerTimeLocationUpdateFailed
                : state.locationStatusMessage!.trim(),
            needsAction: _noticeNeedsAction(state),
            onGrantPermission: onUseCurrentLocation,
            onOpenSettings: onOpenSettings,
            onRetry: onRetry,
          ),
        SizedBox(height: 26.h),
      ],
    );
  }

  String _selectedLabel(BuildContext context, List<_DayTimes> days) {
    if (selectedDay == 0) return context.l10n.prayerTimeToday;
    if (selectedDay == 1) return context.l10n.prayerTimeTomorrow;
    return DateFormat('EEEE', context.localeCode)
        .format(days[selectedDay].date);
  }

  /// الصلاة التي دخل وقتها اليوم ولم يدخل ما بعدها، أو ‎-1‎ قبل الفجر.
  int _currentPrayerIndex(_DayTimes today) {
    if (!DateUtils.isSameDay(today.date, now)) return -1;

    var index = -1;
    for (var i = 0; i < today.slots.length; i++) {
      if (!today.slots[i].isAfter(now)) index = i;
    }
    return index;
  }

  bool _shouldShowNotice(PrayerTimeState state) {
    return state.locationStatus == PrayerLocationStatus.serviceDisabled ||
        state.locationStatus == PrayerLocationStatus.permissionDenied ||
        state.locationStatus == PrayerLocationStatus.permissionDeniedForever ||
        state.locationStatus == PrayerLocationStatus.error;
  }

  bool _noticeNeedsAction(PrayerTimeState state) {
    return state.locationStatus == PrayerLocationStatus.serviceDisabled ||
        state.locationStatus == PrayerLocationStatus.permissionDenied ||
        state.locationStatus == PrayerLocationStatus.permissionDeniedForever;
  }
}

/// الجدول: عمود الأسماء مثبّت، وأعمدة الأيام تُسحب أفقيًا.
class _WeekTable extends StatelessWidget {
  const _WeekTable({
    required this.days,
    required this.currentPrayer,
    required this.selectedDay,
    required this.onSelectDay,
    required this.onOpenCell,
  });

  final List<_DayTimes> days;

  /// صفّ الصلاة الجارية في عمود اليوم، أو ‎-1‎ حين لا صلاة جارية.
  final int currentPrayer;

  final int selectedDay;
  final ValueChanged<int> onSelectDay;
  final void Function(int dayIndex, int prayerIndex) onOpenCell;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSkin.gutter,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PrayerNameColumn(),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var day = 0; day < days.length; day++)
                    _DayColumn(
                      day: days[day],
                      isToday: day == 0,
                      isSelected: day == selectedDay,
                      currentPrayer: day == 0 ? currentPrayer : -1,
                      onSelect: () => onSelectDay(day),
                      onOpenCell: (prayer) => onOpenCell(day, prayer),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// عمود أسماء الصلوات — مثبّت لا يتحرّك مع السحب.
class _PrayerNameColumn extends StatelessWidget {
  const _PrayerNameColumn();

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return SizedBox(
      width: 58.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: _tableHeaderHeight,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                context.l10n.prayerTimeTablePrayerColumn,
                style: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.7),
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          for (var i = 0; i < _prayerKeys.length; i++)
            Container(
              height: _tableRowHeight,
              alignment: AlignmentDirectional.centerStart,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
              child: Text(
                _prayerName(context.l10n, i),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: skin.ink,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// عمود يوم واحد: ترويسته اسم اليوم ورقمه، وتحتها ستّ خلايا أوقات.
class _DayColumn extends StatelessWidget {
  const _DayColumn({
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.currentPrayer,
    required this.onSelect,
    required this.onOpenCell,
  });

  final _DayTimes day;
  final bool isToday;
  final bool isSelected;
  final int currentPrayer;
  final VoidCallback onSelect;
  final ValueChanged<int> onOpenCell;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      width: 50.w,
      decoration: isToday
          ? BoxDecoration(
              // تظليل ذهبي خفيف جدًا: يميّز عمود اليوم بلا أن يصير بطاقة.
              color: AppColors.gold.withValues(
                alpha: skin.isDark ? 0.12 : 0.07,
              ),
              borderRadius: BorderRadius.circular(10.r),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onSelect,
            borderRadius: BorderRadius.circular(10.r),
            child: SizedBox(
              height: _tableHeaderHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _shortWeekday(context.l10n, day.date),
                    maxLines: 1,
                    style: TextStyle(
                      color: isSelected ? skin.accent : skin.inkSoft,
                      fontSize: 9.5.sp,
                      fontWeight: isToday || isSelected
                          ? FontWeight.w800
                          : FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      '${day.date.day}',
                      style: TextStyle(
                        color: isSelected ? skin.accent : skin.ink,
                        fontSize: 11.sp,
                        fontWeight: isToday || isSelected
                            ? FontWeight.w800
                            : FontWeight.w700,
                        height: 1.2,
                        fontFeatures: const [ui.FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          for (var i = 0; i < day.slots.length; i++)
            _TimeCell(
              time: day.slots[i],
              isRaised: i == currentPrayer,
              isPassed: isToday && currentPrayer >= 0 && i < currentPrayer,
              onTap: () {
                unawaited(HapticFeedback.selectionClick());
                onOpenCell(i);
              },
            ),
        ],
      ),
    );
  }
}

/// خليّة وقت واحدة. خليّة الصلاة الجارية وحدها ترتفع.
class _TimeCell extends StatelessWidget {
  const _TimeCell({
    required this.time,
    required this.isRaised,
    required this.isPassed,
    required this.onTap,
  });

  final DateTime time;
  final bool isRaised;
  final bool isPassed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    final label = Text(
      _formatClock(time),
      maxLines: 1,
      style: TextStyle(
        color: skin.ink.withValues(alpha: isPassed ? 0.5 : 0.88),
        fontSize: isRaised ? 12.sp : 11.5.sp,
        fontWeight: isRaised ? FontWeight.w800 : FontWeight.w600,
        height: 1.2,
        fontFeatures: const [ui.FontFeature.tabularFigures()],
      ),
    );

    return InkWell(
      onTap: onTap,
      child: Container(
        height: _tableRowHeight,
        alignment: Alignment.center,
        decoration: isRaised
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        child: isRaised
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: skin.raised,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: skin.raisedBorder, width: 1.2),
                  boxShadow: skin.raisedShadow,
                ),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: label,
                ),
              )
            : Directionality(
                textDirection: TextDirection.ltr,
                child: label,
              ),
      ),
    );
  }
}
