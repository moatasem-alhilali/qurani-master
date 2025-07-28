import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/components/quran_widgets/enhanced_spiritual_loading_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/bookmark/data/model/bookmark_ayah.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:quran_app/features/bookmark/presentation/view/widgets/book_mark_page_tab.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran/read_quran_bloc.dart';

class BookmarkAyahTab extends StatefulWidget {
  const BookmarkAyahTab({super.key});

  @override
  State<BookmarkAyahTab> createState() => _BookmarkAyahTabState();
}

class _BookmarkAyahTabState extends State<BookmarkAyahTab> {
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

  List<BookmarkAyahModel> _filterBookmarks(List<BookmarkAyahModel> bookmarks) {
    if (_searchQuery.isEmpty) {
      return bookmarks;
    }

    return bookmarks.where((bookmark) {
      final surahName = bookmark.surahName?.toLowerCase() ?? '';
      final lastRead = bookmark.lastRead?.toLowerCase() ?? '';
      final ayahNumber = bookmark.ayahNumber?.toString() ?? '';
      final pageNumber = bookmark.pageNumber?.toString() ?? '';

      return surahName.contains(_searchQuery) ||
          lastRead.contains(_searchQuery) ||
          ayahNumber.contains(_searchQuery) ||
          pageNumber.contains(_searchQuery);
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
          hintText: 'البحث في الآيات المحفوظة...',
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
    return BlocBuilder<ReadQuranBloc, ReadQuranState>(
      builder: (context, readQuranState) {
        return BlocBuilder<BookmarkBloc, BookmarkState>(
          builder: (context, state) {
            final ayahBookmarkList = state.ayahBookmarkList;
            final filteredBookmarks = _filterBookmarks(ayahBookmarkList);

            if (ayahBookmarkList.isEmpty) {
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
                        'لا يوجد آيات محفوظة',
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
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filteredBookmarks.length,
                      shrinkWrap: true,
                      // controller: sl<GeneralController>().surahListController,
                      itemBuilder: (_, index) {
                        final bookmark = filteredBookmarks[index];
                        final originalIndex =
                            ayahBookmarkList.indexOf(bookmark);
                        // log('ayahNumber: ${bookmark.ayahNumber} surahNum: ${bookmark.surahNumber}');
                        final ayah = readQuranState.allAyahs.firstWhere(
                          (a) => a.numberGlobal == bookmark.ayahUQNumber,
                        );
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return const LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.black,
                                          ],
                                          stops: [0.0, 0.2],
                                        ).createShader(bounds);
                                      },
                                      blendMode: BlendMode.dstIn,
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
                                                      color:
                                                          context.primaryColor,
                                                    ),
                                                  ),
                                                  Transform.translate(
                                                    offset: const Offset(0, 1),
                                                    child: Text(
                                                      convertNumbers(
                                                        (originalIndex + 1)
                                                            .toString(),
                                                      ),
                                                      style: context.titleMedium
                                                          ?.copyWith(
                                                        color: context
                                                            .primaryColor
                                                            .withOpacity(.7),
                                                        fontFamily: 'kufi',
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                  ayah.text,
                                                  style: context.titleMedium
                                                      ?.copyWith(
                                                    color: context.primaryColor
                                                        .withOpacity(.7),
                                                    fontFamily: 'uthmanic2',
                                                    fontSize: 20,
                                                    height: 2,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow
                                                      .clip, // Change overflow to clip
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    right: 8,
                                                  ),
                                                  child: Text(
                                                    '${bookmark.lastRead} :  ${'الايه'}  ${convertNumbers(bookmark.ayahNumber.toString())}  -  ${'الصفحه'} ${bookmark.pageNumber! + 1}',
                                                    style: context.titleMedium
                                                        ?.copyWith(
                                                      fontFamily: 'naskh',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12,
                                                      color:
                                                          context.primaryColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                context.read<ReadQuranBloc>().add(
                                      JumpToPageEvent(page: ayah.page! - 1),
                                    );
                                context.pop();
                              },
                            ),
                            hDivider(
                              color: context.primaryColor.withOpacity(0.2),
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
      },
    );
  }
}
