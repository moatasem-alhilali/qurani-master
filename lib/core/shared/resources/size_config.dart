import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHight;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;
  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHight = _mediaQueryData!.size.height;
    blockSizeHorizontal = screenWidth! / 100;
    blockSizeVertical = screenHight! / 100;
  }
}
// font use use :SizeConfig.blockSizeHorizontal! * 3.5
//hight:SizeConfig.blockSizeVertical! * 50