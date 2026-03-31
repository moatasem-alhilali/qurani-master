part of 'young_muslim_quiz_sheet.dart';

class _QuizFormView extends StatelessWidget {
  const _QuizFormView({
    required this.title,
    required this.state,
  });

  final String title;
  final YoungMuslimQuizState state;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: youngMuslimPanelDecoration(context),
            child: Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: [
                YoungMuslimMetricChip(
                  label: '${state.quizSet.questions.length} أسئلة',
                  icon: Icons.quiz_rounded,
                  color: context.primaryColor,
                ),
                YoungMuslimMetricChip(
                  label: '+${state.quizSet.xpReward} XP عند النجاح',
                  icon: Icons.bolt_rounded,
                  color: youngMuslimRewardColor(context),
                ),
                YoungMuslimMetricChip(
                  label: 'النجاح من ${state.quizSet.passingScore}',
                  icon: Icons.check_circle_rounded,
                  color: youngMuslimCompletionColor(context),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          for (final question in state.quizSet.questions) ...[
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
                      color: context.errorColor,
                    ),
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed:
                  state.submitState == RequestState.loading || !state.canSubmit
                      ? null
                      : () => context.read<YoungMuslimQuizCubit>().submit(),
              icon: state.submitState == RequestState.loading
                  ? SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: context.onPrimaryColor,
                      ),
                    )
                  : const Icon(Icons.check_circle_outline_rounded),
              label: Text(
                state.submitState == RequestState.loading
                    ? 'جارٍ تصحيح الإجابات'
                    : 'إرسال الإجابات',
              ),
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
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
