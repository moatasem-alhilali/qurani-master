import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:quran_app/core/components/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/my_adia/presentation/view/my_doa_provider.dart';
import 'package:quran_app/features/sabih/presentation/view/tasbeeh_provider.dart';
import 'package:quran_app/features/thikr/presentation/view/widgets/thikr_slider.dart';
import 'package:quran_app/features/wird/presentation/view/pages/wird_screen.dart';

class MainThikrScreen extends StatelessWidget {
  const MainThikrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      title: 'الا بذكر الله تطمئن القلوب',
      body: Column(
        children: [
          const ThikrSlider(),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _Item(
                  onPressed: () {
                    context.push(const WirdScreen(isMorning: false));
                  },
                  text: 'أذكار المساء',
                  icon: FlutterIslamicIcons.prayer,
                ),
              ),
              Expanded(
                child: _Item(
                  onPressed: () {
                    context.push(const WirdScreen(isMorning: true));
                  },
                  text: 'أذكار الصباح',
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
                    navigateTo(const TasbeehProvider(), context);
                  },
                  text: 'التسبيح',
                  icon: FlutterIslamicIcons.tasbih2,
                ),
              ),
              Expanded(
                child: _Item(
                  onPressed: () {
                    context.push(const MuDoaProvider());
                  },
                  text: 'أدعيتي',
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
