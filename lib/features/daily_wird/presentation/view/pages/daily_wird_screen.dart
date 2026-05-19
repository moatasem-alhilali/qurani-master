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
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'إعدادات الزاد التعبدي',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
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
                    Text(
                      'اختيار البرنامج التعبدي',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
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
                    FilledButton(
                      onPressed: () {
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
                      child: const Text('حفظ التهيئة'),
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
    final selected = await showTimePicker(
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
      return const Center(child: CircularProgressIndicator());
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
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.actionState == RequestState.loading)
            const LinearProgressIndicator(),
          _SummaryCard(
            preset: selectedPreset,
            state: state,
          ),
          SizedBox(height: 16.h),
          ...program.items.asMap().entries.map<Widget>(
                (MapEntry<int, DailyWirdItem> entry) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
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
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'اختر زادك التعبدي',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            'ابدأ ببرنامج تعبدي جاهز، ثم خصص العدد وأخف ما لا تريد '
            'ورتب عناصر الزاد كما يناسبك.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.onSurfaceColor.withValues(alpha: 0.74),
                ),
          ),
          SizedBox(height: 20.h),
          ...presets.map(
            (preset) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22.r),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      context.surfaceColor,
                      context.surfaceVariant.withValues(alpha: 0.9),
                    ],
                  ),
                  border: Border.all(
                    color: context.outline.withValues(alpha: 0.12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.shadow.withValues(alpha: 0.08),
                      blurRadius: 18.r,
                      offset: Offset(0, 10.h),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22.r),
                  child: Stack(
                    children: [
                      _TopAccentLine(color: context.primaryColor),
                      Padding(
                        padding: EdgeInsets.all(18.w),
                        child: Row(
                          children: [
                            _IconBadge(
                              heroTag: 'preset_${preset.id}',
                              icon: AppIcons.quran,
                              color: context.primaryColor,
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    preset.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    preset.description,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: context.onSurfaceColor
                                              .withValues(alpha: 0.72),
                                        ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: FilledButton(
                                      onPressed: () {
                                        context.read<DailyWirdBloc>().add(
                                              DailyWirdSelectPresetEvent(
                                                preset.id,
                                              ),
                                            );
                                      },
                                      child: const Text('اعتماد البرنامج'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
        borderRadius: BorderRadius.circular(22.r),
        color: context.surfaceColor,
        border: Border.all(
          color: context.outline.withValues(alpha: 0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: context.shadow.withValues(alpha: 0.05),
            blurRadius: 14.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.r),
        child: Stack(
          children: [
            _TopAccentLine(color: context.primaryColor),
            Positioned(
              left: -18.w,
              top: 14.h,
              child: Container(
                width: 58.w,
                height: 58.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.primaryColor.withValues(alpha: 0.04),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
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
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SoftLabel(
                              label: 'برنامج اليوم',
                              color: context.primaryColor,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              preset.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              preset.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
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
                  SizedBox(height: 14.h),
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
                          SizedBox(height: 8.h),
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
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _StatBox(
                          label: 'المداومة',
                          value: '${stats?.streakDays ?? 0} يوم',
                          color: context.primaryColor,
                        ),
                      ),
                      SizedBox(width: 10.w),
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
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: color.withValues(alpha: 0.12),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.onSurfaceColor.withValues(alpha: 0.68),
                  ),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
          borderRadius: BorderRadius.circular(20.r),
          color: context.surfaceColor,
          border: Border.all(
            color: item.isCompleted
                ? accentColor.withValues(alpha: 0.18)
                : context.outline.withValues(alpha: 0.10),
          ),
          boxShadow: [
            BoxShadow(
              color: context.shadow.withValues(alpha: 0.04),
              blurRadius: 12.r,
              offset: Offset(0, 7.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            children: [
              _TopAccentLine(color: accentColor),
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 13.h, 14.w, 12.h),
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
                        SizedBox(width: 12.w),
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
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      decoration: item.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                              ),
                              SizedBox(height: 3.h),
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
                    SizedBox(height: 10.h),
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
                    SizedBox(height: 10.h),
                    Text(
                      item.contentEntries.isNotEmpty
                          ? item.contentEntries.first.text
                          : item.contentText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 13.sp,
                            height: 1.6,
                            color:
                                context.onSurfaceColor.withValues(alpha: 0.82),
                          ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _openItem(context),
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size.fromHeight(38.h),
                              padding: EdgeInsets.symmetric(vertical: 0.h),
                              side: BorderSide(
                                color: accentColor.withValues(alpha: 0.18),
                              ),
                            ),
                            child: const Text('دخول'),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              minimumSize: Size.fromHeight(38.h),
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
                            minimumSize: Size(38.w, 38.w),
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
        height: 2.h,
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
      width: 42.w,
      height: 42.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        color: color.withValues(alpha: 0.08),
        border: Border.all(
          color: color.withValues(alpha: 0.10),
        ),
      ),
      child: Center(
        child: Container(
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: color.withValues(alpha: 0.90),
          ),
          child: AppIcon(
            icon,
            color: context.onPrimaryColor,
            size: 14.sp,
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
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: color.withValues(alpha: 0.08),
        ),
      ),
      child: Text(
        value,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontSize: 12.sp,
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
        minHeight: 6.h,
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
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: 10.sp,
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
      margin: EdgeInsets.only(bottom: 10.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
        title: Text(label),
        subtitle: Text(time),
        leading: Switch(
          value: value,
          onChanged: onChanged,
        ),
        trailing: TextButton(
          onPressed: onPickTime,
          child: const Text('الوقت'),
        ),
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
