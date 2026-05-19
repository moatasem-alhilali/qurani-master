import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/daily_wird/data/models/daily_wird_program_item_model.dart';
import 'package:quran_app/features/daily_wird/presentation/bloc/daily_wird_bloc.dart';

class DailyWirdFocusScreen extends StatelessWidget {
  const DailyWirdFocusScreen({
    required this.itemId,
    super.key,
  });

  final String itemId;

  @override
  Widget build(BuildContext context) {
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
          return const Scaffold(
            body: Center(
              child: Text('تعذر العثور على عنصر الزاد التعبدي.'),
            ),
          );
        }
        final resolvedItem = item;

        return AppScaffoldWidget(
          title: resolvedItem.title,
          showLargeHeader: false,
          initialOffset: null,
          body: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 22.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _FocusHeaderCard(item: resolvedItem),
                SizedBox(height: 10.h),
                _FocusContentCard(item: resolvedItem),
                SizedBox(height: 10.h),
                if (resolvedItem.hasCounter)
                  _CounterActionCard(item: resolvedItem)
                else
                  FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: Size.fromHeight(38.h),
                      backgroundColor: _accentColor(context, resolvedItem),
                      foregroundColor: context.onPrimaryColor,
                    ),
                    onPressed: () {
                      context.read<DailyWirdBloc>().add(
                            DailyWirdToggleItemEvent(resolvedItem.id),
                          );
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: Text(
                        resolvedItem.isCompleted
                            ? 'إلغاء الإتمام'
                            : 'إتمام هذا العمل',
                        key: ValueKey(resolvedItem.isCompleted),
                      ),
                    ),
                  ),
              ],
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

  static String timeCategoryLabel(String value) {
    switch (value) {
      case 'morning':
        return 'وقت الصباح';
      case 'evening':
        return 'وقت المساء';
      case 'night':
        return 'قبل النوم';
      default:
        return 'في أي وقت';
    }
  }
}

class _FocusHeaderCard extends StatelessWidget {
  const _FocusHeaderCard({required this.item});

  final DailyWirdItem item;

  @override
  Widget build(BuildContext context) {
    final accentColor = _accentColor(context, item);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: context.surfaceColor,
        border: Border.all(
          color: accentColor.withValues(alpha: 0.14),
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
            _FocusTopAccentLine(color: accentColor),
            Padding(
              padding: EdgeInsets.all(13.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'daily_wird_item_badge_${item.id}',
                    child: Material(
                      color: Colors.transparent,
                      child: _FocusBadge(
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
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Text(
                            DailyWirdFocusScreen.timeCategoryLabel(
                              item.timeCategory,
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  fontSize: 10.sp,
                                  color: accentColor,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          item.title,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        if ((item.fadhl ?? '').isNotEmpty) ...[
                          SizedBox(height: 6.h),
                          Text(
                            item.fadhl!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 11.5.sp,
                                  height: 1.55,
                                  color: context.onSurfaceColor
                                      .withValues(alpha: 0.78),
                                ),
                          ),
                        ],
                      ],
                    ),
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

class _FocusContentCard extends StatelessWidget {
  const _FocusContentCard({required this.item});

  final DailyWirdItem item;

  @override
  Widget build(BuildContext context) {
    final accentColor = _accentColor(context, item);

    return CardWidget(
      padding: EdgeInsets.all(13.w),
      borderRadius: BorderRadius.circular(17.r),
      border: Border.all(
        color: context.outline.withValues(alpha: 0.12),
      ),
      color: context.surfaceColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIcon(
                AppIcons.bookOpen,
                size: 13.sp,
                color: accentColor,
                strokeWidth: 1.55,
              ),
              SizedBox(width: 7.w),
              Text(
                'نص الورد',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 13.sp,
                      color: accentColor,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          SelectableText(
            DailyWirdFocusScreen.contentText(item),
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 15.sp,
                  height: 1.9,
                  fontFamily: 'naskh',
                ),
          ),
        ],
      ),
    );
  }
}

class _CounterActionCard extends StatelessWidget {
  const _CounterActionCard({required this.item});

  final DailyWirdItem item;

  @override
  Widget build(BuildContext context) {
    final accentColor = _accentColor(context, item);

    return CardWidget(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 13.h),
      borderRadius: BorderRadius.circular(17.r),
      border: Border.all(
        color: accentColor.withValues(alpha: 0.14),
      ),
      color: accentColor.withValues(alpha: 0.05),
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: Text(
              item.countUnit == null
                  ? '${item.countCompleted} / ${item.countRequired ?? 0}'
                  : '${item.countCompleted} / ${item.countRequired ?? 0} ${item.countUnit}',
              key: ValueKey('${item.countCompleted}_${item.countRequired}'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 21.sp,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
            ),
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: LinearProgressIndicator(
              minHeight: 6.h,
              value: item.progress,
              backgroundColor: accentColor.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            ),
          ),
          SizedBox(height: 11.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.read<DailyWirdBloc>().add(
                          DailyWirdResetItemEvent(item.id),
                        );
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.fromHeight(36.h),
                    side: BorderSide(
                      color: accentColor.withValues(alpha: 0.24),
                    ),
                  ),
                  child: const Text('البدء من جديد'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: Size.fromHeight(36.h),
                    backgroundColor: accentColor,
                    foregroundColor: context.onPrimaryColor,
                  ),
                  onPressed: item.isCompleted
                      ? null
                      : () {
                          context.read<DailyWirdBloc>().add(
                                DailyWirdIncrementItemEvent(item.id),
                              );
                        },
                  child: Text(
                    item.isCompleted ? 'أُنجز' : 'احتساب مرة',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Color _accentColor(BuildContext context, DailyWirdItem item) {
  switch (item.type) {
    case 'quran':
    case 'surah':
      return context.primaryColor;
    case 'dua':
      return context.secondaryColor;
    default:
      return context.primaryContainer;
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

class _FocusBadge extends StatelessWidget {
  const _FocusBadge({
    required this.icon,
    required this.color,
  });

  final HugeIconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38.w,
      height: 38.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.r),
        color: color.withValues(alpha: 0.10),
        border: Border.all(
          color: color.withValues(alpha: 0.14),
        ),
      ),
      child: Center(
        child: Container(
          width: 25.w,
          height: 25.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9.r),
            color: color.withValues(alpha: 0.90),
          ),
          child: AppIcon(
            icon,
            size: 12.5.sp,
            color: context.onPrimaryColor,
            strokeWidth: 1.55,
          ),
        ),
      ),
    );
  }
}

class _FocusTopAccentLine extends StatelessWidget {
  const _FocusTopAccentLine({required this.color});

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
