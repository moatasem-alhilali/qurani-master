import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/auto_text.dart';
import 'package:quran_app/features/allh_name/presentation/view/pages/allh_name_screen.dart';
import 'package:quran_app/features/another_screen/presentation/view/pages/husin_almuslim_screen.dart';
import 'package:quran_app/features/another_screen/presentation/view/widgets/surah_and_detail_screen.dart';
import 'package:quran_app/features/daily_wird/presentation/view/pages/daily_wird_screen.dart';
import 'package:quran_app/features/floating_adhkar/presentation/view/floating_adhkar_provider.dart';
import 'package:quran_app/features/hadith_40/presentation/view/pages/hadith_40_screen.dart';
import 'package:quran_app/features/my_adia/presentation/view/my_doa_provider.dart';
import 'package:quran_app/features/quran_plan/presentation/view/pages/quran_plan_list_screen.dart';
import 'package:quran_app/features/radio/presentation/view/pages/radio_screen.dart';
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
        label: 'الإذاعة',
        subtitle: 'إذاعات قرآنية وإسلامية ببث مباشر متواصل',
        icon: Icons.radio_rounded,
        onTap: () => context.push(const RadioScreen()),
      ),
      _FeatureShortcut(
        label: 'خطط الختمة',
        subtitle: 'خطط مرتبة لإتمام الختمة بما يناسبك',
        icon: FlutterIslamicIcons.solidQuran2,
        onTap: () => context.push(const QuranPlanListScreen()),
      ),
      _FeatureShortcut(
        label: 'صحبة الفجر',
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
        label: 'الأذكار العائمة',
        subtitle: 'أذكار قصيرة تظهر فوق التطبيقات الأخرى',
        icon: Icons.filter_center_focus_rounded,
        onTap: () => context.push(const FloatingAdhkarProvider()),
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
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.primaryColor,
                ),
              ),
              SizedBox(width: 7.w),
              Text(
                'مزايا نافعة',
                style: TextStyle(
                  color: context.onSurfaceColor,
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
            crossAxisCount: 4,
            childAspectRatio: 0.84,
            crossAxisSpacing: 7.w,
            mainAxisSpacing: 7.h,
          ),
          itemBuilder: (context, index) {
            return _FeatureTile(
              item: gridItems[index],
              accentColor: index.isEven
                  ? context.primaryContainer
                  : context.secondaryContainer,
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
    final borderRadius = BorderRadius.circular(24.r);
    final accent = context.primaryColor;
    final chipBackground = accent.withValues(alpha: 0.10);
    final chipBorder = accent.withValues(alpha: 0.16);
    final cardBackground = context.surfaceColor;
    final cardBackgroundSoft = context.surfaceVariant.withValues(alpha: 0.42);
    final titleColor = context.onSurfaceColor;
    final subtitleColor = context.onSurfaceVariant.withValues(alpha: 0.88);

    return InkWell(
      onTap: item.onTap,
      borderRadius: borderRadius,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
            colors: [
              cardBackground,
              cardBackgroundSoft,
            ],
          ),
          border: Border.all(
            color: context.outline.withValues(alpha: 0.85),
          ),
          boxShadow: [
            BoxShadow(
              color: context.shadow.withValues(alpha: 0.10),
              blurRadius: 14.r,
              offset: Offset(0, 7.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: 4.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        accent,
                        accent.withValues(alpha: 0.18),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -16.h,
                left: -18.w,
                child: Container(
                  width: 82.w,
                  height: 82.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent.withValues(alpha: 0.06),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 16.h),
                child: Row(
                  children: [
                    Container(
                      width: 52.w,
                      height: 52.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.r),
                        color: chipBackground,
                        border: Border.all(
                          color: chipBorder,
                        ),
                      ),
                      child: Icon(
                        item.icon,
                        color: accent,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: chipBackground,
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                            child: Text(
                              'مزية مقترحة',
                              style: TextStyle(
                                color: accent,
                                fontSize: 9.6.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          item.label.autoSize(
                            context,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w800,
                              color: titleColor,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          item.subtitle.autoSize(
                            context,
                            maxLines: 2,
                            fontSize: 11.sp,
                            minFontSize: 10,
                            color: subtitleColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
    final borderRadius = BorderRadius.circular(20.r);
    final surface = context.surfaceColor;
    final outline = context.outline.withValues(alpha: 0.95);
    final shadow = context.shadow.withValues(alpha: 0.08);
    final titleColor = context.onSurfaceColor;
    final accentSoft = accentColor.withValues(alpha: 0.16);
    final accentStrong = accentColor.withValues(alpha: 0.90);

    return InkWell(
      onTap: item.onTap,
      borderRadius: borderRadius,
      child: Ink(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: borderRadius,
          border: Border.all(
            color: outline,
          ),
          boxShadow: [
            BoxShadow(
              color: shadow,
              blurRadius: 8.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: 3.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        accentStrong,
                        accentSoft,
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 38.w,
                        height: 38.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accentSoft,
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.18),
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 24.w,
                            height: 24.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9.r),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  accentColor.withValues(alpha: 0.72),
                                  accentStrong,
                                ],
                              ),
                            ),
                            child: Icon(
                              item.icon,
                              color: context.onPrimaryColor,
                              size: 12.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 7.h),
                      item.label.autoSize(
                        context,
                        maxLines: 2,
                        minFontSize: 7,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 9.3.sp,
                          fontWeight: FontWeight.w800,
                          color: titleColor,
                          height: 1.15,
                        ),
                      ),
                    ],
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
