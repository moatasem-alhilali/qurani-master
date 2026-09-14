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
    final skin = AppSkin.of(context);
    final scorePercent = (result.scorePercent * 100).round();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          YoungMuslimSectionHeader(
            title: title,
            padded: false,
            trailing: _SheetCloseButton(
              onTap: () => Navigator.of(context).pop(result),
            ),
          ),
          Row(
            children: [
              YoungMuslimIconChip(
                icon: result.passed ? AppIcons.check : AppIcons.target,
                size: 40.w,
                active: result.passed,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      result.passed
                          ? 'أحسنت يا بطل'
                          : 'أنت قريب من الإجابة الكاملة',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: skin.ink,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    // الكسر «٣ / ٥» ينقلب في الاتجاه العربي، فيُكتب بالعربية.
                    Text(
                      'أجبت ${result.correctAnswers} من '
                      '${result.totalQuestions} إجابة صحيحة',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: youngMuslimRowSubtitle(skin, size: 10.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          YoungMuslimProgressBar(value: result.scorePercent),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: [
              YoungMuslimMetricChip(
                label: '$scorePercent٪',
                icon: AppIcons.target,
              ),
              YoungMuslimMetricChip(
                label: '+${result.awardedXp} نقطة',
                icon: AppIcons.star,
              ),
              YoungMuslimMetricChip(
                label: 'المستوى ${result.rewardsSummary.level}',
                icon: AppIcons.checkSmall,
              ),
            ],
          ),
          if (result.newlyUnlockedAchievements.isNotEmpty) ...[
            const YoungMuslimSectionHeader(
              title: 'إنجازات جديدة',
              padded: false,
            ),
            for (var i = 0; i < result.newlyUnlockedAchievements.length; i++)
              _UnlockedAchievementRow(
                achievement: result.newlyUnlockedAchievements[i],
                isLast: i == result.newlyUnlockedAchievements.length - 1,
              ),
          ],
          const YoungMuslimSectionHeader(
            title: 'مراجعة الإجابات',
            padded: false,
          ),
          for (var i = 0; i < result.answerReviews.length; i++)
            _AnswerReviewBlock(
              review: result.answerReviews[i],
              isLast: i == result.answerReviews.length - 1,
            ),
          SizedBox(height: 14.h),
          YoungMuslimPrimaryButton(
            label: 'إنهاء',
            icon: AppIcons.check,
            onTap: () => Navigator.of(context).pop(result),
          ),
        ],
      ),
    );
  }
}

/// مراجعة سؤال واحد: إجابتك، الصحيحة، ثم الشرح.
class _AnswerReviewBlock extends StatelessWidget {
  const _AnswerReviewBlock({
    required this.review,
    required this.isLast,
  });

  final YoungMuslimQuizAnswerReviewEntity review;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final accentColor = review.isCorrect ? skin.accent : AppColors.error;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 13.h),
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
                  color: accentColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(9.r),
                ),
                child: Center(
                  child: AppIcon(
                    review.isCorrect ? AppIcons.checkSmall : AppIcons.close,
                    color: accentColor,
                    size: 12.sp,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  review.question.prompt,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          _AnswerLine(
            title: 'إجابتك',
            value: review.submittedAnswer,
            color: accentColor,
          ),
          SizedBox(height: 8.h),
          _AnswerLine(
            title: 'الإجابة الصحيحة',
            value: review.correctAnswer,
            color: skin.accent,
          ),
          if (review.question.explanation.trim().isNotEmpty) ...[
            SizedBox(height: 10.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppIcon(AppIcons.error, color: skin.accent, size: 13.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    review.question.explanation,
                    style: TextStyle(
                      color: skin.inkSoft.withValues(alpha: 0.78),
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
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
    final skin = AppSkin.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(11.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            value,
            style: TextStyle(
              color: skin.ink,
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// إنجاز فُتح للتوّ بعد هذا الاختبار.
class _UnlockedAchievementRow extends StatelessWidget {
  const _UnlockedAchievementRow({
    required this.achievement,
    required this.isLast,
  });

  final YoungMuslimAchievementEntity achievement;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      child: Row(
        children: [
          YoungMuslimIconChip(
            icon: youngMuslimAchievementIcon(achievement.icon),
            active: true,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  achievement.titleAr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: youngMuslimRowTitle(skin),
                ),
                Text(
                  achievement.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: youngMuslimRowSubtitle(skin),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          YoungMuslimMetricChip(
            label: '+${achievement.xpReward} نقطة',
            icon: AppIcons.star,
          ),
        ],
      ),
    );
  }
}
