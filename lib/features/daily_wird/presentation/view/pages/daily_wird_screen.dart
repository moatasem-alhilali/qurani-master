import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/snackbar_export.dart';
import 'package:quran_app/core/extensions/snackbar_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_preset_model.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_program_item_model.dart';
import 'package:quran_app/features/daily_wird/presentation/bloc/daily_wird_bloc.dart';
import 'package:quran_app/features/daily_wird/presentation/view/daily_wird_destination_resolver.dart';
import 'package:quran_app/features/daily_wird/presentation/view/pages/daily_wird_focus_screen.dart';
import 'package:quran_app/features/daily_wird/presentation/view/widgets/daily_wird_common.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';

class DailyWirdScreen extends StatelessWidget {
  const DailyWirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

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
          // أرضية واحدة من الترويسة إلى آخر عمل في الزاد.
          return Theme(
            data: Theme.of(context)
                .copyWith(scaffoldBackgroundColor: skin.ground),
            child: AppScaffoldWidget(
              title: 'زاد اليوم والليلة',
              showLargeHeader: false,
              initialOffset: null,
              onRefresh: () async {
                context.read<DailyWirdBloc>().add(const DailyWirdLoadEvent());
              },
              trailing: IconButton(
                tooltip: 'إعدادات الزاد',
                onPressed: state.settings == null
                    ? null
                    : () => _showSettingsSheet(context, state),
                icon: AppIcon(
                  AppIcons.settings,
                  color: state.settings == null
                      ? skin.inkSoft.withValues(alpha: 0.38)
                      : skin.accent,
                  size: 18.sp,
                ),
              ),
              body: ColoredBox(
                color: skin.ground,
                child: _Body(state: state),
              ),
            ),
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
    final skin = AppSkin.of(context);

    var draft = settings;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: skin.ground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return ColoredBox(
              color: skin.ground,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: 20.h),
                children: [
                  SizedBox(height: 10.h),
                  Center(
                    child: Container(
                      width: 34.w,
                      height: 3.h,
                      decoration: BoxDecoration(
                        color: skin.hairline,
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                    ),
                  ),
                  const HomeSectionHeader(title: 'التذكيرات'),
                  _ReminderRow(
                    label: 'أذكار الصباح',
                    value: draft.morningReminderEnabled,
                    time: draft.morningReminderTime,
                    onChanged: (value) => setState(() {
                      draft = draft.copyWith(morningReminderEnabled: value);
                    }),
                    onPickTime: () async {
                      final selected =
                          await _pickTime(context, draft.morningReminderTime);
                      if (selected == null) return;
                      setState(() {
                        draft = draft.copyWith(morningReminderTime: selected);
                      });
                    },
                  ),
                  _ReminderRow(
                    label: 'أذكار المساء',
                    value: draft.eveningReminderEnabled,
                    time: draft.eveningReminderTime,
                    onChanged: (value) => setState(() {
                      draft = draft.copyWith(eveningReminderEnabled: value);
                    }),
                    onPickTime: () async {
                      final selected =
                          await _pickTime(context, draft.eveningReminderTime);
                      if (selected == null) return;
                      setState(() {
                        draft = draft.copyWith(eveningReminderTime: selected);
                      });
                    },
                  ),
                  _ReminderRow(
                    label: 'أذكار النوم',
                    value: draft.nightReminderEnabled,
                    time: draft.nightReminderTime,
                    onChanged: (value) => setState(() {
                      draft = draft.copyWith(nightReminderEnabled: value);
                    }),
                    onPickTime: () async {
                      final selected =
                          await _pickTime(context, draft.nightReminderTime);
                      if (selected == null) return;
                      setState(() {
                        draft = draft.copyWith(nightReminderTime: selected);
                      });
                    },
                  ),
                  _ReminderRow(
                    label: 'محاسبة آخر اليوم',
                    value: draft.endOfDaySummaryEnabled,
                    time: draft.endOfDaySummaryTime,
                    isLast: true,
                    onChanged: (value) => setState(() {
                      draft = draft.copyWith(endOfDaySummaryEnabled: value);
                    }),
                    onPickTime: () async {
                      final selected =
                          await _pickTime(context, draft.endOfDaySummaryTime);
                      if (selected == null) return;
                      setState(() {
                        draft = draft.copyWith(endOfDaySummaryTime: selected);
                      });
                    },
                  ),
                  skin.divider(),
                  const HomeSectionHeader(title: 'البرنامج'),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Wrap(
                      spacing: 6.w,
                      runSpacing: 6.h,
                      children: [
                        for (final preset in state.presets)
                          DailyWirdChoiceChip(
                            label: preset.name,
                            selected: draft.selectedPresetId == preset.id,
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() {
                                draft = draft.copyWith(
                                  selectedPresetId: preset.id,
                                  onboardingCompleted: true,
                                );
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: DailyWirdPrimaryButton(
                      label: 'حفظ التهيئة',
                      icon: AppIcons.save,
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        if (draft.selectedPresetId !=
                                settings.selectedPresetId &&
                            draft.selectedPresetId != null) {
                          dailyWirdBloc.add(
                            DailyWirdSelectPresetEvent(draft.selectedPresetId!),
                          );
                        }
                        dailyWirdBloc.add(DailyWirdUpdateSettingsEvent(draft));
                      },
                    ),
                  ),
                ],
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

/// اختيار البرنامج أول مرّة: صفوف نحيلة، وكل صفّ باب لزادٍ جاهز.
class _PresetSelectionSection extends StatelessWidget {
  const _PresetSelectionSection({required this.presets});

  final List<DailyWirdPreset> presets;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'اختر زادك التعبدي',
                style: TextStyle(
                  color: skin.ink,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'ابدأ ببرنامج جاهز ثم خصّصه كما يناسبك',
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
        skin.divider(),
        for (var i = 0; i < presets.length; i++)
          _PresetRow(
            preset: presets[i],
            isLast: i == presets.length - 1,
          ),
        SizedBox(height: 22.h),
      ],
    );
  }
}

class _PresetRow extends StatelessWidget {
  const _PresetRow({required this.preset, required this.isLast});

  final DailyWirdPreset preset;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        context.read<DailyWirdBloc>().add(
              DailyWirdSelectPresetEvent(preset.id),
            );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        padding: EdgeInsets.symmetric(vertical: 11.h),
        child: Row(
          children: [
            const DailyWirdIconChip(icon: AppIcons.quran),
            SizedBox(width: 10.w),
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
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
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
            AppIcon(AppIcons.chevronLeft, color: skin.accent, size: 15.sp),
          ],
        ),
      ),
    );
  }
}

/// صفّ عمل واحد من الزاد.
class _ItemRow extends StatelessWidget {
  const _ItemRow({
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
    final skin = AppSkin.of(context);
    final preview = item.contentEntries.isNotEmpty
        ? item.contentEntries.first.text
        : item.contentText;

    return InkWell(
      onTap: () => _openItem(context),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                DailyWirdIconChip(icon: dailyWirdItemIcon(item)),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: skin.ink,
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          decoration: item.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      Text(
                        '${dailyWirdTimeLabel(item.timeCategory)} · '
                        '${dailyWirdTypeLabel(item)}',
                        maxLines: 1,
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
                SizedBox(
                  width: 78.w,
                  child: DailyWirdActionButton(item: item),
                ),
                _ItemMenu(item: item, isFirst: isFirst, isLast: isLast),
              ],
            ),
            if (preview.trim().isNotEmpty) ...[
              SizedBox(height: 6.h),
              Text(
                preview,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.7),
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ],
            SizedBox(height: 7.h),
            DailyWirdProgressLine(value: item.progress),
          ],
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

    final bloc = context.read<DailyWirdBloc>();

    await Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 360),
        reverseTransitionDuration: const Duration(milliseconds: 260),
        pageBuilder: (context, animation, secondaryAnimation) {
          return BlocProvider.value(
            value: bloc,
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
}

/// قائمة خيارات العمل: ترتيب، وإعادة، وتعديل العدد، وإخفاء.
class _ItemMenu extends StatelessWidget {
  const _ItemMenu({
    required this.item,
    required this.isFirst,
    required this.isLast,
  });

  final DailyWirdItem item;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return PopupMenuButton<_ItemAction>(
      tooltip: 'خيارات العمل',
      color: skin.raised,
      surfaceTintColor: skin.raised,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: skin.hairline),
      ),
      padding: EdgeInsets.zero,
      icon: AppIcon(AppIcons.more, color: skin.accent, size: 15.sp),
      onSelected: (value) async {
        final bloc = context.read<DailyWirdBloc>();
        switch (value) {
          case _ItemAction.reset:
            bloc.add(DailyWirdResetItemEvent(item.id));
          case _ItemAction.editCount:
            final count = await showDailyWirdCountSheet(
              context,
              currentValue: item.countRequired ?? 1,
            );
            if (count != null) {
              bloc.add(DailyWirdUpdateItemCountEvent(item.id, count));
            }
          case _ItemAction.hide:
            bloc.add(DailyWirdHideItemEvent(item.id));
          case _ItemAction.moveUp:
            bloc.add(
              DailyWirdMoveItemEvent(itemId: item.id, direction: -1),
            );
          case _ItemAction.moveDown:
            bloc.add(
              DailyWirdMoveItemEvent(itemId: item.id, direction: 1),
            );
        }
      },
      itemBuilder: (context) => [
        if (item.hasCounter)
          _menuItem(context, _ItemAction.editCount, 'تعديل العدد المقصود'),
        _menuItem(context, _ItemAction.reset, 'البدء من جديد'),
        if (!isFirst)
          _menuItem(context, _ItemAction.moveUp, 'تقديم في الترتيب'),
        if (!isLast)
          _menuItem(context, _ItemAction.moveDown, 'تأخير في الترتيب'),
        _menuItem(context, _ItemAction.hide, 'إخفاء من الزاد'),
      ],
    );
  }

  PopupMenuItem<_ItemAction> _menuItem(
    BuildContext context,
    _ItemAction value,
    String label,
  ) {
    final skin = AppSkin.of(context);
    return PopupMenuItem<_ItemAction>(
      value: value,
      height: 36.h,
      child: Text(
        label,
        style: TextStyle(
          color: skin.ink,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// صفّ تذكير: مفتاح، ثم اسم التذكير ووقته.
class _ReminderRow extends StatelessWidget {
  const _ReminderRow({
    required this.label,
    required this.value,
    required this.time,
    required this.onChanged,
    required this.onPickTime,
    this.isLast = false,
  });

  final String label;
  final bool value;
  final String time;
  final ValueChanged<bool> onChanged;
  final Future<void> Function() onPickTime;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      padding: EdgeInsets.symmetric(vertical: 9.h),
      child: Row(
        children: [
          AdaptiveSwitch(
            value: value,
            onChanged: (next) {
              HapticFeedback.selectionClick();
              onChanged(next);
            },
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: skin.ink,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ),
          InkWell(
            onTap: onPickTime,
            borderRadius: BorderRadius.circular(999.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcon(AppIcons.clock, color: skin.accent, size: 13.sp),
                  SizedBox(width: 5.w),
                  Text(
                    time,
                    style: TextStyle(
                      color: skin.accent,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w600,
                      fontFeatures: const [FontFeature.tabularFigures()],
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

/// شارة اختيار البرنامج داخل ورقة الإعدادات.
class DailyWirdChoiceChip extends StatelessWidget {
  const DailyWirdChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.gold : skin.raised,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(color: selected ? AppColors.gold : skin.hairline),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.brandIvory : skin.ink,
            fontSize: 10.sp,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
          ),
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
