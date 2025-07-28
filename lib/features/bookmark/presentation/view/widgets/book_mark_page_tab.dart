import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/components/quran_widgets/enhanced_spiritual_loading_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/bookmark/data/model/bookmark_page_model.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran/read_quran_bloc.dart';

class BookmarkPageTab extends StatefulWidget {
  const BookmarkPageTab({super.key});

  @override
  State<BookmarkPageTab> createState() => _BookmarkPageTabState();
}

class _BookmarkPageTabState extends State<BookmarkPageTab> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounceTimer;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _searchQuery = _searchController.text.toLowerCase().trim();
        });
      }
    });
  }

  List<BookmarkPageModel> _filterBookmarks(List<BookmarkPageModel> bookmarks) {
    if (_searchQuery.isEmpty) {
      return bookmarks;
    }

    return bookmarks.where((bookmark) {
      final sorahName = bookmark.sorahName?.toLowerCase() ?? '';
      final lastRead = bookmark.lastRead?.toLowerCase() ?? '';
      final pageNum = bookmark.pageNum?.toString() ?? '';

      return sorahName.contains(_searchQuery) ||
          lastRead.contains(_searchQuery) ||
          pageNum.contains(_searchQuery);
    }).toList();
  }

  Widget _buildSearchField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: context.quranTheme.colorScheme.surface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: context.quranTheme.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: 'البحث في الصفحات المحفوظة...',
          // hintStyle: context.titleMedium?.copyWith(
          //   color: context.primaryColor.withValues(alpha: 0.6),
          //   fontSize: 14.sp,
          // ),
          prefixIcon: Icon(
            Icons.search,
            color:
                context.quranTheme.colorScheme.primary.withValues(alpha: 0.7),
            size: 20.sp,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: context.quranTheme.colorScheme.primary
                        .withValues(alpha: 0.7),
                    size: 20.sp,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    _searchFocusNode.unfocus();
                  },
                )
              : null,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 12.h,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkBloc, BookmarkState>(
      builder: (context, state) {
        final bookmarksList = state.pageBookmarksList;
        final filteredBookmarks = _filterBookmarks(bookmarksList);

        if (bookmarksList.isEmpty) {
          return Center(
            child: Column(
              children: [
                const EnhancedSpiritualLoadingWidget(
                  showText: false,
                  size: 250,
                  // showParticles: false,
                ),
                SizedBox(height: 16.h),
                Center(
                  child: Text(
                    'لا يوجد صفحات محفوظة',
                    style: context.titleMedium?.copyWith(
                      color: context.gray1,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: context.scaffoldBackgroundColor,
          ),
          child: Column(
            children: [
              _buildSearchField(),
              if (filteredBookmarks.isEmpty && _searchQuery.isNotEmpty)
                Center(
                  child: Text(
                    'لا توجد نتائج للبحث عن "$_searchQuery"',
                    style: context.titleMedium?.copyWith(
                      color: context.gray1,
                      fontSize: 16.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: filteredBookmarks.length,
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (_, index) {
                    final surah = filteredBookmarks[index];
                    final originalIndex = bookmarksList.indexOf(surah);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: (originalIndex % 2 == 0
                                      ? context.quranTheme.colorScheme.primary
                                          .withOpacity(.15)
                                      : Colors.transparent),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              SizedBox(
                                                height: 40,
                                                width: 40,
                                                child: SvgPicture.asset(
                                                  'assets/svg/sora_num.svg',
                                                  color: context.quranTheme
                                                      .colorScheme.primary,
                                                ),
                                              ),
                                              Transform.translate(
                                                offset: const Offset(0, 1),
                                                child: Text(
                                                  (originalIndex + 1)
                                                      .toString(),
                                                  // convertNumbers(
                                                  //     surah.surahNumber.toString()),
                                                  style: context.titleMedium
                                                      ?.copyWith(
                                                    color: context.primaryColor,
                                                    fontFamily: 'kufi',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    height: 2,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              surah.sorahName ?? '',
                                              style:
                                                  context.titleMedium?.copyWith(
                                                fontSize: 16,
                                                color: context.primaryColor,
                                              ),
                                            ),
                                            Text(
                                              surah.lastRead ?? '',
                                              style:
                                                  context.titleMedium?.copyWith(
                                                color: context.primaryColor,
                                                fontSize: 12,
                                              ),
                                            ),
                                            // SvgPicture.asset(
                                            //   'assets/svg/surah_name/00${surah.pageNum}.svg',
                                            //   width: 90,
                                            //   color: Colors.white,
                                            // ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'رقم الصفحة',
                                                    style: context.titleMedium
                                                        ?.copyWith(
                                                      // fontFamily: 'uthman',
                                                      fontSize: 13,
                                                      color:
                                                          context.primaryColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    surah.pageNum.toString(),
                                                    style: context.titleMedium
                                                        ?.copyWith(
                                                      // fontFamily: 'kufi',
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          context.primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                context.read<ReadQuranBloc>().add(
                                      JumpToPageEvent(
                                        page: surah.pageNum! - 1,
                                      ),
                                    );
                                context.pop();
                                // context.pop();
                                // quranCtrl.changeSurahListOnTap(surah.ayahs.first.page);
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

Widget hDivider({double? width, double? height, Color? color}) {
  return Container(
    height: height ?? 2,
    width: width ?? double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    color: color,
  );
}
