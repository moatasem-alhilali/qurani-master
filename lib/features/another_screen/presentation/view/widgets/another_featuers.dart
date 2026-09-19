import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/allh_name/presentation/view/pages/allh_name_screen.dart';
import 'package:quran_app/features/another_screen/presentation/view/pages/husin_almuslim_screen.dart';
import 'package:quran_app/features/another_screen/presentation/view/widgets/surah_and_detail_screen.dart';
import 'package:quran_app/features/daily_wird/presentation/view/pages/daily_wird_screen.dart';
import 'package:quran_app/features/floating_adhkar/presentation/view/floating_adhkar_provider.dart';
import 'package:quran_app/features/hadith_40/presentation/view/pages/hadith_40_screen.dart';
import 'package:quran_app/features/home_widgets/presentation/home_widgets_screen.dart';
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
import 'package:quran_app/l10n/l10n.dart';

/// مميزات التطبيق، مقسّمة إلى مجموعات صغيرة بعناوين.
///
/// اثنتا عشرة أيقونة متجاورة بلا تصنيف تُقرأ ككتلة واحدة، فيضيع ما فيها.
/// التقسيم إلى ثلاث مجموعات بأربع أيقونات يجعل الباب واضحًا قبل الأيقونة.
class AnotherFeatures extends StatelessWidget {
  const AnotherFeatures({super.key});

  /// الميزة التي تُفتح كل يوم — تأخذ صفًّا كاملاً فوق المجموعات.
  _FeatureShortcut _lead(BuildContext context) => _FeatureShortcut(
        label: context.l10n.anotherScreenDailyWird,
        subtitle: context.l10n.anotherScreenDailyWirdSubtitle,
        icon: AppIcons.dailyWird,
        onTap: () => context.push(const DailyWirdScreen()),
      );

  List<_FeatureGroup> _groups(BuildContext context) {
    final l10n = context.l10n;
    return [
      _FeatureGroup(
        title: l10n.anotherScreenGroupDaily,
        items: [
          _FeatureShortcut(
            label: l10n.anotherScreenKhatmaPlans,
            subtitle: l10n.anotherScreenKhatmaPlansSubtitle,
            icon: AppIcons.quran,
            onTap: () => context.push(const QuranPlanListScreen()),
          ),
          _FeatureShortcut(
            label: l10n.sabihTitle,
            subtitle: l10n.anotherScreenTasbihSubtitle,
            icon: AppIcons.tasbih,
            onTap: () => context.push(const TasbeehProvider()),
          ),
          _FeatureShortcut(
            label: l10n.floatingAdhkarTitle,
            subtitle: l10n.anotherScreenFloatingAdhkarSubtitle,
            icon: AppIcons.focus,
            onTap: () => context.push(const FloatingAdhkarProvider()),
          ),
          _FeatureShortcut(
            label: l10n.anotherScreenFajrCompanion,
            subtitle: l10n.anotherScreenFajrCompanionSubtitle,
            icon: AppIcons.phone,
            onTap: () => context.push(const SmartOutreachSchedulesScreen()),
          ),
        ],
      ),
      _FeatureGroup(
        title: l10n.anotherScreenGroupKnowledge,
        items: [
          _FeatureShortcut(
            label: l10n.anotherScreenSurahEncyclopedia,
            subtitle: l10n.anotherScreenSurahEncyclopediaSubtitle,
            icon: AppIcons.quran,
            onTap: () => context.push(const SurahWithAllDetailScreen()),
          ),
          _FeatureShortcut(
            label: l10n.anotherScreenNawawi40,
            subtitle: l10n.anotherScreenNawawi40Subtitle,
            icon: AppIcons.book,
            onTap: () => context.push(const Hadith40Screen()),
          ),
          _FeatureShortcut(
            label: l10n.anotherScreenNamesOfAllah,
            subtitle: l10n.anotherScreenNamesOfAllahSubtitle,
            icon: AppIcons.allah,
            onTap: () => context.push(const AllhNameScreen()),
          ),
          _FeatureShortcut(
            label: l10n.anotherScreenRadio,
            subtitle: l10n.anotherScreenRadioSubtitle,
            icon: AppIcons.radio,
            onTap: () => context.push(const RadioScreen()),
          ),
        ],
      ),
      _FeatureGroup(
        title: l10n.anotherScreenGroupTools,
        items: [
          _FeatureShortcut(
            label: l10n.anotherScreenHisnMuslim,
            subtitle: l10n.anotherScreenHisnMuslimSubtitle,
            icon: AppIcons.bookOpen,
            onTap: () => context.push(const HisnMuslimScreen()),
          ),
          _FeatureShortcut(
            label: l10n.anotherScreenMyDuas,
            subtitle: l10n.anotherScreenMyDuasSubtitle,
            icon: AppIcons.user,
            onTap: () => context.push(const MuDoaProvider()),
          ),
          _FeatureShortcut(
            label: l10n.anotherScreenTraveler,
            subtitle: l10n.anotherScreenTravelerSubtitle,
            icon: AppIcons.traveler,
            onTap: () => _openTravelerSheet(context),
          ),
          _FeatureShortcut(
            label: l10n.anotherScreenHomeWidgets,
            subtitle: l10n.anotherScreenHomeWidgetsSubtitle,
            icon: AppIcons.widgets,
            onTap: () => context.push(const HomeWidgetsScreen()),
          ),
        ],
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
    final groups = _groups(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FeaturedShortcutRow(item: _lead(context)),
        for (final group in groups) _FeatureGroupBlock(group: group),
      ],
    );
  }
}

class _FeatureGroup {
  const _FeatureGroup({required this.title, required this.items});

  final String title;
  final List<_FeatureShortcut> items;
}

class _FeatureShortcut {
  const _FeatureShortcut({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final HugeIconData icon;
  final VoidCallback onTap;
}

/// مجموعة واحدة: عنوان صغير ثم صفّ أيقوناتها.
class _FeatureGroupBlock extends StatelessWidget {
  const _FeatureGroupBlock({required this.group});

  final _FeatureGroup group;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(2.w, 12.h, 2.w, 7.h),
          child: Row(
            children: [
              Text(
                group.title,
                style: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.8),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Divider(height: 1, thickness: 1, color: skin.hairline),
              ),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < 4; i++) ...[
              if (i != 0) SizedBox(width: 6.w),
              Expanded(
                child: i < group.items.length
                    ? _FeatureTile(item: group.items[i])
                    : const SizedBox.shrink(),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

/// الميزة الأولى تأخذ صفًّا كاملاً ووصفًا: هي ما يفتحه المستخدم كل يوم.
class _FeaturedShortcutRow extends StatelessWidget {
  const _FeaturedShortcutRow({required this.item});

  final _FeatureShortcut item;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            AppIcon(item.icon, color: skin.accent, size: 17.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AutoSizeText(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.ink,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  AutoSizeText(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.inkSoft.withValues(alpha: 0.78),
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            AppIcon(
              Directionality.of(context) == TextDirection.rtl
                  ? AppIcons.chevronLeft
                  : AppIcons.chevronRight,
              color: skin.accent,
              size: 15.sp,
            ),
          ],
        ),
      ),
    );
  }
}

/// مربّع ميزة: أيقونة صغيرة واسم تحتها، بلا حدّ ولا ظل.
class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.item});

  final _FeatureShortcut item;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 6.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: skin.iconChip,
                borderRadius: BorderRadius.circular(11.r),
              ),
              child: Center(
                child: AppIcon(item.icon, color: skin.accent, size: 16.sp),
              ),
            ),
            SizedBox(height: 6.h),
            // ارتفاع ثابت لسطرين: يمنع اختلاف ارتفاع المربّعات في الصف
            // الواحد بين اسم من سطر واسم من سطرين.
            SizedBox(
              height: 26.h,
              child: AutoSizeText(
                item.label,
                maxLines: 2,
                textAlign: TextAlign.center,
                minFontSize: 7,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: skin.ink.withValues(alpha: 0.9),
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
