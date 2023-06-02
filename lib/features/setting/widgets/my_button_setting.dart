import 'package:flutter/material.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';

class MyButton extends StatelessWidget {
  MyButton({
    Key? key,
    required this.image,
    required this.text,
    this.onTap,
    required this.icon,
    this.height,
  }) : super(key: key);
  final String text;
  final String image;
  final double? height;
  void Function()? onTap;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(
              width: 10,
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
