import 'package:flutter/material.dart';
import 'package:quran_app/core/theme/themeData.dart';

class CustomAppBar extends StatelessWidget {
  CustomAppBar({super.key, this.icon, required this.text, this.iconWidget});
  final String text;
  IconData? icon;
  Widget? iconWidget;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        // color: ColorsManager.customScaffoldColor,
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            iconWidget ??
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
            Text(
              text,
              style: titleMedium(context),
            ),
          ],
        ),
      ),
    );
  }
}
