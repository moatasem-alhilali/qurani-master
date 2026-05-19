import 'package:flutter/material.dart';
import 'package:quran_app/core/components/button/button_icon_circle_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';

class CloseIconWidget extends StatelessWidget {
  const CloseIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ButtonIconCircleWidget(
          icon: AppIcon(
            AppIcons.back,
            color: context.primaryColor,
          ),
          onPressed: () {
            context.pop();
          },
        ),
      ],
    );
  }
}
