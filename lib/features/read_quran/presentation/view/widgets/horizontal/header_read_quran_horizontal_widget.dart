import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/read_quran/bookmark_page_icon_widget.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran/read_quran_bloc.dart';

class HeaderReadQuranHorizontalWidget extends StatelessWidget {
  const HeaderReadQuranHorizontalWidget({
    required this.index,
    required this.state,
    super.key,
  });
  final int index;
  final ReadQuranState state;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              BookmarkIconWidget(
                height: context.customOrientation(35.h, 55.h) as double,
                pageNumber: index,
              ),
              const Gap(16),
              Text(
                "الصفحة ${convertNumbers('${index + 1}')}",
                style: TextStyle(
                  fontSize: context.customOrientation(
                    18.0,
                    22.0,
                  ) as double,
                  // fontFamily: 'naskh',
                  color: context.primaryColor,
                ),
              ),
              const Spacer(),
              Text(
                state.getSurahNameByPageIndex(index),
                style: TextStyle(
                  fontSize: context.customOrientation(18.0, 22.0) as double,
                  // fontWeight: FontWeight.bold,
                  // fontFamily: 'naskh',
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          Divider(
            color: context.primaryColor,
          ),
        ],
      ),
    );
  }
}
