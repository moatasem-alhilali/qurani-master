import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/sheet/full_screen_sheet.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
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
    final skin = AppSkin.of(context);

    context.showFullScreenSheet(
      backgroundColor: skin.ground,
      appBar: _RewardsSheetHeader(skin: skin),
      child: ColoredBox(
        color: skin.ground,
        child: YoungMuslimRewardsSheet(
          rewardsSummary: rewardsSummary,
          achievements: achievements,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final unlocked = achievements.where((item) => item.isUnlocked).toList();
    final locked = achievements.where((item) => !item.isUnlocked).toList();
    final levelProgress =
        (rewardsSummary.xpIntoCurrentLevel / 100).clamp(0.0, 1.0);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 12.h),
          // العنصر الوحيد المرتفع في الورقة: رصيد النقاط والمستوى.
          Padding(
            padding: AppSkin.gutter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: skin.raised,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: skin.raisedBorder),
                boxShadow: skin.raisedShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      YoungMuslimIconChip(
                        icon: AppIcons.star,
                        size: 40.w,
                        active: true,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${rewardsSummary.xp} نقطة',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: youngMuslimNumber(
                                skin,
                                size: 15.sp,
                                color: skin.ink,
                                weight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'المستوى ${rewardsSummary.level}',
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'التقدّم للمستوى التالي',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: youngMuslimRowSubtitle(skin),
                        ),
                      ),
                      Text(
                        '${rewardsSummary.xpIntoCurrentLevel} من 100',
                        style: youngMuslimNumber(skin, size: 10.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  YoungMuslimProgressBar(value: levelProgress),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          YoungMuslimStatStrip(
            cells: [
              YoungMuslimStatCell(
                value: '${rewardsSummary.completedVideos}',
                label: 'حلقات',
                icon: AppIcons.play,
              ),
              YoungMuslimStatCell(
                value: '${rewardsSummary.correctAnswers}',
                label: 'إجابات',
                icon: AppIcons.checkSmall,
              ),
              YoungMuslimStatCell(
                value: '${rewardsSummary.completedSeries}',
                label: 'سلاسل',
                icon: AppIcons.layers,
              ),
              YoungMuslimStatCell(
                value: '${rewardsSummary.perfectQuizzes}',
                label: 'نتائج كاملة',
                icon: AppIcons.target,
              ),
            ],
          ),
          skin.divider(),
          YoungMuslimSectionHeader(
            title: 'الإنجازات المفتوحة',
            trailing: YoungMuslimMetricChip(
              label: '${unlocked.length} إنجاز',
            ),
          ),
          if (unlocked.isEmpty)
            const YoungMuslimEmptyState(
              title: 'لا توجد إنجازات بعد',
              subtitle: 'أكمل أول حلقة أو أجب عن أول سؤال لتبدأ الرحلة.',
              icon: AppIcons.star,
            )
          else
            for (var i = 0; i < unlocked.length; i++)
              _AchievementRow(
                achievement: unlocked[i],
                isLast: i == unlocked.length - 1,
                currentValue: _achievementCurrentValue(
                  unlocked[i],
                  rewardsSummary,
                ),
              ),
          if (locked.isNotEmpty) ...[
            skin.divider(),
            YoungMuslimSectionHeader(
              title: 'إنجازات قادمة',
              trailing: YoungMuslimMetricChip(
                label: '${locked.length} إنجاز',
              ),
            ),
            for (var i = 0; i < locked.length; i++)
              _AchievementRow(
                achievement: locked[i],
                isLast: i == locked.length - 1,
                currentValue: _achievementCurrentValue(
                  locked[i],
                  rewardsSummary,
                ),
              ),
          ],
          SizedBox(height: 28.h),
        ],
      ),
    );
  }
}

/// رأس الورقة: عنوان وزرّ إغلاق بلوحة «طمأنينة» بدل الرأس الرمادي الافتراضي.
class _RewardsSheetHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const _RewardsSheetHeader({required this.skin});

  final AppSkin skin;

  @override
  Size get preferredSize => Size.fromHeight(50.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: skin.ground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
        border: Border(bottom: BorderSide(color: skin.hairline)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(999.r),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: AppIcon(
                AppIcons.close,
                color: skin.accent,
                size: 16.sp,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'نقاطي وإنجازاتي',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: skin.ink,
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
