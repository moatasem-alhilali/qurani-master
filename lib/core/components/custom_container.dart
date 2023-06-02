import 'package:flutter/material.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';

class CustomContainer extends StatelessWidget {
  CustomContainer({super.key, this.child, this.image, this.height});
  Widget? child;
  String? image;
  double? height;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/$image',
              ),
            ),
          ),
          height: height ?? SizeConfig.blockSizeVertical! * 30,
        ),
        Container(
          height: height ?? SizeConfig.blockSizeVertical! * 30,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                Colors.grey.withOpacity(0.0),
                Colors.black,
              ],
              stops: [0.0, 1.0],
            ),
          ),
          child: child,
        ),
      ],
    );
  }
}
