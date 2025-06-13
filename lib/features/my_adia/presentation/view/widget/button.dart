import 'package:flutter/material.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';

class MyButtonCustom extends StatelessWidget {
  MyButtonCustom(
      {Key? key,
      required this.onTap,
      required this.lable,
      this.sizeFont,
      this.color})
      : super(key: key);
  final Function() onTap;
  final String lable;
  final double? sizeFont;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        // width: 100,
        height: 50,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: FxColors.primary,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              lable,
              style: titleSmall(context)
                  .copyWith(fontSize: sizeFont ?? 14, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
