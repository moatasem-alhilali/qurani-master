import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/auto_text.dart';

class ItemCategory extends StatelessWidget {
  const ItemCategory({required this.onTap, super.key, this.title});
  final void Function()? onTap;
  final String? title;
  @override
  Widget build(BuildContext context) {
    return StyleButtonWrap(
      onTap: onTap,
      child: CardWidget(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        border: Border.all(color: context.primaryColor),
        // clipBehavior: Clip.antiAliasWithSaveLayer,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(8),
        //   color: const Color.fromARGB(65, 158, 158, 158),
        // ),
        height: context.getHight(25),
        width: context.getWidth(25),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: title!.autoSize(
              context,
              maxLines: 2,
              fontSize: 22,
              // color: context.onPrimary,
            ),
          ),
        ),
      ),
    ).animate().fade();
  }
}
