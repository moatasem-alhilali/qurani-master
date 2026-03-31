import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
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
    return showModalBottomSheet<YoungMuslimQuizResultEntity?>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
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
    return BlocBuilder<YoungMuslimQuizCubit, YoungMuslimQuizState>(
      builder: (context, state) {
        final result = state.result;
        final showResult =
            state.submitState == RequestState.success && result != null;

        return Padding(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
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
