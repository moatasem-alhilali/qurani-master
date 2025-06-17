import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/core/widgets/read_quran/svg_picture.dart';
import 'package:quran_app/features/bookmark/data/request/bookmark_ayah_request.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';

class AddBookmarkAyahButton extends StatelessWidget {
  const AddBookmarkAyahButton({
    required this.surahNum,
    required this.ayahNum,
    required this.ayahUQNum,
    required this.pageIndex,
    required this.surahName,
    super.key,
    this.cancel,
  });
  final int surahNum;
  final int ayahNum;
  final int ayahUQNum;
  final int pageIndex;
  final String surahName;

  final Function? cancel;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkBloc, BookmarkState>(
      builder: (context, state) {
        return Row(
          children: [
            Text(
              'اضافة الايه',
              style: titleMedium(context).copyWith(
                fontSize: 16.sp,
              ),
            ),
            const Gap(10),
            GestureDetector(
              child: Semantics(
                button: true,
                enabled: true,
                label: 'Add Bookmark Ayah',
                child: context
                        .read<BookmarkBloc>()
                        .hasBookmarkAyah(surahNum, ayahNum)
                    ? bookmark_icon2(height: 35)
                    : bookmark_icon(height: 30),
              ),
              onTap: () async {
                _onTap(context, state);
              },
            ),
          ],
        );
      },
    );
  }

  void _onTap(BuildContext context, BookmarkState state) {
    final bookmarkBloc = context.read<BookmarkBloc>();
    final hasBookmark = bookmarkBloc.hasBookmarkAyah(surahNum, ayahNum);
    if (hasBookmark) {
      final bookmarkId = bookmarkBloc.getBookmarkAyahId(surahNum, ayahNum);
      bookmarkBloc.add(
        DeleteBookmarkAyahEvent(
          BookmarkAyahRequest(
            ayahNumber: ayahNum,
            surahNumber: surahNum,
            id: bookmarkId,
          ),
        ),
      );
    } else {
      final bookmarksAyahs = BookmarkAyahRequest(
        ayahNumber: ayahNum,
        surahNumber: surahNum,
        ayahUQNumber: ayahUQNum,
        pageNumber: pageIndex,
        surahName: surahName,
        lastRead: DateTime.now().toString(),
      );
      bookmarkBloc.add(
        AddBookmarkAyahEvent(
          bookmarksAyahs,
        ),
      );
    }
    context.read<ReadQuranBloc>().add(SetStateRBlocEvent());
  }
}
