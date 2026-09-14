part of 'young_muslim_rewards_sheet.dart';

/// صفّ إنجاز: مربّع أيقونة، اسمه ووصفه، ثم نقاطه.
///
/// المفتوح يذكر متى فُتح، والمغلق يعرض شريط تقدّمه مكتوبًا بالعربية
/// («٣ من ٥») حتى لا ينقلب الكسر في الاتجاه العربي.
class _AchievementRow extends StatelessWidget {
  const _AchievementRow({
    required this.achievement,
    required this.currentValue,
    required this.isLast,
  });

  final YoungMuslimAchievementEntity achievement;
  final int currentValue;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final isUnlocked = achievement.isUnlocked;
    final threshold = achievement.threshold == 0 ? 1 : achievement.threshold;
    final progress = (currentValue / threshold).clamp(0.0, 1.0);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 11.h),
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              YoungMuslimIconChip(
                icon: youngMuslimAchievementIcon(achievement.icon),
                active: isUnlocked,
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
          if (isUnlocked)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                achievement.unlockedAt == null
                    ? 'تم فتح هذا الإنجاز.'
                    : 'فُتح ${youngMuslimRelative(achievement.unlockedAt)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: youngMuslimNumber(skin, size: 9.5.sp),
              ),
            )
          else ...[
            SizedBox(height: 9.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'التقدّم الحالي',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: youngMuslimRowSubtitle(skin),
                  ),
                ),
                Text(
                  '$currentValue من ${achievement.threshold}',
                  style: youngMuslimNumber(skin, size: 10.sp),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            YoungMuslimProgressBar(value: progress),
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
