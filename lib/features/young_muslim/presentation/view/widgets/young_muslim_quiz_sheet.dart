import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/young_muslim/domain/entities/young_muslim_entities.dart';
import 'package:quran_app/features/young_muslim/domain/repositories/young_muslim_repository.dart';
import 'package:quran_app/features/young_muslim/presentation/cubit/young_muslim_quiz_cubit.dart';
import 'package:quran_app/features/young_muslim/presentation/view/widgets/young_muslim_shared_widgets.dart';

part 'young_muslim_quiz_sheet_form.dart';
part 'young_muslim_quiz_sheet_result.dart';

class YoungMuslimQuizSheet extends StatelessWidget {
  const YoungMuslimQuizSheet({
    required this.title,
    required this.quizSet,
    super.key,
  });

  final String title;
  final YoungMuslimQuizSetEntity quizSet;

  static Future<YoungMuslimQuizResultEntity?> show({
    required BuildContext context,
    required YoungMuslimQuizSetEntity quizSet,
    required String title,
  }) {
    final skin = AppSkin.of(context);

    return showModalBottomSheet<YoungMuslimQuizResultEntity?>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: skin.ground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (sheetContext) {
        return RepositoryProvider.value(
          value: context.read<YoungMuslimRepository>(),
          child: BlocProvider(
            create: (_) => YoungMuslimQuizCubit(
              repository: context.read<YoungMuslimRepository>(),
              quizSet: quizSet,
            ),
            child: YoungMuslimQuizSheet(
              title: title,
              quizSet: quizSet,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<YoungMuslimQuizCubit, YoungMuslimQuizState>(
      listenWhen: (previous, current) =>
          previous.submitState != current.submitState,
      listener: (context, state) {
        // إتمام الاختبار يُحسّ: اهتزازة أوضح عند النجاح، وأخفّ عند غيره.
        if (state.submitState != RequestState.success) {
          return;
        }
        if (state.result?.passed ?? false) {
          HapticFeedback.mediumImpact();
        } else {
          HapticFeedback.selectionClick();
        }
      },
      builder: (context, state) {
        final result = state.result;
        final showResult =
            state.submitState == RequestState.success && result != null;

        return Padding(
          padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 20.h),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: KeyedSubtree(
              key: ValueKey(
                showResult
                    ? 'quiz_result_${quizSet.id}'
                    : 'quiz_form_${quizSet.id}',
              ),
              child: showResult
                  ? _QuizResultView(
                      title: title,
                      result: result,
                    )
                  : _QuizFormView(
                      title: title,
                      state: state,
                    ),
            ),
          ),
        );
      },
    );
  }
}

/// زرّ إغلاق الورقة السفلية — على مقاس بقية أيقونات القسم.
class _SheetCloseButton extends StatelessWidget {
  const _SheetCloseButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap ?? () => Navigator.of(context).pop(),
      borderRadius: BorderRadius.circular(999.r),
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: AppIcon(AppIcons.close, color: skin.accent, size: 15.sp),
      ),
    );
  }
}
