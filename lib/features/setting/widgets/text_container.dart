import 'package:flutter/material.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';

import '../../../core/shared/export/export-shared.dart';

class TextContainer extends StatelessWidget {
  TextContainer(
      {Key? key,
      required this.text,
      this.fontFamily,
      this.fontSize,
      this.height})
      : super(key: key);
  String? text;
  String? fontFamily;
  double? fontSize;
  double? height;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      height: height ?? SizeConfig.blockSizeVertical! * 20,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).primaryColor,
      ),
      child: SingleChildScrollView(
        child: Text(
          text!,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.start,
          style: TextStyle(
            height: 2,
            fontSize: fontSize ?? fontSizeQuran!.toDouble(),
            fontFamily: fontFamily ?? defaultNameQuran,
            color: const Color.fromARGB(255, 225, 223, 223),
          ),
        ),
      ),
    );
  }
}
