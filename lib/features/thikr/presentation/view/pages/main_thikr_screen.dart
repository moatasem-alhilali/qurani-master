import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/services/json_loader_service.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/my_adia/presentation/view/my_doa_provider.dart';
import 'package:quran_app/features/sabih/presentation/view/tasbeeh_provider.dart';
import 'package:quran_app/features/thikr/presentation/view/widgets/thikr_slider.dart';
import 'package:quran_app/features/wird/presentation/view/pages/wird_screen.dart';

class MainThikrScreen extends StatelessWidget {
  const MainThikrScreen({super.key});

  List<_ThikrShortcut> _items(BuildContext context) {
    return [
      _ThikrShortcut(
        label: 'أذكار المساء',
        icon: FlutterIslamicIcons.prayer,
        onTap: () => context.push(const WirdScreen(isMorning: false)),
      ),
      _ThikrShortcut(
        label: 'أذكار الصباح',
        icon: FlutterIslamicIcons.prayer,
        onTap: () => context.push(const WirdScreen(isMorning: true)),
      ),
      _ThikrShortcut(
        label: 'أذكار النوم والأحلام',
        icon: Icons.bedtime_rounded,
        onTap: () => context.push(
          const WirdScreen.custom(
            title: 'أذكار النوم والأحلام',
            assetPath: JsonLoaderService.adhkarSleepDreamsPath,
          ),
        ),
      ),
      _ThikrShortcut(
        label: 'أدعية الحج والعمرة',
        icon: FlutterIslamicIcons.kaaba,
        onTap: () => context.push(
          const WirdScreen.custom(
            title: 'أدعية الحج والعمرة',
            assetPath: JsonLoaderService.adhkarHajjUmrahPath,
          ),
        ),
      ),
      _ThikrShortcut(
        label: 'أدعية للميت والجنازة',
        icon: Icons.menu_book_rounded,
        onTap: () => context.push(
          const WirdScreen.custom(
            title: 'أدعية للميت والجنازة',
            assetPath: JsonLoaderService.adhkarFuneralPath,
          ),
        ),
      ),
      _ThikrShortcut(
        label: 'أدعية جامعة',
        icon: Icons.auto_stories_rounded,
        onTap: () => context.push(
          const WirdScreen.custom(
            title: 'أدعية جامعة',
            assetPath: JsonLoaderService.adhkarQuranDuasPath,
          ),
        ),
      ),
      _ThikrShortcut(
        label: 'الأدعية القرآنية',
        icon: Icons.menu_book_outlined,
        onTap: () => context.push(
          const WirdScreen.custom(
            title: 'الأدعية القرآنية',
            assetPath: JsonLoaderService.adhkarQuranicDuasPath,
          ),
        ),
      ),
      _ThikrShortcut(
        label: 'أذكار الصلاة والجمعة',
        icon: Icons.mosque_rounded,
        onTap: () => context.push(
          const WirdScreen.custom(
            title: 'أذكار الصلاة والجمعة',
            assetPath: JsonLoaderService.adhkarSalahJumuahPath,
          ),
        ),
      ),
      _ThikrShortcut(
        label: 'التسبيح',
        icon: FlutterIslamicIcons.tasbih2,
        onTap: () => navigateTo(const TasbeehProvider(), context),
      ),
      _ThikrShortcut(
        label: 'أدعيتي',
        icon: FlutterIslamicIcons.muslim2,
        onTap: () => context.push(const MuDoaProvider()),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final items = _items(context);
    final cardWidth = (MediaQuery.sizeOf(context).width - 32.w - 12.w) / 2;

    return AppScaffoldWidget(
      title: 'مكتبة الأذكار',
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ThikrSlider(),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: items
                    .map(
                      (item) => SizedBox(
                        width: cardWidth,
                        child: _Item(
                          onPressed: item.onTap,
                          text: item.label,
                          icon: item.icon,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

class _ThikrShortcut {
  const _ThikrShortcut({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
}

class _Item extends StatelessWidget {
  const _Item({
    required this.onPressed,
    required this.text,
    this.icon,
  });

  final String text;

  final IconData? icon;

  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20.r);
    final accent = context.primaryColor;
    final cardBackground = context.surfaceColor;
    final cardBackgroundSoft = context.surfaceVariant.withValues(alpha: 0.42);
    final cardBorder = context.outline.withValues(alpha: 0.85);
    final shadow = context.shadow.withValues(alpha: 0.10);
    final titleColor = context.onSurfaceColor;
    final chipBackground = accent.withValues(alpha: 0.10);
    final chipBorder = accent.withValues(alpha: 0.16);

    return InkWell(
      onTap: onPressed,
      borderRadius: borderRadius,
      child: Ink(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              cardBackground,
              cardBackgroundSoft,
            ],
          ),
          border: Border.all(
            color: cardBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: shadow,
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
                  height: 3.h,
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
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent.withValues(alpha: 0.06),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 18.h),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 52.w,
                        height: 52.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: chipBackground,
                          border: Border.all(color: chipBorder),
                        ),
                        child: Icon(
                          icon,
                          color: accent,
                          size: 26.sp,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        text,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
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
