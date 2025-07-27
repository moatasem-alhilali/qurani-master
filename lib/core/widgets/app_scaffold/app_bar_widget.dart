import 'package:flutter/material.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    required this.title,
    this.onBack,
    this.isCenterTitle = true,
    this.elevation = 0.0,
    super.key,
  });

  final String title;
  final VoidCallback? onBack;
  final bool isCenterTitle;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      color:
          elevation != 0 ? context.scaffoldBackgroundColor : Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onBack ??
                () {
                  context.pop();
                },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          if (isCenterTitle) Text(title),
          const SizedBox(),
        ],
      ),
    );
  }
}
