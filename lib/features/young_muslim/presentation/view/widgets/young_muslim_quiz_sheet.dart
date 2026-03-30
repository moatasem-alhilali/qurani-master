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

class _QuizResultView extends StatelessWidget {
  const _QuizResultView({
    required this.title,
    required this.result,
  });

  final String title;
  final YoungMuslimQuizResultEntity result;

  @override
  Widget build(BuildContext context) {
    final passedColor = result.passed
        ? youngMuslimCompletionColor(context)
        : context.errorColor;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YoungMuslimSectionHeader(
            title: title,
            subtitle: result.passed
                ? 'أحسنت، هذه مراجعة واضحة لإجاباتك.'
                : 'راجع الإجابات الهادئة بالأسفل ثم أكمل المشاهدة.',
            trailing: IconButton(
              onPressed: () => Navigator.of(context).pop(result),
              icon: const Icon(Icons.close_rounded),
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(18.w),
            decoration: youngMuslimPanelDecoration(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56.w,
                      height: 56.w,
                      decoration: BoxDecoration(
                        color: passedColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Icon(
                        result.passed
                            ? Icons.verified_rounded
                            : Icons.auto_awesome_motion_rounded,
                        color: passedColor,
                        size: 28.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            result.passed
                                ? 'أحسنت يا بطل'
                                : 'أنت قريب من الإجابة الكاملة',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'أجبت ${result.correctAnswers} من '
                            '${result.totalQuestions} بشكل صحيح.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: context.gray1,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: [
                    YoungMuslimMetricChip(
                      label: '${(result.scorePercent * 100).round()}%',
                      icon: Icons.analytics_rounded,
                      color: passedColor,
                    ),
                    YoungMuslimMetricChip(
                      label: '+${result.awardedXp} XP',
                      icon: Icons.bolt_rounded,
                      color: youngMuslimRewardColor(context),
                    ),
                    YoungMuslimMetricChip(
                      label: 'المستوى ${result.rewardsSummary.level}',
                      icon: Icons.emoji_events_rounded,
                      color: context.primaryColor,
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                LinearProgressIndicator(
                  value: result.scorePercent,
                  minHeight: 10.h,
                  borderRadius: BorderRadius.circular(18.r),
                  backgroundColor: context.outline.withValues(alpha: 0.18),
                  color: passedColor,
                ),
              ],
            ),
          ),
          if (result.newlyUnlockedAchievements.isNotEmpty) ...[
            SizedBox(height: 18.h),
            const YoungMuslimSectionHeader(
              title: 'إنجازات جديدة',
              subtitle: 'هذه الإنجازات فُتحت بعد هذا الاختبار مباشرة.',
            ),
            SizedBox(height: 12.h),
            Column(
              children: result.newlyUnlockedAchievements
                  .map(
                    (achievement) => Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: _UnlockedAchievementCard(achievement: achievement),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
          SizedBox(height: 18.h),
          const YoungMuslimSectionHeader(
            title: 'مراجعة الإجابات',
            subtitle: 'ستجد إجابتك، الصحيح، وشرحًا بسيطًا لكل سؤال.',
          ),
          SizedBox(height: 12.h),
          Column(
            children: result.answerReviews
                .map(
                  (review) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: _AnswerReviewCard(review: review),
                  ),
                )
                .toList(growable: false),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(result),
              icon: const Icon(Icons.done_all_rounded),
              label: const Text('إنهاء'),
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

class _AnswerReviewCard extends StatelessWidget {
  const _AnswerReviewCard({
    required this.review,
  });

  final YoungMuslimQuizAnswerReviewEntity review;

  @override
  Widget build(BuildContext context) {
    final accentColor = review.isCorrect
        ? youngMuslimCompletionColor(context)
        : context.errorColor;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: youngMuslimPanelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  review.isCorrect
                      ? Icons.check_circle_rounded
                      : Icons.cancel_rounded,
                  color: accentColor,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  review.question.prompt,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          _AnswerLine(
            title: 'إجابتك',
            value: review.submittedAnswer,
            color: review.isCorrect ? accentColor : context.errorColor,
          ),
          SizedBox(height: 10.h),
          _AnswerLine(
            title: 'الإجابة الصحيحة',
            value: review.correctAnswer,
            color: youngMuslimCompletionColor(context),
          ),
          if (review.question.explanation.trim().isNotEmpty) ...[
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: context.primaryContainer.withValues(alpha: 0.36),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                review.question.explanation,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.gray1,
                      height: 1.45,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AnswerLine extends StatelessWidget {
  const _AnswerLine({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _UnlockedAchievementCard extends StatelessWidget {
  const _UnlockedAchievementCard({
    required this.achievement,
  });

  final YoungMuslimAchievementEntity achievement;

  @override
  Widget build(BuildContext context) {
    final rewardColor = youngMuslimRewardColor(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: youngMuslimPanelDecoration(context),
      child: Row(
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              color: rewardColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              youngMuslimAchievementIcon(achievement.icon),
              color: rewardColor,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.titleAr,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                SizedBox(height: 4.h),
                Text(
                  achievement.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.gray1,
                      ),
                ),
              ],
            ),
          ),
          YoungMuslimMetricChip(
            label: '+${achievement.xpReward} XP',
            icon: Icons.bolt_rounded,
            color: rewardColor,
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
