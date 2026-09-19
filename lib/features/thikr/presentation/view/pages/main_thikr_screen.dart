import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/core/services/json_loader_service.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/my_adia/presentation/view/my_doa_provider.dart';
import 'package:quran_app/features/sabih/presentation/view/tasbeeh_provider.dart';
import 'package:quran_app/features/thikr/presentation/view/widgets/library_screen_kit.dart';
import 'package:quran_app/features/thikr/presentation/view/widgets/thikr_slider.dart';
import 'package:quran_app/features/wird/presentation/view/pages/wird_screen.dart';
import 'package:quran_app/l10n/l10n.dart';

/// مكتبة الأذكار.
///
/// عشرة مربّعات متساوية بظلّ وحدّ كانت تُقرأ ككتلة واحدة لا بداية لها.
/// الآن: وردُ اليوم وحده هو ما يرتفع، وما بعده مجموعات ثلاث من صفوف
/// نحيلة يفصلها خطّ شعرة — الباب واضح قبل أن تصل العين إلى الأيقونة.
class MainThikrScreen extends StatelessWidget {
  const MainThikrScreen({super.key});

  List<_ThikrGroup> _groups(BuildContext context) {
    return [
      _ThikrGroup(
        title: context.l10n.thikrGroupDaily,
        items: [
          _ThikrShortcut(
            label: context.l10n.wirdMorningAdhkar,
            subtitle: context.l10n.thikrMorningSubtitle,
            icon: FlutterIslamicIcons.prayer,
            onTap: () => context.push(const WirdScreen(isMorning: true)),
          ),
          _ThikrShortcut(
            label: context.l10n.wirdEveningAdhkar,
            subtitle: context.l10n.thikrEveningSubtitle,
            icon: FlutterIslamicIcons.prayer,
            onTap: () => context.push(const WirdScreen(isMorning: false)),
          ),
          _ThikrShortcut(
            label: context.l10n.thikrSleepTitle,
            subtitle: context.l10n.thikrSleepSubtitle,
            icon: Icons.bedtime_rounded,
            onTap: () => context.push(
              WirdScreen.custom(
                title: context.l10n.thikrSleepTitle,
                assetPath: JsonLoaderService.adhkarSleepDreamsPath,
              ),
            ),
          ),
          _ThikrShortcut(
            label: context.l10n.thikrPrayerJumuahTitle,
            subtitle: context.l10n.thikrPrayerJumuahSubtitle,
            icon: Icons.mosque_rounded,
            onTap: () => context.push(
              WirdScreen.custom(
                title: context.l10n.thikrPrayerJumuahTitle,
                assetPath: JsonLoaderService.adhkarSalahJumuahPath,
              ),
            ),
          ),
        ],
      ),
      _ThikrGroup(
        title: context.l10n.thikrGroupDuas,
        items: [
          _ThikrShortcut(
            label: context.l10n.thikrQuranicDuasTitle,
            subtitle: context.l10n.thikrQuranicDuasSubtitle,
            icon: Icons.menu_book_outlined,
            onTap: () => context.push(
              WirdScreen.custom(
                title: context.l10n.thikrQuranicDuasTitle,
                assetPath: JsonLoaderService.adhkarQuranicDuasPath,
              ),
            ),
          ),
          _ThikrShortcut(
            label: context.l10n.thikrComprehensiveDuasTitle,
            subtitle: context.l10n.thikrComprehensiveDuasSubtitle,
            icon: Icons.auto_stories_rounded,
            onTap: () => context.push(
              WirdScreen.custom(
                title: context.l10n.thikrComprehensiveDuasTitle,
                assetPath: JsonLoaderService.adhkarQuranDuasPath,
              ),
            ),
          ),
          _ThikrShortcut(
            label: context.l10n.thikrHajjTitle,
            subtitle: context.l10n.thikrHajjSubtitle,
            icon: FlutterIslamicIcons.kaaba,
            onTap: () => context.push(
              WirdScreen.custom(
                title: context.l10n.thikrHajjTitle,
                assetPath: JsonLoaderService.adhkarHajjUmrahPath,
              ),
            ),
          ),
          _ThikrShortcut(
            label: context.l10n.thikrFuneralTitle,
            subtitle: context.l10n.thikrFuneralSubtitle,
            icon: Icons.menu_book_rounded,
            onTap: () => context.push(
              WirdScreen.custom(
                title: context.l10n.thikrFuneralTitle,
                assetPath: JsonLoaderService.adhkarFuneralPath,
              ),
            ),
          ),
        ],
      ),
      _ThikrGroup(
        title: context.l10n.thikrGroupTools,
        items: [
          _ThikrShortcut(
            label: context.l10n.thikrTasbeehTitle,
            subtitle: context.l10n.thikrTasbeehSubtitle,
            icon: FlutterIslamicIcons.tasbih2,
            onTap: () => navigateTo(const TasbeehProvider(), context),
          ),
          _ThikrShortcut(
            label: context.l10n.myDuasTitle,
            subtitle: context.l10n.thikrMyDuasSubtitle,
            icon: FlutterIslamicIcons.muslim2,
            onTap: () => context.push(const MuDoaProvider()),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return GroundScaffoldTheme(
      child: AppScaffoldWidget(
        title: context.l10n.thikrLibraryTitle,
        body: ColoredBox(
          color: skin.ground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ThikrSlider(),
              for (final group in _groups(context))
                _ThikrGroupBlock(group: group),
              SizedBox(height: 18.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThikrGroup {
  const _ThikrGroup({required this.title, required this.items});

  final String title;
  final List<_ThikrShortcut> items;
}

class _ThikrShortcut {
  const _ThikrShortcut({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
}

/// مجموعة واحدة: عنوان صغير بجانبه خطّ، ثم صفوف المجموعة.
class _ThikrGroupBlock extends StatelessWidget {
  const _ThikrGroupBlock({required this.group});

  final _ThikrGroup group;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 5.h),
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
        for (var i = 0; i < group.items.length; i++)
          _ThikrRow(
            item: group.items[i],
            isLast: i == group.items.length - 1,
          ),
      ],
    );
  }
}

/// صفّ مدخل واحد: مربّع أيقونة، اسم، وصف سطر، ثم سهم.
class _ThikrRow extends StatelessWidget {
  const _ThikrRow({required this.item, required this.isLast});

  final _ThikrShortcut item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: item.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        child: Row(
          children: [
            Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: skin.iconChip,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Icon(item.icon, color: skin.accent, size: 15.sp),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
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
                  Text(
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
