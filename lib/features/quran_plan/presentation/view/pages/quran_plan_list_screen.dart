import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/extensions/snackbar_extension.dart';
import 'package:quran_app/core/extensions/text_styles_extension.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/animated_snackbar_widget.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_model.dart';
import 'package:quran_app/features/quran_plan/presentation/bloc/quran_plan_bloc.dart';
import 'package:quran_app/features/quran_plan/presentation/view/pages/quran_plan_add_screen.dart';
import 'package:quran_app/features/quran_plan/presentation/view/pages/quran_plan_session_screen.dart';

class QuranPlanListScreen extends StatelessWidget {
  const QuranPlanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuranPlanBloc>(
      create: (_) => sl<QuranPlanBloc>()..add(LoadAllPlansEvent()),
      child: BlocBuilder<QuranPlanBloc, QuranPlanState>(
        builder: (ctx, state) {
          return AppScaffoldWidget(
            title: 'خطط الختم',
            onRefresh: () async {
              ctx.read<QuranPlanBloc>().add(LoadAllPlansEvent());
            },
            floatingActionButton: FloatingActionButton(
              heroTag: 'add_plan',
              onPressed: () {
                context.push(
                  BlocProvider.value(
                    value: ctx.read<QuranPlanBloc>(),
                    child: const QuranPlanAddScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
            trailing: BlocBuilder<QuranPlanBloc, QuranPlanState>(
              builder: (context, state) {
                return GenericSearchAnchorAsync<QuranPlan>(
                  asyncSuggestions: (query) async {
                    return state.plans
                        .where((element) => element.title.contains(query))
                        .toList();
                  },
                  onSelected: (item) {},
                  hintText: 'بحث عن خطة',
                  suggestionBuilder: (context, item) => _Item(plan: item),
                );
              },
            ),
            slivers: [
              BlocBuilder<QuranPlanBloc, QuranPlanState>(
                builder: (context, state) {
                  return state.requestState.whenSliver<QuranPlan>(
                    onSuccess: () {
                      return SliverPadding(
                        padding: const EdgeInsets.all(8),
                        sliver: SliverList.builder(
                          itemCount: state.plans.length,
                          // separatorBuilder: (ctx, i) =>
                          //     const SizedBox(height: 16),
                          itemBuilder: (ctx, i) {
                            final plan = state.plans[i];
                            return _Item(plan: plan);
                          },
                        ),
                      );
                    },
                    context: context,
                    sliverList: state.plans,
                    onLoading: SliverPadding(
                      padding: const EdgeInsets.all(8),
                      sliver: SliverList.separated(
                        itemCount: 5,
                        separatorBuilder: (ctx, i) =>
                            const SizedBox(height: 16),
                        itemBuilder: (ctx, i) {
                          final plans = List.generate(
                            5,
                            (index) => QuranPlan(
                              title: 'title',
                              startJuz: 1,
                              endJuz: 1,
                              totalDays: 1,
                              sessionsCount: 1,
                              versesPerSession: 1,
                              ownerId: '1',
                              createdAt: DateTime.now(),
                            ),
                          );
                          return ShimmerSkeletonizerWidget(
                            child: Container(
                              margin: EdgeInsets.all(8.w),
                              padding: EdgeInsets.all(8.w),
                              child: ListTile(
                                title: Text(
                                  plans[i].title,
                                  style: context.bodyMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  'من الجزء ${plans[i].startJuz} إلى ${plans[i].endJuz} • أيام: ${plans[i].totalDays}',
                                  style: context.bodyMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {},
                                ),
                                onTap: () {},
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.plan,
    super.key,
  });

  final QuranPlan plan;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16.r);
    final cardBorder = context.outline.withValues(alpha: 0.85);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.surfaceColor,
            context.surfaceVariant.withValues(alpha: 0.42),
          ],
        ),
        border: Border.all(
          color: cardBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: context.shadow.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: InkWell(
          onTap: () {
            context.push(
              QuranPlanSessionScreen(
                planId: plan.id!,
                title: plan.title,
              ),
            );
          },
          child: Stack(
            children: [
              Positioned(
                bottom: -20.h,
                left: -20.w,
                child: Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.primaryColor.withValues(alpha: 0.04),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 8.w, 16.h),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.menu_book_rounded,
                        color: context.primaryColor,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plan.title,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w800,
                              color: context.onSurfaceColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'من الجزء ${plan.startJuz} إلى ${plan.endJuz} • أيام: ${plan.totalDays}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: context.onSurfaceVariant.withValues(alpha: 0.8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: context.onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem<void>(
                          child: Text(
                            'حذف',
                            style: context.bodyMedium?.copyWith(
                              color: Colors.red,
                            ),
                          ),
                          onTap: () {
                            context.showCustomSnackbar(
                              'سيتم حذف الخطة ؟',
                              style: SnackBarType.warning,
                              actionLabel: 'تأكيد',
                              duration: const Duration(seconds: 3),
                              paddingBottom: 100,
                              onAction: () {
                                context
                                    .read<QuranPlanBloc>()
                                    .add(DeletePlanEvent(plan.id!));
                              },
                            );
                          },
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
}
