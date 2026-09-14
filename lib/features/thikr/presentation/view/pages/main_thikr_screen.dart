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
        title: 'أذكار يومك',
        items: [
          _ThikrShortcut(
            label: 'أذكار الصباح',
            subtitle: 'وردك بعد الفجر إلى ارتفاع النهار',
            icon: FlutterIslamicIcons.prayer,
            onTap: () => context.push(const WirdScreen(isMorning: true)),
          ),
          _ThikrShortcut(
            label: 'أذكار المساء',
            subtitle: 'وردك بعد العصر إلى الليل',
            icon: FlutterIslamicIcons.prayer,
            onTap: () => context.push(const WirdScreen(isMorning: false)),
          ),
          _ThikrShortcut(
            label: 'أذكار النوم والأحلام',
            subtitle: 'ما تقوله قبل النوم وعند الفزع منه',
            icon: Icons.bedtime_rounded,
            onTap: () => context.push(
              const WirdScreen.custom(
                title: 'أذكار النوم والأحلام',
                assetPath: JsonLoaderService.adhkarSleepDreamsPath,
              ),
            ),
          ),
          _ThikrShortcut(
            label: 'أذكار الصلاة والجمعة',
            subtitle: 'أذكار الأذان ودبر الصلاة ويوم الجمعة',
            icon: Icons.mosque_rounded,
            onTap: () => context.push(
              const WirdScreen.custom(
                title: 'أذكار الصلاة والجمعة',
                assetPath: JsonLoaderService.adhkarSalahJumuahPath,
              ),
            ),
          ),
        ],
      ),
      _ThikrGroup(
        title: 'أدعية مأثورة',
        items: [
          _ThikrShortcut(
            label: 'الأدعية القرآنية',
            subtitle: 'دعاء الأنبياء كما جاء في كتاب الله',
            icon: Icons.menu_book_outlined,
            onTap: () => context.push(
              const WirdScreen.custom(
                title: 'الأدعية القرآنية',
                assetPath: JsonLoaderService.adhkarQuranicDuasPath,
              ),
            ),
          ),
          _ThikrShortcut(
            label: 'أدعية جامعة',
            subtitle: 'دعوات تجمع خير الدنيا والآخرة',
            icon: Icons.auto_stories_rounded,
            onTap: () => context.push(
              const WirdScreen.custom(
                title: 'أدعية جامعة',
                assetPath: JsonLoaderService.adhkarQuranDuasPath,
              ),
            ),
          ),
          _ThikrShortcut(
            label: 'أدعية الحج والعمرة',
            subtitle: 'دعاء الإحرام والطواف والسعي والمشاعر',
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
            subtitle: 'ما يُقال في الصلاة على الميت وعند القبر',
            icon: Icons.menu_book_rounded,
            onTap: () => context.push(
              const WirdScreen.custom(
                title: 'أدعية للميت والجنازة',
                assetPath: JsonLoaderService.adhkarFuneralPath,
              ),
            ),
          ),
        ],
      ),
      _ThikrGroup(
        title: 'أدواتك',
        items: [
          _ThikrShortcut(
            label: 'التسبيح',
            subtitle: 'عدّاد يحصي تسبيحك ويحفظ حصيلة يومك',
            icon: FlutterIslamicIcons.tasbih2,
            onTap: () => navigateTo(const TasbeehProvider(), context),
          ),
          _ThikrShortcut(
            label: 'أدعيتي',
            subtitle: 'أدعيتك التي أضفتها بنفسك في مكان واحد',
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
        title: 'مكتبة الأذكار',
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
            AppIcon(AppIcons.chevronLeft, color: skin.accent, size: 15.sp),
          ],
        ),
      ),
    );
  }
}
