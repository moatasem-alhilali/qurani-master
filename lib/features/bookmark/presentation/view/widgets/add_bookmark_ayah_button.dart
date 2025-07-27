import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/features/bookmark/data/request/bookmark_ayah_request.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran/read_quran_bloc.dart';

class AddBookmarkAyahButton extends StatefulWidget {
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
  State<AddBookmarkAyahButton> createState() => _AddBookmarkAyahButtonState();
}

class _AddBookmarkAyahButtonState extends State<AddBookmarkAyahButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkBloc, BookmarkState>(
      builder: (context, state) {
        final hasBookmark = context
            .read<BookmarkBloc>()
            .hasBookmarkAyah(widget.surahNum, widget.ayahNum);
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
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: Icon(
                      hasBookmark ? Icons.bookmark_added : Icons.bookmark_add,
                      key: ValueKey<bool>(hasBookmark),
                      size: 30,
                      color: context.primaryColor,
                    ),
                  ),
                ),
              ),
              onTap: () async {
                // Play haptic feedback
                HapticFeedback.mediumImpact();

                // Animate the scale
                _controller.forward().then((_) => _controller.reverse());

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
    final hasBookmark =
        bookmarkBloc.hasBookmarkAyah(widget.surahNum, widget.ayahNum);
    if (hasBookmark) {
      final bookmarkId =
          bookmarkBloc.getBookmarkAyahId(widget.surahNum, widget.ayahNum);
      bookmarkBloc.add(
        DeleteBookmarkAyahEvent(
          BookmarkAyahRequest(
            ayahNumber: widget.ayahNum,
            surahNumber: widget.surahNum,
            id: bookmarkId,
          ),
        ),
      );
    } else {
      final bookmarksAyahs = BookmarkAyahRequest(
        ayahNumber: widget.ayahNum,
        surahNumber: widget.surahNum,
        ayahUQNumber: widget.ayahUQNum,
        pageNumber: widget.pageIndex,
        surahName: widget.surahName,
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
