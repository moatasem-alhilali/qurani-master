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
            padding: EdgeInsets.all(16.r),
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
          for (int i = 0; i < state.quizSet.questions.length; i++) ...[
            _QuestionCard(
              index: i + 1,
              question: state.quizSet.questions[i],
              selectedValue: state.answers[state.quizSet.questions[i].id],
              onSelected: (answer) {
                context
                    .read<YoungMuslimQuizCubit>()
                    .answerQuestion(state.quizSet.questions[i].id, answer);
              },
            ),
            SizedBox(height: 16.h),
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
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
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
    required this.index,
    required this.question,
    required this.selectedValue,
    required this.onSelected,
  });

  final int index;
  final YoungMuslimQuizQuestionEntity question;
  final String? selectedValue;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final isDirectQuestion =
        question.type == 'direct' || question.options.isEmpty;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: youngMuslimPanelDecoration(
        context,
        radius: 16,
        color: context.cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: context.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  '$index',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                    color: context.primaryColor,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  question.prompt,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1.5,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          if (isDirectQuestion)
            TextFormField(
              initialValue: selectedValue,
              onChanged: onSelected,
              textInputAction: TextInputAction.done,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: 'اكتب إجابتك هنا بوضوح...',
                hintStyle: TextStyle(
                    fontSize: 13.sp, color: context.gray1.withOpacity(0.5)),
                filled: true,
                fillColor: context.scaffoldBackgroundColor,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: context.outlineVariant.withOpacity(0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide:
                      BorderSide(color: context.primaryColor, width: 1.5),
                ),
              ),
            )
          else
            for (final option in question.options)
              Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _OptionCard(
                  text: option.text,
                  isSelected: selectedValue == option.id,
                  onTap: () => onSelected(option.id),
                ),
              ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = context.primaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withOpacity(0.08)
              : context.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? activeColor
                : context.outlineVariant.withOpacity(0.2),
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? activeColor : Colors.transparent,
                border: Border.all(
                  color:
                      isSelected ? activeColor : context.gray1.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 14.r, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? activeColor : context.onSurfaceColor,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
