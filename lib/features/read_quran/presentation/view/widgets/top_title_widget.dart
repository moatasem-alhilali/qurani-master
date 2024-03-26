import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/read_quran/svg_picture.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';

class TopTitleWidget extends StatelessWidget {
  final int index;
  final bool isRight;
  const TopTitleWidget({super.key, required this.index, required this.isRight});
  @override
  Widget build(BuildContext context) {
    final quranCtrl = context.read<ReadQuranBloc>().quranRH;
    final bookmark = context.read<BookmarkBloc>();

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            BlocBuilder<BookmarkBloc, BookmarkState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    bookmark.bookmarksController
                        .addPageBookmarkOnTap(context, index);
                    BlocProvider.of<BookmarkBloc>(context)
                        .add(SetStateBookmarkEvent());
                  },
                  child: bookmarkIcon(
                    context,
                    height: context.customOrientation(35.h, 55.h),
                    pageNum: lastPageRead,
                  ),
                );
              },
            ),
            const Gap(16),
            Text(
              '${'juz'}: ${convertNumbers(quranCtrl.getJuzByPage(index).juz.toString())}',
              style: TextStyle(
                fontSize: context.customOrientation(18.0, 22.0),
                fontFamily: 'naskh',
                color: const Color(0xff77554B),
              ),
            ),
            const Spacer(),
            Text(
              quranCtrl.getSurahNameFromPage(index),
              style: TextStyle(
                fontSize: context.customOrientation(18.0, 22.0),
                // fontWeight: FontWeight.bold,
                fontFamily: 'naskh',
                color: const Color(0xff77554B),
              ),
            ),
          ],
        ));
  }
}
