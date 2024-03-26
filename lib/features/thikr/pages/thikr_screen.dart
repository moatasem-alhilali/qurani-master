import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:quran_app/core/theme/themeData.dart';
import 'package:quran_app/features/my_adia/page/doua_home.dart';
import 'package:quran_app/features/sabih/pages/sabih_screen.dart';
import 'package:quran_app/features/thikr/pages/wird_screen.dart';

import 'package:quran_app/features/thikr/widgets/thikr_slider.dart';

class ThikrScreen extends StatelessWidget {
  const ThikrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BaseHome(
      title: "الا بذكر الله تطمئن القلوب",
      body: Column(
        children: [
          const ThikrSlider(),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _Item(
                  onPressed: () {
                    navigateTo(const WirdScreen(), context);
                  },
                  text: "أذكار المساء",
                  icon: FlutterIslamicIcons.prayer,
                ),
              ),
              Expanded(
                child: _Item(
                  onPressed: () {
                    navigateTo(const WirdScreen(), context);
                  },
                  text: "أذكار الصباح",
                  icon: FlutterIslamicIcons.prayer,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _Item(
                  onPressed: () {
                    navigateTo(SabihScreen(), context);
                  },
                  text: "التسبيح",
                  icon: FlutterIslamicIcons.tasbih2,
                ),
              ),
              Expanded(
                child: _Item(
                  onPressed: () {
                    navigateTo(const DouaHome(), context);
                  },
                  text: "أدعيتي",
                  icon: FlutterIslamicIcons.muslim2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: FxColors.secondary,
            ),
            child: Icon(
              icon,
              size: 40,
              // color: DarkColors.customPrimary,
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
