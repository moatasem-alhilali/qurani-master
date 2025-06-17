import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderStyleSheet extends StatelessWidget {
  const HeaderStyleSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Container(
          //   height: 6.h,
          //   width: 20.w,
          //   margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(8),
          //     color: FxColors.primary,
          //   ),
          // ),
          Container(
            height: 6.h,
            width: 60.w,
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xffcdcfd0),
            ),
          ),
          // Container(
          //   height: 6.h,
          //   width: 20.w,
          //   margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(8),
          //     color: FxColors.primary,
          //   ),
          // ),
        ],
      ),
    );
  }
}
