import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/widgets/read_quran/svg_picture.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:quran_app/features/read_quran/data/model/bookmark_ayahs.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';

class AddBookmarkButton extends StatelessWidget {
  final int surahNum;
  final int ayahNum;
  final int ayahUQNum;
  final int pageIndex;
  final String surahName;
  final Function? cancel;

  const AddBookmarkButton({
    super.key,
    required this.surahNum,
    required this.ayahNum,
    required this.ayahUQNum,
    required this.pageIndex,
    required this.surahName,
    this.cancel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadQuranBloc, ReadQuranState>(
      builder: (context, state) {
        return BlocBuilder<BookmarkBloc, BookmarkState>(
          builder: (context, state) {
            final bookmarkCon =
                context.read<BookmarkBloc>().bookmarksController;
            return GestureDetector(
              child: Semantics(
                button: true,
                enabled: true,
                label: 'Add Bookmark',
                child: bookmarkCon.hasBookmark2(surahNum, ayahNum)
                    ? bookmark_icon2(height: 35.0)
                    : bookmark_icon(height: 30.0),
              ),
              onTap: () async {
                context.read<ReadQuranBloc>().add(SetStateRBlocEvent());
                if (bookmarkCon.hasBookmark2(surahNum, ayahNum)) {
                  BlocProvider.of<BookmarkBloc>(context)
                      .add(DeleteBookmarkEvent(ayahNum, surahNum));
                  return;
                } else {
                  BlocProvider.of<BookmarkBloc>(context).add(
                    AddBookmarkEvent(
                      BookmarksAyahs(
                        null,
                        surahName,
                        surahNum,
                        pageIndex,
                        ayahNum,
                        ayahUQNum,
                        surahName,
                      ),
                    ),
                  );
                  return;
                }
              },
            );
          },
        );
      },
    );
  }
}
