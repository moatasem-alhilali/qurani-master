import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/features/bookmark/data/request/bookmark_page_request.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:quran_app/features/read_quran/data/quran_read_helper.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';
import 'package:quran_app/main.dart';

class BookmarkIconWidget extends StatelessWidget {
  const BookmarkIconWidget({
    required this.pageNumber,
    this.width,
    this.height,
    super.key,
  });
  final int pageNumber;
  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkBloc, BookmarkState>(
      builder: (context, state) {
        final bookmarksController = context.read<BookmarkBloc>();
        final quranCtrl = context.read<ReadQuranBloc>().quranRH;

        return GestureDetector(
          onTap: () => _onTap(quranCtrl, context),
          child: Semantics(
            button: true,
            enabled: true,
            label: 'Add Bookmark Page ${pageNumber + 1}',
            child: Icon(
              bookmarksController.hasBookmarkPage(pageNumber + 1)
                  ? Icons.bookmark
                  : Icons.bookmark_border,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        );
      },
    );
  }

  void _onTap(
    QuranReadHelper quranCtrl,
    BuildContext context,
  ) {
    final pageNum = pageNumber + 1;
    final bookmark = context.read<BookmarkBloc>();

    final hasBookmark = bookmark.hasBookmarkPage(pageNum);
    if (hasBookmark) {
      final bookmarkId = bookmark.getBookmarkPageId(pageNum);
      final bookmarkPageRequest = BookmarkPageRequest(
        pageNum: pageNum,
        sorahName: quranCtrl.getSurahNameFromPage(pageNum),
        id: bookmarkId,
        lastRead: DateTime.now().toIso8601String(),
      );
      logger.i(bookmarkPageRequest.toJson());
      bookmark.add(
        DeleteBookmarkPageEvent(
          bookmarkPageRequest,
        ),
      );
    } else {
      final bookmarkPageRequest = BookmarkPageRequest(
        pageNum: pageNum,
        sorahName: quranCtrl.getSurahNameFromPage(pageNum),
        lastRead: DateTime.now().toIso8601String(),
      );
      bookmark.add(
        AddBookmarkPageEvent(
          bookmarkPageRequest,
        ),
      );
    }
  }
}
