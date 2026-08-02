import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/snackbar_export.dart';
import 'package:quran_app/core/extensions/snackbar_extension.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_preset_model.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_program_item_model.dart';
import 'package:quran_app/features/daily_wird/presentation/bloc/daily_wird_bloc.dart';
import 'package:quran_app/features/daily_wird/presentation/view/daily_wird_destination_resolver.dart';
import 'package:quran_app/features/daily_wird/presentation/view/pages/daily_wird_focus_screen.dart';

class DailyWirdScreen extends StatelessWidget {
  const DailyWirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DailyWirdBloc>()..add(const DailyWirdLoadEvent()),
      child: BlocConsumer<DailyWirdBloc, DailyWirdState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage &&
            current.errorMessage != null,
        listener: (context, state) {
          context.showCustomSnackbar(
            state.errorMessage ?? 'حدث خطأ غير متوقع.',
            style: SnackBarType.error,
          );
        },
        builder: (context, state) {
          return AppScaffoldWidget(
            title: 'زاد اليوم والليلة',
            showLargeHeader: false,
            initialOffset: null,
            onRefresh: () async {
              context.read<DailyWirdBloc>().add(const DailyWirdLoadEvent());
            },
            trailing: IconButton(
              onPressed: state.settings == null
                  ? null
                  : () => _showSettingsSheet(context, state),
              icon: const AppIcon(AppIcons.settings),
            ),
            body: _Body(state: state),
          );
        },
      ),
    );
  }

  Future<void> _showSettingsSheet(
    BuildContext context,
    DailyWirdState state,
  ) async {
    final settings = state.settings;
    if (settings == null) {
      return;
    }
    final dailyWirdBloc = context.read<DailyWirdBloc>();

    var draft = settings;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.scaffoldBackgroundColor,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 24.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 38.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: context.outlineVariant.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        _IconBadge(
                          icon: AppIcons.settings,
                          color: context.primaryColor,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'إعدادات الزاد التعبدي',
                                style: TextStyle(
                                  color: context.onSurfaceColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                'التذكيرات والبرنامج اليومي في مكان واحد',
                                style: TextStyle(
                                  color: context.onSurfaceVariant,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    _ReminderTile(
                      label: 'تذكير أذكار الصباح',
                      value: draft.morningReminderEnabled,
                      time: draft.morningReminderTime,
                      onChanged: (value) {
                        setState(() {
                          draft = draft.copyWith(
                            morningReminderEnabled: value,
                          );
                        });
                      },
                      onPickTime: () async {
                        final selected = await _pickTime(
                          context,
                          draft.morningReminderTime,
                        );
                        if (selected == null) {
                          return;
                        }
                        setState(() {
                          draft = draft.copyWith(
                            morningReminderTime: selected,
                          );
                        });
                      },
                    ),
                    _ReminderTile(
                      label: 'تذكير أذكار المساء',
                      value: draft.eveningReminderEnabled,
                      time: draft.eveningReminderTime,
                      onChanged: (value) {
                        setState(() {
                          draft = draft.copyWith(
                            eveningReminderEnabled: value,
                          );
                        });
                      },
                      onPickTime: () async {
                        final selected = await _pickTime(
                          context,
                          draft.eveningReminderTime,
                        );
                        if (selected == null) {
                          return;
                        }
                        setState(() {
                          draft = draft.copyWith(
                            eveningReminderTime: selected,
                          );
                        });
                      },
                    ),
                    _ReminderTile(
                      label: 'تذكير أذكار النوم',
                      value: draft.nightReminderEnabled,
                      time: draft.nightReminderTime,
                      onChanged: (value) {
                        setState(() {
                          draft = draft.copyWith(nightReminderEnabled: value);
                        });
                      },
                      onPickTime: () async {
                        final selected = await _pickTime(
                          context,
                          draft.nightReminderTime,
                        );
                        if (selected == null) {
                          return;
                        }
                        setState(() {
                          draft = draft.copyWith(nightReminderTime: selected);
                        });
                      },
                    ),
                    _ReminderTile(
                      label: 'تذكير محاسبة آخر اليوم',
                      value: draft.endOfDaySummaryEnabled,
                      time: draft.endOfDaySummaryTime,
                      onChanged: (value) {
                        setState(() {
                          draft = draft.copyWith(
                            endOfDaySummaryEnabled: value,
                          );
                        });
                      },
                      onPickTime: () async {
                        final selected = await _pickTime(
                          context,
                          draft.endOfDaySummaryTime,
                        );
                        if (selected == null) {
                          return;
                        }
                        setState(() {
                          draft = draft.copyWith(
                            endOfDaySummaryTime: selected,
                          );
                        });
                      },
                    ),
                    SizedBox(height: 12.h),
                    const _SectionTitle(
                      title: 'اختيار البرنامج',
                      subtitle: 'اختر قالب الزاد المناسب ليومك',
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: state.presets
                          .map(
                            (preset) => ChoiceChip(
                              label: Text(preset.name),
                              selected: draft.selectedPresetId == preset.id,
                              onSelected: (_) {
                                setState(() {
                                  draft = draft.copyWith(
                                    selectedPresetId: preset.id,
                                    onboardingCompleted: true,
                                  );
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 20.h),
                    InkWell(
                      borderRadius: BorderRadius.circular(14.r),
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        if (draft.selectedPresetId !=
                                settings.selectedPresetId &&
                            draft.selectedPresetId != null) {
                          dailyWirdBloc.add(
                            DailyWirdSelectPresetEvent(
                              draft.selectedPresetId!,
                            ),
                          );
                        }
                        dailyWirdBloc.add(
                          DailyWirdUpdateSettingsEvent(draft),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: context.primaryColor,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppIcon(
                              AppIcons.save,
                              color: context.onPrimaryColor,
                              size: 14.sp,
                              strokeWidth: 1.55,
                            ),
                            SizedBox(width: 7.w),
                            Text(
                              'حفظ التهيئة',
                              style: TextStyle(
                                color: context.onPrimaryColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<String?> _pickTime(BuildContext context, String initialValue) async {
    final parts = initialValue.split(':');
    final initial = TimeOfDay(
      hour: int.tryParse(parts.first) ?? 7,
      minute: parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0,
    );
    final selected = await AdaptiveTimePicker.show(
      context: context,
      initialTime: initial,
    );
    if (selected == null) {
      return null;
    }
    return _toTimeString(selected);
  }

  String _toTimeString(TimeOfDay value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state});

  final DailyWirdState state;

  @override
  Widget build(BuildContext context) {
    if (state.requestState == RequestState.loading && state.settings == null) {
      return Center(
        child: CircularProgressIndicator(color: context.primaryColor),
      );
    }

    if (state.requiresPresetSelection) {
      return _PresetSelectionSection(presets: state.presets);
    }

    final program = state.program;
    if (program == null) {
      return const Center(
        child: Text('تعذر إعداد الزاد التعبدي.'),
      );
    }

    final selectedPreset = state.presets.firstWhere(
      (preset) => preset.id == state.settings?.selectedPresetId,
      orElse: () => state.presets.first,
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 28.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.actionState == RequestState.loading) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(999.r),
              child: LinearProgressIndicator(
                minHeight: 3.h,
                color: context.primaryColor,
                backgroundColor: context.primaryColor.withValues(alpha: 0.08),
              ),
            ),
            SizedBox(height: 8.h),
          ],
          _SummaryCard(
            preset: selectedPreset,
            state: state,
          ),
          SizedBox(height: 10.h),
          ...program.items.asMap().entries.map<Widget>(
                (MapEntry<int, DailyWirdItem> entry) => Padding(
                  padding: EdgeInsets.only(bottom: 9.h),
                  child: _ItemCard(
                    index: entry.key,
                    item: entry.value,
                    isFirst: entry.key == 0,
                    isLast: entry.key == program.items.length - 1,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _PresetSelectionSection extends StatelessWidget {
  const _PresetSelectionSection({required this.presets});

  final List<DailyWirdPreset> presets;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _SoftPanel(
            padding: EdgeInsets.all(14.w),
            child: Row(
              children: [
                _IconBadge(
                  icon: AppIcons.bookOpen,
                  color: context.primaryColor,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اختر زادك التعبدي',
                        style: TextStyle(
                          color: context.onSurfaceColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'ابدأ ببرنامج جاهز ثم خصصه كما يناسبك',
                        style: TextStyle(
                          color: context.onSurfaceVariant,
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          ...presets.map(
            (preset) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: _SoftPanel(
                padding: EdgeInsets.all(13.w),
                child: Row(
                  children: [
                    _IconBadge(
                      heroTag: 'preset_${preset.id}',
                      icon: AppIcons.quran,
                      color: context.primaryColor,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            preset.name,
                            style: TextStyle(
                              color: context.onSurfaceColor,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            preset.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: context.onSurfaceVariant,
                              fontSize: 10.sp,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    _SmallTextButton(
                      label: 'اعتماد',
                      onTap: () {
                        context.read<DailyWirdBloc>().add(
                              DailyWirdSelectPresetEvent(preset.id),
                            );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 5.w,
          height: 5.w,
          decoration: BoxDecoration(
            color: context.primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 7.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: context.onSurfaceColor,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: TextStyle(
                  color: context.onSurfaceVariant,
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SoftPanel extends StatelessWidget {
  const _SoftPanel({
    required this.child,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      padding: padding ?? EdgeInsets.all(12.w),
      borderRadius: BorderRadius.circular(17.r),
      border: Border.all(
        color: context.outline.withValues(alpha: 0.10),
      ),
      color: context.surfaceColor,
      child: child,
    );
  }
}

class _SmallTextButton extends StatelessWidget {
  const _SmallTextButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: context.primaryColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: context.primaryColor.withValues(alpha: 0.12),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: context.primaryColor,
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.preset,
    required this.state,
  });

  final DailyWirdPreset preset;
  final DailyWirdState state;

  @override
  Widget build(BuildContext context) {
    final stats = state.stats;
    final completionPercent =
        (state.program?.completionPercentage ?? 0).round();
    final progress = ((state.program?.completionPercentage ?? 0) / 100)
        .clamp(0, 1)
        .toDouble();

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: context.surfaceColor,
        border: Border.all(
          color: context.outline.withValues(alpha: 0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: context.shadow.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: Stack(
          children: [
            _TopAccentLine(color: context.primaryColor),
            Padding(
              padding: EdgeInsets.all(13.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _IconBadge(
                        heroTag: 'daily_wird_program_badge',
                        icon: AppIcons.bookOpen,
                        color: context.primaryColor,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SoftLabel(
                              label: 'برنامج اليوم',
                              color: context.primaryColor,
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              preset.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              preset.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontSize: 10.5.sp,
                                    color: context.onSurfaceColor
                                        .withValues(alpha: 0.72),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 260),
                        child: _SoftValuePill(
                          key: ValueKey(completionPercent),
                          value: '$completionPercent%',
                          color: context.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 11.h),
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                    tween: Tween<double>(begin: 0, end: progress),
                    builder: (context, value, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SoftProgressBar(
                            value: value,
                            color: context.primaryColor,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'أكملت '
                            '$completionPercent%'
                            ' من زادك اليوم',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: context.onSurfaceColor
                                          .withValues(alpha: 0.72),
                                    ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: _StatBox(
                          label: 'المداومة',
                          value: '${stats?.streakDays ?? 0} يوم',
                          color: context.primaryColor,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _StatBox(
                          label: 'نسبة المواظبة',
                          value: '${(stats?.weeklyAdherence ?? 0).round()}%',
                          color: context.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(13.r),
        border: Border.all(
          color: color.withValues(alpha: 0.12),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10.sp,
                    color: context.onSurfaceColor.withValues(alpha: 0.68),
                  ),
            ),
            SizedBox(height: 3.h),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.index,
    required this.item,
    required this.isFirst,
    required this.isLast,
  });

  final int index;
  final DailyWirdItem item;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final accentColor = _accentColor(context);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 220 + (index * 40)),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 18.h),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17.r),
          color: context.surfaceColor,
          border: Border.all(
            color: item.isCompleted
                ? accentColor.withValues(alpha: 0.18)
                : context.outline.withValues(alpha: 0.10),
          ),
          boxShadow: [
            BoxShadow(
              color: context.shadow.withValues(alpha: 0.04),
              blurRadius: 9.r,
              offset: Offset(0, 5.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(17.r),
          child: Stack(
            children: [
              _TopAccentLine(color: accentColor),
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 11.h, 12.w, 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Hero(
                          tag: 'daily_wird_item_badge_${item.id}',
                          child: Material(
                            color: Colors.transparent,
                            child: _IconBadge(
                              icon: _itemIcon(item),
                              color: accentColor,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontSize: 13.5.sp,
                                      fontWeight: FontWeight.w700,
                                      decoration: item.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                              ),
                              SizedBox(height: 4.h),
                              Wrap(
                                spacing: 6.w,
                                runSpacing: 4.h,
                                children: [
                                  _MetaChip(
                                    label: _timeCategoryLabel(
                                      item.timeCategory,
                                    ),
                                    color: accentColor,
                                  ),
                                  _MetaChip(
                                    label: _typeLabel(item),
                                    color: context.secondaryColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          child: _SoftValuePill(
                            key: ValueKey(
                              item.hasCounter
                                  ? '${item.countCompleted}_'
                                      '${item.countRequired}'
                                  : item.isCompleted,
                            ),
                            value: item.hasCounter
                                ? '${item.countCompleted}/${item.countRequired ?? 0}'
                                : (item.isCompleted ? 'تم' : 'قيد العمل'),
                            color:
                                item.isCompleted ? Colors.green : accentColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 360),
                      curve: Curves.easeOutCubic,
                      tween: Tween<double>(begin: 0, end: item.progress),
                      builder: (context, value, _) {
                        return _SoftProgressBar(
                          value: value,
                          color: accentColor,
                        );
                      },
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      item.contentEntries.isNotEmpty
                          ? item.contentEntries.first.text
                          : item.contentText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 11.5.sp,
                            height: 1.55,
                            color:
                                context.onSurfaceColor.withValues(alpha: 0.82),
                          ),
                    ),
                    SizedBox(height: 9.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _openItem(context),
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size.fromHeight(34.h),
                              padding: EdgeInsets.symmetric(vertical: 0.h),
                              side: BorderSide(
                                color: accentColor.withValues(alpha: 0.18),
                              ),
                            ),
                            child: const Text('دخول'),
                          ),
                        ),
                        SizedBox(width: 7.w),
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              minimumSize: Size.fromHeight(34.h),
                              padding: EdgeInsets.symmetric(vertical: 0.h),
                              backgroundColor:
                                  accentColor.withValues(alpha: 0.16),
                              foregroundColor: accentColor,
                              elevation: 0,
                            ),
                            onPressed: () {
                              if (item.hasCounter) {
                                context.read<DailyWirdBloc>().add(
                                      DailyWirdIncrementItemEvent(item.id),
                                    );
                                return;
                              }
                              context.read<DailyWirdBloc>().add(
                                    DailyWirdToggleItemEvent(item.id),
                                  );
                            },
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Text(
                                item.hasCounter
                                    ? (item.isCompleted ? 'أُنجز' : 'احتساب')
                                    : (item.isCompleted
                                        ? 'إلغاء الإتمام'
                                        : 'إتمام'),
                                key: ValueKey(
                                  '${item.isCompleted}_${item.countCompleted}',
                                ),
                              ),
                            ),
                          ),
                        ),
                        PopupMenuButton<_ItemAction>(
                          style: IconButton.styleFrom(
                            minimumSize: Size(34.w, 34.w),
                            padding: EdgeInsets.zero,
                          ),
                          onSelected: (value) async {
                            switch (value) {
                              case _ItemAction.reset:
                                context.read<DailyWirdBloc>().add(
                                      DailyWirdResetItemEvent(item.id),
                                    );
                              case _ItemAction.editCount:
                                final count = await _showCountDialog(
                                  context,
                                  item.countRequired ?? 1,
                                );
                                if (count != null && context.mounted) {
                                  context.read<DailyWirdBloc>().add(
                                        DailyWirdUpdateItemCountEvent(
                                          item.id,
                                          count,
                                        ),
                                      );
                                }
                              case _ItemAction.hide:
                                if (!context.mounted) {
                                  return;
                                }
                                context.read<DailyWirdBloc>().add(
                                      DailyWirdHideItemEvent(item.id),
                                    );
                              case _ItemAction.moveUp:
                                context.read<DailyWirdBloc>().add(
                                      DailyWirdMoveItemEvent(
                                        itemId: item.id,
                                        direction: -1,
                                      ),
                                    );
                              case _ItemAction.moveDown:
                                context.read<DailyWirdBloc>().add(
                                      DailyWirdMoveItemEvent(
                                        itemId: item.id,
                                        direction: 1,
                                      ),
                                    );
                            }
                          },
                          itemBuilder: (context) => [
                            if (item.hasCounter)
                              const PopupMenuItem(
                                value: _ItemAction.editCount,
                                child: Text('تعديل العدد المقصود'),
                              ),
                            const PopupMenuItem(
                              value: _ItemAction.reset,
                              child: Text('البدء من جديد'),
                            ),
                            if (!isFirst)
                              const PopupMenuItem(
                                value: _ItemAction.moveUp,
                                child: Text('تقديم في الترتيب'),
                              ),
                            if (!isLast)
                              const PopupMenuItem(
                                value: _ItemAction.moveDown,
                                child: Text('تأخير في الترتيب'),
                              ),
                            const PopupMenuItem(
                              value: _ItemAction.hide,
                              child: Text('إخفاء من الزاد'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openItem(BuildContext context) async {
    final destination = DailyWirdDestinationResolver.resolve(item);
    if (destination != null) {
      context.push(destination);
      return;
    }

    await Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 360),
        reverseTransitionDuration: const Duration(milliseconds: 260),
        pageBuilder: (context, animation, secondaryAnimation) {
          return BlocProvider.value(
            value: context.read<DailyWirdBloc>(),
            child: DailyWirdFocusScreen(itemId: item.id),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  Color _accentColor(BuildContext context) {
    switch (item.type) {
      case 'quran':
      case 'surah':
        return context.primaryColor;
      case 'dua':
        return context.secondaryColor;
      default:
        return context.primaryColor;
    }
  }

  HugeIconData _itemIcon(DailyWirdItem item) {
    switch (item.type) {
      case 'dhikr_set':
        return AppIcons.moon;
      case 'counted_dhikr':
        return AppIcons.tasbih;
      case 'quran':
        return AppIcons.quran;
      case 'dua':
        return AppIcons.heart;
      case 'surah':
        return AppIcons.bookOpen;
      default:
        return AppIcons.check;
    }
  }

  Future<int?> _showCountDialog(BuildContext context, int currentValue) async {
    final controller = TextEditingController(text: '$currentValue');
    return showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('تعديل العدد المقصود'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'مثال: 50 مرة',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('رجوع'),
            ),
            FilledButton(
              onPressed: () {
                final parsed = int.tryParse(controller.text.trim());
                if (parsed == null || parsed <= 0) {
                  return;
                }
                Navigator.of(dialogContext).pop(parsed);
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  static String _timeCategoryLabel(String value) {
    switch (value) {
      case 'morning':
        return 'صباح';
      case 'evening':
        return 'مساء';
      case 'night':
        return 'ليل';
      default:
        return 'أي وقت';
    }
  }

  static String _typeLabel(DailyWirdItem item) {
    switch (item.type) {
      case 'dhikr_set':
        return 'أذكار';
      case 'counted_dhikr':
        return 'ذكر بعدد';
      case 'quran':
        return 'ورد قرآن';
      case 'dua':
        return 'دعاء';
      case 'surah':
        return 'سورة';
      default:
        return item.type;
    }
  }
}

class _TopAccentLine extends StatelessWidget {
  const _TopAccentLine({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      left: 0,
      child: Container(
        height: 1.5.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              color,
              color.withValues(alpha: 0.18),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    required this.color,
    this.heroTag,
  });

  final String? heroTag;
  final HugeIconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: color.withValues(alpha: 0.08),
        border: Border.all(
          color: color.withValues(alpha: 0.10),
        ),
      ),
      child: Center(
        child: Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: color.withValues(alpha: 0.90),
          ),
          child: AppIcon(
            icon,
            color: context.onPrimaryColor,
            size: 12.5.sp,
            strokeWidth: 1.55,
          ),
        ),
      ),
    );

    if (heroTag == null) {
      return badge;
    }

    return Hero(
      tag: heroTag!,
      child: Material(
        color: Colors.transparent,
        child: badge,
      ),
    );
  }
}

class _SoftLabel extends StatelessWidget {
  const _SoftLabel({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: color.withValues(alpha: 0.08),
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontSize: 10.sp,
              color: color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _SoftValuePill extends StatelessWidget {
  const _SoftValuePill({
    required this.value,
    required this.color,
    super.key,
  });

  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withValues(alpha: 0.08),
        ),
      ),
      child: Text(
        value,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontSize: 10.5.sp,
              color: color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _SoftProgressBar extends StatelessWidget {
  const _SoftProgressBar({
    required this.value,
    required this.color,
  });

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999.r),
      child: LinearProgressIndicator(
        minHeight: 5.h,
        value: value,
        backgroundColor: color.withValues(alpha: 0.08),
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: 9.5.sp,
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({
    required this.label,
    required this.value,
    required this.time,
    required this.onChanged,
    required this.onPickTime,
  });

  final String label;
  final bool value;
  final String time;
  final ValueChanged<bool> onChanged;
  final Future<void> Function() onPickTime;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
      borderRadius: BorderRadius.circular(15.r),
      border: Border.all(color: context.outline.withValues(alpha: 0.10)),
      color: context.surfaceColor,
      child: Row(
        children: [
          AdaptiveSwitch(
            value: value,
            onChanged: onChanged,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  time,
                  style: TextStyle(
                    color: context.onSurfaceVariant,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: onPickTime,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcon(
                    AppIcons.clock,
                    size: 12.sp,
                    color: context.primaryColor,
                    strokeWidth: 1.55,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'الوقت',
                    style: TextStyle(
                      color: context.primaryColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                    ),
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

enum _ItemAction {
  reset,
  editCount,
  hide,
  moveUp,
  moveDown,
}
