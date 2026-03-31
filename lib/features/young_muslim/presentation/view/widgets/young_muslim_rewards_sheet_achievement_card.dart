part of 'young_muslim_rewards_sheet.dart';

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({
    required this.achievement,
    required this.currentValue,
  });

  final YoungMuslimAchievementEntity achievement;
  final int currentValue;

  @override
  Widget build(BuildContext context) {
    final isUnlocked = achievement.isUnlocked;
    final progress = (currentValue / achievement.threshold).clamp(0.0, 1.0);
    final accentColor = isUnlocked
        ? youngMuslimRewardColor(context)
        : context.primaryColor.withValues(alpha: 0.75);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: youngMuslimPanelDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  youngMuslimAchievementIcon(achievement.icon),
                  color: accentColor,
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
                color: accentColor,
              ),
            ],
          ),
          SizedBox(height: 14.h),
          if (isUnlocked)
            Text(
              achievement.unlockedAt == null
                  ? 'تم فتح هذا الإنجاز.'
                  : 'تم فتحه ${youngMuslimRelative(achievement.unlockedAt)}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w700,
                  ),
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    'التقدّم الحالي',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                Text(
                  '$currentValue/${achievement.threshold}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: context.gray1,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              borderRadius: BorderRadius.circular(18.r),
              backgroundColor: context.outline.withValues(alpha: 0.18),
              color: accentColor,
            ),
          ],
        ],
      ),
    );
  }
}

int _achievementCurrentValue(
  YoungMuslimAchievementEntity achievement,
  YoungMuslimRewardsSummaryEntity rewardsSummary,
) {
  switch (achievement.type) {
    case 'completed_videos':
      return rewardsSummary.completedVideos;
    case 'completed_series':
      return rewardsSummary.completedSeries;
    case 'correct_answers':
      return rewardsSummary.correctAnswers;
    case 'watch_later_items':
      return rewardsSummary.watchLaterItems;
    case 'perfect_quizzes':
      return rewardsSummary.perfectQuizzes;
    default:
      return 0;
  }
}
