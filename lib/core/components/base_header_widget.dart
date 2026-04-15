import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';

class BaseHederWidget extends StatelessWidget {
  const BaseHederWidget({required this.text, super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 15.sp),
      child: SizedBox(
        height: context.getHight(4),
        child: Row(
          children: [
            Text(
              text,
              style: titleMedium(context).copyWith(
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
