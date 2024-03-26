import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';

class MyAnimatedTextTyper extends StatelessWidget {
  const MyAnimatedTextTyper({
    super.key,
    this.text,
    this.second,
  });
  final String? text;
  final String? second;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: context.getWidth(90),
      child: DefaultTextStyle(
        style: titleMedium(context),
        child: AnimatedTextKit(
          pause: 2.seconds,
          totalRepeatCount: 1,
          animatedTexts: [
            TypewriterAnimatedText(text!),
          ],
          onTap: () {
            print('Tap Event');
          },
        ),
      ),
    );
  }
}
