import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/auto_text.dart';
import 'package:quran_app/features/allh_name/presentation/view/pages/allh_name_screen.dart';
import 'package:quran_app/features/another_screen/presentation/view/pages/husin_almuslim_screen.dart';
import 'package:quran_app/features/another_screen/presentation/view/widgets/surah_and_detail_screen.dart';
import 'package:quran_app/features/daily_wird/presentation/view/pages/daily_wird_screen.dart';
import 'package:quran_app/features/hadith_40/presentation/view/pages/hadith_40_screen.dart';
import 'package:quran_app/features/my_adia/presentation/view/my_doa_provider.dart';
import 'package:quran_app/features/quran_plan/presentation/view/pages/quran_plan_list_screen.dart';
import 'package:quran_app/features/sabih/presentation/view/tasbeeh_provider.dart';
import 'package:quran_app/features/smart_outreach/presentation/view/pages/smart_outreach_schedules_screen.dart';
import 'package:quran_app/features/traveler/data/models/traveler_place.dart';
import 'package:quran_app/features/traveler/presentation/view/pages/flight_prayer_times_screen.dart';
import 'package:quran_app/features/traveler/presentation/view/pages/travel_athkar_screen.dart';
import 'package:quran_app/features/traveler/presentation/view/pages/travel_places_map_screen.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/traveler_options_sheet.dart';

class AnotherFeatures extends StatelessWidget {
  const AnotherFeatures({super.key});

  List<_FeatureShortcut> _items(BuildContext context) {
    return [
      _FeatureShortcut(
        label: 'زاد اليوم والليلة',
        subtitle: 'ورد تعبدي منظم لأذكارك وتلاوتك اليومية',
        icon: FlutterIslamicIcons.tasbih,
        onTap: () => context.push(const DailyWirdScreen()),
        isHighlighted: true,
      ),
      _FeatureShortcut(
        label: 'المسافر',
        subtitle: 'أذكار السفر ومواقيت الرحلات وأماكن نافعة',
        icon: Icons.travel_explore_rounded,
        onTap: () => _openTravelerSheet(context),
      ),
      _FeatureShortcut(
        label: 'خطط الختمة',
        subtitle: 'خطط مرتبة لإتمام الختمة بما يناسبك',
        icon: FlutterIslamicIcons.solidQuran2,
        onTap: () => context.push(const QuranPlanListScreen()),
      ),
      _FeatureShortcut(
        label: 'التنبيه الذكي',
        subtitle: 'تذكيرات دعوية واتصالات مجدولة',
        icon: Icons.phone_in_talk_rounded,
        onTap: () => context.push(const SmartOutreachSchedulesScreen()),
      ),
      _FeatureShortcut(
        label: 'المسبحة',
        subtitle: 'تسبيح سهل بعداد مريح وواضح',
        icon: FlutterIslamicIcons.tasbih2,
        onTap: () => context.push(const TasbeehProvider()),
      ),
      _FeatureShortcut(
        label: 'أسماء الله الحسنى',
        subtitle: 'تأمل الأسماء ومعانيها المباركة',
        icon: FlutterIslamicIcons.allah,
        onTap: () => context.push(const AllhNameScreen()),
      ),
      _FeatureShortcut(
        label: 'حصن المسلم',
        subtitle: 'أذكار جامعة مرتبة للأحوال والمناسبات',
        icon: FlutterIslamicIcons.quran,
        onTap: () => context.push(const HisnMuslimScreen()),
      ),
      _FeatureShortcut(
        label: 'الأربعون النووية',
        subtitle: 'أحاديث جامعة في أبواب الدين',
        icon: FlutterIslamicIcons.quran2,
        onTap: () => context.push(const Hadith40Screen()),
      ),
      _FeatureShortcut(
        label: 'موسوعة السور',
        subtitle: 'استعراض السور وفضائلها وموضوعاتها',
        icon: FlutterIslamicIcons.quran,
        onTap: () => context.push(const SurahWithAllDetailScreen()),
      ),
      _FeatureShortcut(
        label: 'أدعيتي الخاصة',
        subtitle: 'احتفظ بأدعيتك الشخصية في مكان واحد',
        icon: FlutterIslamicIcons.muslim2,
        onTap: () => context.push(const MuDoaProvider()),
      ),
    ];
  }

  Future<void> _openTravelerSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return TravelerOptionsSheet(
          onOpenNearbyMosques: () {
            Navigator.of(sheetContext).pop();
            context.push(
              const TravelPlacesMapScreen(
                placeType: TravelerPlaceType.mosque,
              ),
            );
          },
          onOpenTravelAzkar: () {
            Navigator.of(sheetContext).pop();
            context.push(const TravelAthkarScreen());
          },
          onOpenHalalRestaurants: () {
            Navigator.of(sheetContext).pop();
            context.push(
              const TravelPlacesMapScreen(
                placeType: TravelerPlaceType.halalRestaurant,
              ),
            );
          },
          onOpenFlightPrayerTimes: () {
            Navigator.of(sheetContext).pop();
            context.push(const FlightPrayerTimesScreen());
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final features = _items(context);
    final featuredItem = features.first;
    final gridItems = features.skip(1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FeaturedShortcutCard(item: featuredItem),
        SizedBox(height: 14.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: [
              Container(
                width: 6.w,
                height: 6.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gold,
                ),
              ),
              SizedBox(width: 7.w),
              Text(
                'مزايا نافعة',
                style: TextStyle(
                  color: AppColors.brandBrownDeep,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        GridView.builder(
          itemCount: gridItems.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
          ),
          itemBuilder: (context, index) {
            return _FeatureTile(
              item: gridItems[index],
              accentColor:
                  index.isEven ? AppColors.brandGoldLight : AppColors.brandSand,
            );
          },
        ),
      ],
    );
  }
}

class _FeatureShortcut {
  const _FeatureShortcut({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.isHighlighted = false,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool isHighlighted;
}

class _FeaturedShortcutCard extends StatelessWidget {
  const _FeaturedShortcutCard({required this.item});

  final _FeatureShortcut item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(24.r),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              AppColors.brandGoldLight,
              AppColors.gold,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandBrown.withValues(alpha: 0.18),
              blurRadius: 18.r,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -22.h,
              left: -18.w,
              child: Container(
                width: 110.w,
                height: 110.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.brandIvory.withValues(alpha: 0.18),
                ),
              ),
            ),
            Positioned(
              bottom: -34.h,
              right: -6.w,
              child: Icon(
                FlutterIslamicIcons.solidQuran2,
                size: 112.sp,
                color: AppColors.brandIvory.withValues(alpha: 0.11),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.brandIvory.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(999.r),
                            border: Border.all(
                              color: AppColors.brandIvory.withValues(
                                alpha: 0.22,
                              ),
                            ),
                          ),
                          child: Text(
                            'مزية مقترحة',
                            style: TextStyle(
                              color: AppColors.brandIvory,
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        item.label.autoSize(
                          context,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.brandIvory,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        item.subtitle.autoSize(
                          context,
                          maxLines: 2,
                          fontSize: 11.5.sp,
                          minFontSize: 10,
                          color: AppColors.brandIvory.withValues(alpha: 0.92),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    width: 58.w,
                    height: 58.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.brandIvory.withValues(alpha: 0.18),
                      border: Border.all(
                        color: AppColors.brandIvory.withValues(alpha: 0.26),
                      ),
                    ),
                    child: Icon(
                      item.icon,
                      color: AppColors.brandIvory,
                      size: 28.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.item,
    required this.accentColor,
  });

  final _FeatureShortcut item;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.brandMist.withValues(alpha: 0.95),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandBrown.withValues(alpha: 0.08),
              blurRadius: 12.r,
              offset: Offset(0, 7.h),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -18.h,
              left: -10.w,
              child: Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withValues(alpha: 0.16),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42.w,
                    height: 42.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.r),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.brandIvory,
                          accentColor.withValues(alpha: 0.82),
                        ],
                      ),
                    ),
                    child: Icon(
                      item.icon,
                      color: AppColors.brandBrownDeep,
                      size: 20.sp,
                    ),
                  ),
                  const Spacer(),
                  item.label.autoSize(
                    context,
                    maxLines: 1,
                    minFontSize: 11,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.brandBrownDeep,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  item.subtitle.autoSize(
                    context,
                    maxLines: 2,
                    minFontSize: 9,
                    fontSize: 10.5.sp,
                    color: AppColors.secondaryText,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
