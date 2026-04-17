import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/services/json_loader_service.dart';
import 'package:quran_app/core/theme/theme_data.dart';
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
    final width = MediaQuery.of(context).size.width;
    final cardWidth = (width - 8 * 3) / 2;

    return AppScaffoldWidget(
      title: 'مكتبة الأذكار',
      body: Column(
        children: [
          const ThikrSlider(),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
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
        ],
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
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          CardWidget(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(8),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(12),
            //   color: context.secondaryColor,
            // ),
            child: Icon(
              icon,
              size: 40,
              color: context.primaryColor,
            ),
          ),
          // if (isSvgImage)

          const SizedBox(height: 5),
          Text(
            text,
            textAlign: TextAlign.center,
            style: titleSmall(context).copyWith(),
          ),
        ],
      ),
    );
  }
}
