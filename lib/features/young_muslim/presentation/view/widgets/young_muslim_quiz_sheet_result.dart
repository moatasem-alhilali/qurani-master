part of 'young_muslim_quiz_sheet.dart';

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
                        color: passedColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16.r),
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
                  minHeight: 8.h,
                  borderRadius: BorderRadius.circular(16.r),
                  backgroundColor: context.outline.withOpacity(0.15),
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
      padding: EdgeInsets.all(20.r),
      decoration: youngMuslimPanelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  review.isCorrect
                      ? Icons.check_rounded
                      : Icons.close_rounded,
                  color: accentColor,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  review.question.prompt,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1.5,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _AnswerLine(
            title: 'إجابتك',
            value: review.submittedAnswer,
            color: review.isCorrect ? accentColor : context.errorColor,
            isCorrect: review.isCorrect,
          ),
          SizedBox(height: 12.h),
          _AnswerLine(
            title: 'الإجابة الصحيحة',
            value: review.correctAnswer,
            color: youngMuslimCompletionColor(context),
            isCorrect: true,
            isReference: true,
          ),
          if (review.question.explanation.trim().isNotEmpty) ...[
            SizedBox(height: 16.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: context.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: context.primaryColor.withOpacity(0.1)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded, size: 16.r, color: context.primaryColor),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      review.question.explanation,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.onSurfaceColor.withOpacity(0.8),
                            height: 1.6,
                            fontSize: 11.5.sp,
                          ),
                    ),
                  ),
                ],
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
    this.isCorrect = false,
    this.isReference = false,
  });

  final String title;
  final String value;
  final Color color;
  final bool isCorrect;
  final bool isReference;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isReference 
            ? color.withOpacity(0.05)
            : color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: isReference 
            ? Border.all(color: color.withOpacity(0.2)) 
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: color.withOpacity(0.8),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              if (!isReference)
                Icon(
                  isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  size: 14.r,
                  color: color,
                ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.onSurfaceColor,
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
              color: rewardColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12.r),
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
