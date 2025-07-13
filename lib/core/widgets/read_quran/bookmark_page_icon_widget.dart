import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/features/bookmark/data/request/bookmark_page_request.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:quran_app/features/read_quran/data/quran_read_helper.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';
import 'package:quran_app/main.dart';

class BookmarkIconWidget extends StatefulWidget {
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
  State<BookmarkIconWidget> createState() => _BookmarkIconWidgetState();
}

class _BookmarkIconWidgetState extends State<BookmarkIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.9,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkBloc, BookmarkState>(
      builder: (context, state) {
        final bookmarksController = context.read<BookmarkBloc>();
        final quranCtrl = context.read<ReadQuranBloc>().quranRH;
        final isBookmarked =
            bookmarksController.hasBookmarkPage(widget.pageNumber + 1);

        return GestureDetector(
          onTapDown: (_) {
            _animationController.forward();
          },
          onTapUp: (_) {
            _animationController.reverse();
          },
          onTapCancel: () {
            _animationController.reverse();
          },
          onTap: () => _onTap(quranCtrl, context),
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Semantics(
                  button: true,
                  enabled: true,
                  label: 'Add Bookmark Page ${widget.pageNumber + 1}',
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      key: ValueKey(isBookmarked),
                      color: Theme.of(context).colorScheme.primary,
                      size: widget.width ?? 24,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _onTap(
    QuranReadHelper quranCtrl,
    BuildContext context,
  ) {
    // Add haptic feedback
    HapticFeedback.lightImpact();

    final pageNum = widget.pageNumber + 1;
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
