import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:quran_app/core/theme/themeData.dart';

class CustomSvgContainer extends StatelessWidget {
  CustomSvgContainer({super.key, this.child, this.image, this.height});
  Widget? child;
  String? image;
  double? height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.blockSizeVertical! * 30,
      child: Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[
          Opacity(
            opacity: 0.1,
            child: SvgPicture.asset(
              image!,
              width: double.infinity,
              fit: BoxFit.cover,
              height: SizeConfig.blockSizeVertical! * 30,
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.transparent,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
