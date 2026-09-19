import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_program_item_model.dart';
import 'package:quran_app/features/daily_wird/presentation/bloc/daily_wird_bloc.dart';
import 'package:quran_app/features/daily_wird/presentation/view/widgets/daily_wird_common.dart';
import 'package:quran_app/gen/fonts.gen.dart';
import 'package:quran_app/l10n/l10n.dart';

/// شاشة عمل واحد من الزاد: النصّ هو البطل، وما حوله سطر واحد لا أكثر.
class DailyWirdFocusScreen extends StatelessWidget {
  const DailyWirdFocusScreen({
    required this.itemId,
    super.key,
  });

  final String itemId;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocBuilder<DailyWirdBloc, DailyWirdState>(
      builder: (context, state) {
        DailyWirdItem? item;
        final program = state.program;
        if (program != null) {
          for (final current in program.items) {
            if (current.id == itemId) {
              item = current;
              break;
            }
          }
        }

        if (item == null) {
          return Scaffold(
            backgroundColor: skin.ground,
            body: Center(
              child: Text(
                context.l10n.dailyWirdItemNotFound,
                style: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.78),
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }

        final resolvedItem = item;

        return Theme(
          data:
              Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
          child: AppScaffoldWidget(
            title: resolvedItem.title,
            showLargeHeader: false,
            initialOffset: null,
            body: ColoredBox(
              color: skin.ground,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _FocusHeader(item: resolvedItem),
                  skin.divider(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
                    child: SelectableText(
                      contentText(resolvedItem),
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: skin.ink,
                        fontFamily: FontFamily.scheherazade,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.9,
                      ),
                    ),
                  ),
                  skin.divider(),
                  if (resolvedItem.hasCounter)
                    _CounterSection(item: resolvedItem)
                  else
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
                      child: DailyWirdPrimaryButton(
                        label: resolvedItem.isCompleted
                            ? context.l10n.dailyWirdUncomplete
                            : context.l10n.dailyWirdCompleteThis,
                        icon: AppIcons.checkSmall,
                        onTap: () {
                          context.read<DailyWirdBloc>().add(
                                DailyWirdToggleItemEvent(resolvedItem.id),
                              );
                        },
                      ),
                    ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static String contentText(DailyWirdItem item) {
    if (item.contentEntries.isEmpty) {
      return item.contentText;
    }

    return item.contentEntries
        .map(
          (entry) => [
            if (entry.title.isNotEmpty) entry.title,
            entry.text,
          ].join('\n\n'),
        )
        .join('\n\n');
  }

  static String timeCategoryLabel(L10n l10n, String value) {
    switch (value) {
      case 'morning':
        return l10n.dailyWirdTimeMorningLong;
      case 'evening':
        return l10n.dailyWirdTimeEveningLong;
      case 'night':
        return l10n.dailyWirdTimeNightLong;
      default:
        return l10n.dailyWirdTimeAnyLong;
    }
  }
}

/// ترويسة العمل: أيقونته ووقته وفضله، بلا بطاقة.
class _FocusHeader extends StatelessWidget {
  const _FocusHeader({required this.item});

  final DailyWirdItem item;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final fadhl = item.fadhl ?? '';

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DailyWirdIconChip(icon: dailyWirdItemIcon(item)),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${DailyWirdFocusScreen.timeCategoryLabel(
                    context.l10n,
                    item.timeCategory,
                  )}'
                  ' · ${dailyWirdTypeLabel(context.l10n, item)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: skin.accent,
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (fadhl.trim().isNotEmpty) ...[
                  SizedBox(height: 3.h),
                  Text(
                    fadhl,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.inkSoft.withValues(alpha: 0.78),
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// عدّاد العمل: رقمه ثم خطّ التقدّم ثم فعلان لا أكثر.
class _CounterSection extends StatelessWidget {
  const _CounterSection({required this.item});

  final DailyWirdItem item;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final unit = item.countUnit == null ? '' : ' ${item.countUnit}';

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  child: Text(
                    context.l10n.dailyWirdCompletedOf(
                      item.countCompleted,
                      item.countRequired ?? 0,
                      unit,
                    ),
                    key: ValueKey(item.countCompleted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.ink,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ),
              Text(
                '${(item.progress * 100).round()}%',
                style: TextStyle(
                  color: skin.accent,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          DailyWirdProgressLine(value: item.progress),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _GhostButton(
                  label: context.l10n.dailyWirdStartOver,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.read<DailyWirdBloc>().add(
                          DailyWirdResetItemEvent(item.id),
                        );
                  },
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: DailyWirdPrimaryButton(
                  label: item.isCompleted
                      ? context.l10n.dailyWirdItemDone
                      : context.l10n.dailyWirdCountOnce,
                  icon: item.isCompleted ? AppIcons.checkSmall : AppIcons.add,
                  onTap: () {
                    if (item.isCompleted) return;
                    HapticFeedback.mediumImpact();
                    context.read<DailyWirdBloc>().add(
                          DailyWirdIncrementItemEvent(item.id),
                        );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// زرّ ثانوي بحدّ شعرة فقط — لا تعبئة تنازع الزرّ الرئيسي.
class _GhostButton extends StatelessWidget {
  const _GhostButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 38.h,
        decoration: BoxDecoration(
          color: skin.raised,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: skin.hairline),
        ),
        child: Center(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: skin.ink,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
