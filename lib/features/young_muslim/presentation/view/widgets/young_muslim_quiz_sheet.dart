import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/features/young_muslim/domain/entities/young_muslim_entities.dart';
import 'package:quran_app/features/young_muslim/domain/repositories/young_muslim_repository.dart';
import 'package:quran_app/features/young_muslim/presentation/cubit/young_muslim_quiz_cubit.dart';
import 'package:quran_app/features/young_muslim/presentation/view/widgets/young_muslim_shared_widgets.dart';

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
    return BlocConsumer<YoungMuslimQuizCubit, YoungMuslimQuizState>(
      listener: (context, state) {
        if (state.submitState == RequestState.success && state.result != null) {
          Future<void>.delayed(const Duration(milliseconds: 200), () {
            if (context.mounted) {
              Navigator.of(context).pop(state.result);
            }
          });
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                YoungMuslimSectionHeader(
                  title: title,
                  subtitle: 'أسئلة بسيطة تساعد الطفل على تثبيت ما شاهده',
                  trailing: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ),
                SizedBox(height: 16.h),
                for (final question in quizSet.questions) ...[
                  _QuestionCard(
                    question: question,
                    selectedValue: state.answers[question.id],
                    onSelected: (answer) {
                      context
                          .read<YoungMuslimQuizCubit>()
                          .answerQuestion(question.id, answer);
                    },
                  ),
                  SizedBox(height: 14.h),
                ],
                if (state.submitState == RequestState.error &&
                    state.errorMessage != null)
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Text(
                      state.errorMessage!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.redAccent,
                          ),
                    ),
                  ),
                if (state.submitState == RequestState.loading)
                  const Center(child: CircularProgressIndicator())
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: state.canSubmit
                          ? () => context.read<YoungMuslimQuizCubit>().submit()
                          : null,
                      icon: const Icon(Icons.check_circle_outline_rounded),
                      label: const Text('إرسال الإجابات'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
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
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    required this.selectedValue,
    required this.onSelected,
  });

  final YoungMuslimQuizQuestionEntity question;
  final String? selectedValue;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final isDirectQuestion =
        question.type == 'direct' || question.options.isEmpty;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: youngMuslimPanelDecoration(
        context,
        radius: 24,
        color: context.cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.prompt,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          SizedBox(height: 14.h),
          if (isDirectQuestion)
            TextFormField(
              initialValue: selectedValue,
              onChanged: onSelected,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: 'اكتب إجابتك هنا',
                filled: true,
                fillColor: context.scaffoldBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18.r),
                  borderSide: BorderSide(
                    color: context.outlineVariant.withValues(alpha: 0.35),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18.r),
                  borderSide: BorderSide(color: context.primaryColor),
                ),
              ),
            )
          else
            for (final option in question.options)
              Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: InkWell(
                  onTap: () => onSelected(option.id),
                  borderRadius: BorderRadius.circular(18.r),
                  child: Ink(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: selectedValue == option.id
                          ? context.primaryContainer.withValues(alpha: 0.7)
                          : context.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(
                        color: selectedValue == option.id
                            ? context.primaryColor
                            : context.outlineVariant.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Row(
                      children: [
                        Radio<String>(
                          value: option.id,
                          groupValue: selectedValue,
                          onChanged: (value) {
                            if (value != null) {
                              onSelected(value);
                            }
                          },
                        ),
                        Expanded(
                          child: Text(
                            option.text,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
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
