import 'package:flutter/material.dart';
import 'package:quran_library/src/core/utils/app_colors.dart';

class HeaderDialogWidget extends StatelessWidget {
  final bool? isDark;
  final String title;
  final Gradient? backgroundGradient;
  final Color? titleColor;
  final Color? closeIconColor;
  const HeaderDialogWidget({
    super.key,
    this.isDark = false,
    required this.title,
    this.backgroundGradient,
    this.titleColor,
    this.closeIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.centerEnd,
      children: [
        Container(
          height: 45,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: backgroundGradient ??
                LinearGradient(
                  begin: AlignmentDirectional.centerEnd,
                  end: AlignmentDirectional.centerStart,
                  colors: [
                    Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: .12),
                    Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: .04),
                  ],
                ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'cairo',
              height: 1.3,
              color: titleColor ?? AppColors.getTextColor(isDark!),
              package: 'quran_library',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: IconButton(
            tooltip: 'إغلاق',
            icon: Icon(Icons.close,
                color: closeIconColor ?? AppColors.getTextColor(isDark!),
                size: 20),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
      ],
    );
  }
}
