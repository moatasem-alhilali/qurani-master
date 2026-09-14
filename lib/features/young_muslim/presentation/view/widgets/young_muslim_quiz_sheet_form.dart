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
    final skin = AppSkin.of(context);
    final questions = state.quizSet.questions;
    final busy = state.submitState == RequestState.loading;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          YoungMuslimSectionHeader(
            title: title,
            padded: false,
            trailing: const _SheetCloseButton(),
          ),
          Text(
            'أسئلة بسيطة تساعد الطفل على تثبيت ما شاهده.',
            style: youngMuslimRowSubtitle(skin, size: 10.sp),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: [
              YoungMuslimMetricChip(
                label: '${questions.length} أسئلة',
                icon: AppIcons.list,
              ),
              YoungMuslimMetricChip(
                label: '+${state.quizSet.xpReward} نقطة عند النجاح',
                icon: AppIcons.star,
              ),
              YoungMuslimMetricChip(
                label: 'النجاح من ${state.quizSet.passingScore}',
                icon: AppIcons.checkSmall,
              ),
            ],
          ),
          SizedBox(height: 4.h),
          for (var i = 0; i < questions.length; i++)
            _QuestionBlock(
              index: i + 1,
              question: questions[i],
              selectedValue: state.answers[questions[i].id],
              isLast: i == questions.length - 1,
              onSelected: (answer) {
                context
                    .read<YoungMuslimQuizCubit>()
                    .answerQuestion(questions[i].id, answer);
              },
            ),
          if (state.submitState == RequestState.error &&
              state.errorMessage != null)
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Text(
                state.errorMessage!,
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          SizedBox(height: 6.h),
          YoungMuslimPrimaryButton(
            label: busy ? 'جارٍ تصحيح الإجابات' : 'إرسال الإجابات',
            icon: AppIcons.check,
            busy: busy,
            onTap: state.canSubmit
                ? () => context.read<YoungMuslimQuizCubit>().submit()
                : null,
          ),
        ],
      ),
    );
  }
}

/// سؤال واحد: رقمه ونصّه، ثم خياراته. تفصله شعرة عن السؤال التالي.
class _QuestionBlock extends StatelessWidget {
  const _QuestionBlock({
    required this.index,
    required this.question,
    required this.selectedValue,
    required this.onSelected,
    required this.isLast,
  });

  final int index;
  final YoungMuslimQuizQuestionEntity question;
  final String? selectedValue;
  final ValueChanged<String> onSelected;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final isDirectQuestion =
        question.type == 'direct' || question.options.isEmpty;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: skin.iconChip,
                  borderRadius: BorderRadius.circular(9.r),
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: youngMuslimNumber(
                      skin,
                      size: 10.sp,
                      weight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  question.prompt,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (isDirectQuestion)
            TextFormField(
              initialValue: selectedValue,
              onChanged: onSelected,
              textInputAction: TextInputAction.done,
              cursorColor: skin.accent,
              style: TextStyle(
                color: skin.ink,
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: 'اكتب إجابتك هنا بوضوح...',
                hintStyle: youngMuslimRowSubtitle(skin, size: 11.sp),
                filled: true,
                fillColor: skin.iconChip,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 12.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: skin.hairline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: skin.hairline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(
                    color: AppColors.gold,
                    width: 1.4,
                  ),
                ),
              ),
            )
          else
            for (final option in question.options)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: _OptionRow(
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

/// خيار واحد: دائرة تمتلئ ذهبًا عند الاختيار، مع اهتزازة خفيفة.
class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Semantics(
      button: true,
      selected: isSelected,
      label: text,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(12.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
          decoration: BoxDecoration(
            color: isSelected ? skin.iconChip : skin.ground,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? AppColors.gold : skin.hairline,
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 18.w,
                height: 18.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.gold : skin.ground,
                  border: Border.all(
                    color: isSelected ? AppColors.gold : skin.hairline,
                    width: 1.6,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: AppIcon(
                          AppIcons.checkSmall,
                          color: skin.isDark
                              ? AppColors.brandNight
                              : AppColors.brandIvory,
                          size: 11.sp,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 12.sp,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
