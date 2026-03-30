import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/sheet/full_screen_sheet.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/young_muslim/domain/entities/young_muslim_entities.dart';
import 'package:quran_app/features/young_muslim/presentation/view/widgets/young_muslim_shared_widgets.dart';

part 'young_muslim_rewards_sheet_achievement_card.dart';

class YoungMuslimRewardsSheet extends StatelessWidget {
  const YoungMuslimRewardsSheet({
    required this.rewardsSummary,
    required this.achievements,
    super.key,
  });

  final YoungMuslimRewardsSummaryEntity rewardsSummary;
  final List<YoungMuslimAchievementEntity> achievements;

  static Future<void> show({
    required BuildContext context,
    required YoungMuslimRewardsSummaryEntity rewardsSummary,
    required List<YoungMuslimAchievementEntity> achievements,
  }) async {
    context.showFullScreenSheet(
      child: YoungMuslimRewardsSheet(
        rewardsSummary: rewardsSummary,
        achievements: achievements,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unlocked = achievements.where((item) => item.isUnlocked).toList();
    final locked = achievements.where((item) => !item.isUnlocked).toList();
    final levelProgress =
        (rewardsSummary.xpIntoCurrentLevel / 100).clamp(0.0, 1.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 28.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            YoungMuslimSectionHeader(
              title: 'نقاطك وإنجازاتك',
              subtitle: 'كل التقدّم محفوظ هنا بشكل واضح وبسيط.',
              trailing: IconButton(
                onPressed: () => Navigator.of(context).pop(),
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
                          color: youngMuslimRewardColor(context)
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                        child: Icon(
                          Icons.bolt_rounded,
                          color: youngMuslimRewardColor(context),
                          size: 28.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${rewardsSummary.xp} XP',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'المستوى ${rewardsSummary.level}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: context.gray1,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'التقدّم للمستوى التالي',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                      ),
                      Text(
                        '${rewardsSummary.xpIntoCurrentLevel}/100',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: context.gray1,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  LinearProgressIndicator(
                    value: levelProgress,
                    minHeight: 10.h,
                    borderRadius: BorderRadius.circular(20.r),
                    backgroundColor: context.outline.withValues(alpha: 0.18),
                    color: youngMuslimRewardColor(context),
                  ),
                  SizedBox(height: 18.h),
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: [
                      YoungMuslimMetricChip(
                        label: '${rewardsSummary.completedVideos} فيديو مكتمل',
                        icon: Icons.play_lesson_rounded,
                        color: context.primaryColor,
                      ),
                      YoungMuslimMetricChip(
                        label: '${rewardsSummary.correctAnswers} إجابة صحيحة',
                        icon: Icons.quiz_rounded,
                        color: context.secondaryColor,
                      ),
                      YoungMuslimMetricChip(
                        label: '${rewardsSummary.completedSeries} سلسلة',
                        icon: Icons.auto_stories_rounded,
                        color: youngMuslimCompletionColor(context),
                      ),
                      YoungMuslimMetricChip(
                        label: '${rewardsSummary.perfectQuizzes} نتيجة كاملة',
                        icon: Icons.workspace_premium_rounded,
                        color: youngMuslimRewardColor(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 22.h),
            YoungMuslimSectionHeader(
              title: 'الإنجازات المفتوحة',
              subtitle: unlocked.isEmpty
                  ? 'ابدأ بالمشاهدة وحل الأسئلة لتظهر هنا.'
                  : '${unlocked.length} إنجازات تم فتحها حتى الآن.',
            ),
            SizedBox(height: 14.h),
            if (unlocked.isEmpty)
              const YoungMuslimEmptyState(
                title: 'لا توجد إنجازات بعد',
                subtitle: 'أكمل أول فيديو أو أجب على أول سؤال لتبدأ الرحلة.',
                icon: Icons.emoji_events_outlined,
              )
            else
              Column(
                children: unlocked
                    .map(
                      (achievement) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _AchievementCard(
                          achievement: achievement,
                          currentValue: _achievementCurrentValue(
                            achievement,
                            rewardsSummary,
                          ),
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
            SizedBox(height: 22.h),
            if (locked.isNotEmpty) ...[
              const YoungMuslimSectionHeader(
                title: 'إنجازات قادمة',
                subtitle: 'هذه الإنجازات قريبة منك ويمكن فتحها تدريجيًا.',
              ),
              SizedBox(height: 14.h),
              Column(
                children: locked
                    .map(
                      (achievement) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _AchievementCard(
                          achievement: achievement,
                          currentValue: _achievementCurrentValue(
                            achievement,
                            rewardsSummary,
                          ),
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
