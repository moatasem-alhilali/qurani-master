import 'package:flutter/material.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';

class BaseHeder extends StatelessWidget {
  const BaseHeder({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
      child: SizedBox(
        height: context.getHight(4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: double.infinity,
              width: context.getWidth(1),
              decoration: BoxDecoration(
                color: FxColors.primary,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              text,
              style: titleMedium(context).copyWith(color: FxColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
