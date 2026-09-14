part of 'daily_wird_screen.dart';

class _Body extends StatelessWidget {
  const _Body({required this.state});

  final DailyWirdState state;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    if (state.requestState == RequestState.loading && state.settings == null) {
      return const DailyWirdThinLoader();
    }

    if (state.requiresPresetSelection) {
      return _PresetSelectionSection(presets: state.presets);
    }

    final program = state.program;
    if (program == null) {
      return Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
        child: Text(
          'تعذر إعداد الزاد التعبدي.',
          style: TextStyle(
            color: skin.inkSoft.withValues(alpha: 0.78),
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    final selectedPreset = state.presets.firstWhere(
      (preset) => preset.id == state.settings?.selectedPresetId,
      orElse: () => state.presets.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.actionState == RequestState.loading)
          const DailyWirdThinLoader()
        else
          SizedBox(height: 10.h),
        // العنصر المرتفع الوحيد في الصفحة: ملخّص زاد اليوم.
        _SummaryPanel(preset: selectedPreset, state: state),
        SizedBox(height: 6.h),
        skin.divider(),
        const HomeSectionHeader(title: 'أعمال اليوم'),
        for (var i = 0; i < program.items.length; i++)
          _ItemRow(
            index: i,
            item: program.items[i],
            isFirst: i == 0,
            isLast: i == program.items.length - 1,
          ),
        SizedBox(height: 22.h),
      ],
    );
  }
}

/// ملخّص الزاد: اسم البرنامج، ونسبة الإتمام، وخطّ تقدّم رفيع، والمداومة.
class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({required this.preset, required this.state});

  final DailyWirdPreset preset;
  final DailyWirdState state;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final stats = state.stats;
    final percent = (state.program?.completionPercentage ?? 0).round();
    final progress =
        ((state.program?.completionPercentage ?? 0) / 100).clamp(0.0, 1.0);

    return Padding(
      padding: AppSkin.gutter,
      child: Container(
        decoration: BoxDecoration(
          color: skin.raised,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: skin.raisedBorder),
          boxShadow: skin.raisedShadow,
        ),
        padding: EdgeInsets.fromLTRB(12.w, 11.h, 12.w, 11.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        preset.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: skin.ink,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        preset.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: skin.inkSoft.withValues(alpha: 0.78),
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  child: Text(
                    '$percent%',
                    key: ValueKey(percent),
                    style: TextStyle(
                      color: skin.accent,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 9.h),
            DailyWirdProgressLine(value: progress),
            SizedBox(height: 7.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'المداومة ${stats?.streakDays ?? 0} يومًا',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.inkSoft.withValues(alpha: 0.78),
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  'مواظبة الأسبوع '
                  '${(stats?.weeklyAdherence ?? 0).round()}%',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: skin.inkSoft.withValues(alpha: 0.78),
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
