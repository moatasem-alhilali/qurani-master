import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
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
          body: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                CardWidget(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resolvedItem.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        _timeCategoryLabel(resolvedItem.timeCategory),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: context.primaryColor,
                            ),
                      ),
                      if ((resolvedItem.fadhl ?? '').isNotEmpty) ...[
                        SizedBox(height: 12.h),
                        Text(
                          resolvedItem.fadhl!,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: context.onSurfaceColor
                                        .withValues(alpha: 0.78),
                                  ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                CardWidget(
                  padding: EdgeInsets.all(18.w),
                  child: SelectableText(
                    _contentText(resolvedItem),
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          height: 1.9,
                          fontFamily: 'naskh',
                        ),
                  ),
                ),
                SizedBox(height: 16.h),
                if (resolvedItem.hasCounter)
                  CardWidget(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    child: Column(
                      children: [
                        Text(
                          resolvedItem.countUnit == null
                              ? '${resolvedItem.countCompleted} / ${resolvedItem.countRequired ?? 0}'
                              : '${resolvedItem.countCompleted} / ${resolvedItem.countRequired ?? 0} ${resolvedItem.countUnit}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  context.read<DailyWirdBloc>().add(
                                        DailyWirdResetItemEvent(
                                          resolvedItem.id,
                                        ),
                                      );
                                },
                                child: const Text('البدء من جديد'),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: FilledButton(
                                onPressed: resolvedItem.isCompleted
                                    ? null
                                    : () {
                                        context.read<DailyWirdBloc>().add(
                                              DailyWirdIncrementItemEvent(
                                                resolvedItem.id,
                                              ),
                                            );
                                      },
                                child: Text(
                                  resolvedItem.isCompleted
                                      ? 'أُنجز'
                                      : 'احتساب مرة',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                else
                  FilledButton(
                    onPressed: () {
                      context.read<DailyWirdBloc>().add(
                            DailyWirdToggleItemEvent(resolvedItem.id),
                          );
                    },
                    child: Text(
                      resolvedItem.isCompleted
                          ? 'إلغاء الإتمام'
                          : 'إتمام هذا العمل',
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _contentText(DailyWirdItem item) {
    if (item.contentEntries.isEmpty) {
      return item.contentText;
    }

    return item.contentEntries
        .map(
          (entry) => [
            if (entry.title.isNotEmpty) entry.title,
            entry.text,
          ].join('\n'),
        )
        .join('\n\n');
  }

  String _timeCategoryLabel(String value) {
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
