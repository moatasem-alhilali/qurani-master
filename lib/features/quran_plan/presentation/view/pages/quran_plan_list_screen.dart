import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/extensions/snackbar_extension.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/animated_snackbar_widget.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_model.dart';
import 'package:quran_app/features/quran_plan/presentation/bloc/quran_plan_bloc.dart';
import 'package:quran_app/features/quran_plan/presentation/view/pages/quran_plan_add_screen.dart';
import 'package:quran_app/features/quran_plan/presentation/view/pages/quran_plan_session_screen.dart';
import 'package:quran_app/features/quran_plan/presentation/view/widgets/plan_progress_line.dart';

/// قائمة خطط الختمة.
///
/// كانت كل خطة بطاقة بتدرّج ودائرة زخرفية وظل. صارت صفًّا نحيلاً تفصله شعرة،
/// والتقدّم خطّ رفيع تحت السطر لا حلقة ولا بطاقة.
class QuranPlanListScreen extends StatelessWidget {
  const QuranPlanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocProvider<QuranPlanBloc>(
      create: (_) => sl<QuranPlanBloc>()..add(LoadAllPlansEvent()),
      child: Theme(
        data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
        child: BlocBuilder<QuranPlanBloc, QuranPlanState>(
          builder: (ctx, state) {
            return AppScaffoldWidget(
              title: 'خطط الختم',
              onRefresh: () async {
                ctx.read<QuranPlanBloc>().add(LoadAllPlansEvent());
              },
              // الزرّ العائم هو العنصر المرتفع الوحيد في الشاشة.
              floatingActionButton: FloatingActionButton(
                heroTag: 'add_plan',
                elevation: skin.isDark ? 0 : 3,
                backgroundColor: AppColors.gold,
                foregroundColor:
                    skin.isDark ? AppColors.brandNight : AppColors.brandIvory,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                tooltip: 'خطة جديدة',
                onPressed: () {
                  HapticFeedback.selectionClick();
                  context.push(
                    BlocProvider.value(
                      value: ctx.read<QuranPlanBloc>(),
                      child: const QuranPlanAddScreen(),
                    ),
                  );
                },
                child: AppIcon(
                  AppIcons.add,
                  color:
                      skin.isDark ? AppColors.brandNight : AppColors.brandIvory,
                  size: 20.sp,
                ),
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
                    suggestionBuilder: (context, item) =>
                        PlanRow(plan: item, isLast: true),
                  );
                },
              ),
              slivers: [
                BlocBuilder<QuranPlanBloc, QuranPlanState>(
                  builder: (context, state) {
                    return state.requestState.whenSliver<QuranPlan>(
                      context: context,
                      sliverList: state.plans,
                      onLoading: const _PlansSkeleton(),
                      onSuccess: () => SliverList.builder(
                        itemCount: state.plans.length,
                        itemBuilder: (ctx, i) => PlanRow(
                          plan: state.plans[i],
                          isLast: i == state.plans.length - 1,
                        ),
                      ),
                    );
                  },
                ),
                SliverToBoxAdapter(child: SizedBox(height: 90.h)),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// صفّ خطة واحدة: عنوانها، مداها، تقدّمها بخطّ رفيع، وقائمة الحذف.
class PlanRow extends StatelessWidget {
  const PlanRow({
    required this.plan,
    this.isLast = false,
    super.key,
  });

  final QuranPlan plan;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final total = plan.sessionsCount;
    final done = (plan.progress.clamp(0.0, 1.0) * total).round();

    return InkWell(
      onTap: () {
        if (plan.id == null) {
          return;
        }
        context.push(
          QuranPlanSessionScreen(planId: plan.id!, title: plan.title),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    color: skin.iconChip,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: AppIcon(
                      AppIcons.quran,
                      color: skin.accent,
                      size: 15.sp,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        plan.title,
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
                        'الجزء ${plan.startJuz} إلى ${plan.endJuz}'
                        ' · ${plan.totalDays} يومًا',
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
                // «٣ من ٥» بالعربية: الكسر ينقلب في الاتجاه
                // العربي فيُقرأ مقلوبًا.
                Text(
                  '$done من $total',
                  style: TextStyle(
                    color: skin.accent,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                _PlanMenu(plan: plan),
              ],
            ),
            SizedBox(height: 7.h),
            PlanProgressLine(value: plan.progress),
          ],
        ),
      ),
    );
  }
}

/// قائمة صغيرة بخيار الحذف — بلا أيقونة ثقيلة ولا لون صارخ.
class _PlanMenu extends StatelessWidget {
  const _PlanMenu({required this.plan});

  final QuranPlan plan;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return PopupMenuButton<void>(
      padding: EdgeInsets.zero,
      splashRadius: 16.r,
      color: skin.raised,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: skin.hairline),
      ),
      icon: AppIcon(
        AppIcons.more,
        color: skin.inkSoft.withValues(alpha: 0.7),
        size: 15.sp,
      ),
      itemBuilder: (context) => [
        PopupMenuItem<void>(
          height: 36.h,
          onTap: () {
            context.showCustomSnackbar(
              'سيتم حذف الخطة ؟',
              style: SnackBarType.warning,
              actionLabel: 'تأكيد',
              duration: const Duration(seconds: 3),
              paddingBottom: 100,
              onAction: () {
                if (plan.id == null) {
                  return;
                }
                context.read<QuranPlanBloc>().add(DeletePlanEvent(plan.id!));
              },
            );
          },
          child: Text(
            'حذف الخطة',
            style: TextStyle(
              color: AppColors.error,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

/// هيكل انتظار بشكل الصفوف نفسها.
class _PlansSkeleton extends StatelessWidget {
  const _PlansSkeleton();

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return SliverList.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: index == 4
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        child: Row(
          children: [
            Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: skin.hairline,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 9.h,
                    width: 140.w,
                    decoration: BoxDecoration(
                      color: skin.hairline,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    height: 7.h,
                    width: 90.w,
                    decoration: BoxDecoration(
                      color: skin.hairline.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(999.r),
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
