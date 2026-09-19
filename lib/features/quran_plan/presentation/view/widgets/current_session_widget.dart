import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/snackbar_extension.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/animated_snackbar_widget.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_model.dart';
import 'package:quran_app/features/quran_plan/data/model/quran_plan_session_model.dart';
import 'package:quran_app/features/quran_plan/presentation/bloc/quran_plan_bloc.dart';
import 'package:quran_app/features/quran_plan/presentation/view/widgets/session_navigation.dart';
import 'package:quran_app/l10n/l10n.dart';

/// جلسة اليوم — العنصر المرتفع الوحيد في شاشة الخطة.
///
/// ما يفتحه القارئ الآن يستحقّ أن يُرى قبل غيره، فبقي له الارتفاع وحده
/// وبقيت بقيّة الجلسات صفوفًا نحيلة.
class CurrentSessionWidget extends StatelessWidget {
  const CurrentSessionWidget({
    required this.plan,
    required this.session,
    super.key,
  });

  final QuranPlan plan;
  final QuranPlanSession session;

  void _confirmComplete(BuildContext context) {
    HapticFeedback.selectionClick();
    context.showCustomSnackbar(
      context.l10n.quranPlanCompleteConfirm,
      style: SnackBarType.warning,
      actionLabel: context.l10n.quranPlanConfirm,
      duration: const Duration(seconds: 3),
      paddingBottom: 100,
      onAction: () {
        if (session.id == null || plan.id == null) {
          return;
        }
        HapticFeedback.mediumImpact();
        context
            .read<QuranPlanBloc>()
            .add(CompleteSessionEvent(session.id!, plan.id!));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final isCompleted = session.completed;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 6.h),
      child: InkWell(
        onTap: () => openSessionInQuran(context, session),
        borderRadius: BorderRadius.circular(14.r),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
          decoration: BoxDecoration(
            color: skin.raised,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: skin.raisedBorder),
            boxShadow: skin.raisedShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    context.l10n.quranPlanSessionNumber(session.sessionNumber),
                    style: TextStyle(
                      color: skin.ink,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      isCompleted
                          ? context.l10n.quranPlanSessionDone
                          : context.l10n.quranPlanCurrentSession,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: skin.inkSoft.withValues(alpha: 0.78),
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _CompleteButton(
                    isCompleted: isCompleted,
                    onTap: () => _confirmComplete(context),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                sessionRangeLabel(context.l10n, session),
                style: TextStyle(
                  color: skin.inkSoft,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  AppIcon(AppIcons.quran, color: skin.accent, size: 13.sp),
                  SizedBox(width: 6.w),
                  Text(
                    context.l10n.quranPlanOpenMushafHint,
                    style: TextStyle(
                      color: skin.accent,
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// زرّ إنهاء الجلسة: مربّع صغير يمتلئ ذهبًا حين تُنجز.
class _CompleteButton extends StatelessWidget {
  const _CompleteButton({required this.isCompleted, required this.onTap});

  final bool isCompleted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Semantics(
      button: true,
      label: isCompleted
          ? context.l10n.quranPlanSessionCompleted
          : context.l10n.quranPlanCompleteSession,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            color: isCompleted ? AppColors.gold : skin.iconChip,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: AppIcon(
              AppIcons.check,
              color: isCompleted
                  ? (skin.isDark ? AppColors.brandNight : AppColors.brandIvory)
                  : skin.accent,
              size: 16.sp,
            ),
          ),
        ),
      ),
    );
  }
}
