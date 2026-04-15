import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/extensions/snackbar_extension.dart';
import 'package:quran_app/core/extensions/snackbar_export.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/util/my_extensions.dart';
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
              icon: const Icon(Icons.tune_rounded),
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
            'ابدأ ببرنامج تعبدي جاهز، ثم خصص العدد وأخف ما لا تريد ورتب عناصر الزاد كما يناسبك.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.onSurfaceColor.withValues(alpha: 0.74),
                ),
          ),
          SizedBox(height: 20.h),
          ...presets.map(
            (preset) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: CardWidget(
                padding: EdgeInsets.all(18.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      preset.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      preset.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                context.onSurfaceColor.withValues(alpha: 0.74),
                          ),
                    ),
                    SizedBox(height: 12.h),
                    FilledButton(
                      onPressed: () {
                        context.read<DailyWirdBloc>().add(
                              DailyWirdSelectPresetEvent(preset.id),
                            );
                      },
                      child: const Text('اعتماد هذا البرنامج'),
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
    final progress = ((state.program?.completionPercentage ?? 0) / 100)
        .clamp(0, 1)
        .toDouble();

    return CardWidget(
      padding: EdgeInsets.all(18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      preset.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      preset.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                context.onSurfaceColor.withValues(alpha: 0.72),
                          ),
                    ),
                  ],
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  child: Text(
                    '${(state.program?.completionPercentage ?? 0).round()}%',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: context.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          LinearProgressIndicator(value: progress),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  label: 'المداومة',
                  value: '${stats?.streakDays ?? 0} يوم',
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _StatBox(
                  label: 'نسبة المواظبة',
                  value: '${(stats?.weeklyAdherence ?? 0).round()}%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
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
    required this.item,
    required this.isFirst,
    required this.isLast,
  });

  final DailyWirdItem item;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            decoration: item.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      '${_timeCategoryLabel(item.timeCategory)} • ${_typeLabel(item)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                context.onSurfaceColor.withValues(alpha: 0.7),
                          ),
                    ),
                  ],
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: item.isCompleted
                      ? Colors.green.withValues(alpha: 0.12)
                      : context.primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  child: Text(
                    item.hasCounter
                        ? '${item.countCompleted}/${item.countRequired ?? 0}'
                        : (item.isCompleted ? 'تم' : 'غير مكتمل'),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          LinearProgressIndicator(value: item.progress),
          SizedBox(height: 12.h),
          Text(
            item.contentEntries.isNotEmpty
                ? item.contentEntries.first.text
                : item.contentText,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.7,
                ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    final destination =
                        DailyWirdDestinationResolver.resolve(item);
                    if (destination != null) {
                      context.push(destination);
                      return;
                    }

                    context.push(
                      BlocProvider.value(
                        value: context.read<DailyWirdBloc>(),
                        child: DailyWirdFocusScreen(itemId: item.id),
                      ),
                    );
                  },
                  child: const Text('المتابعة'),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: FilledButton(
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
                  child: Text(
                    item.hasCounter
                        ? (item.isCompleted ? 'أُنجز' : 'احتساب')
                        : (item.isCompleted ? 'إلغاء الإتمام' : 'إتمام'),
                  ),
                ),
              ),
              PopupMenuButton<_ItemAction>(
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
                              DailyWirdUpdateItemCountEvent(item.id, count),
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
    );
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
