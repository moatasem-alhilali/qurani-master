import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:quran_app/features/bookmark/presentation/view/widgets/book_mark_page_tab.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';

class BookmarkAyahTab extends StatelessWidget {
  BookmarkAyahTab({super.key});
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkBloc, BookmarkState>(
      builder: (context, state) {
        final bookmarkTextList = state.ayahBookmarkList;
        final quranRH = context.read<ReadQuranBloc>().quranRH;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: context.quranTheme.colorScheme.background,
          ),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: bookmarkTextList.length,
            // controller: sl<GeneralController>().surahListController,
            itemBuilder: (_, index) {
              final bookmark = bookmarkTextList[index];
              final ayah = quranRH.allAyahs.firstWhere(
                (a) => a.ayahUQNumber == bookmark.ayahUQNumber,
              );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: (index % 2 == 0
                            ? context.quranTheme.colorScheme.primary
                                .withOpacity(.15)
                            : Colors.transparent),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                colors: [Colors.transparent, Colors.black],
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
                                            color: context
                                                .quranTheme.colorScheme.primary,
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: const Offset(0, 1),
                                          child: Text(
                                            convertNumbers(
                                              (index + 1).toString(),
                                            ),
                                            style: TextStyle(
                                              color:
                                                  context.quranTheme.hintColor,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        ayah.text,
                                        style: TextStyle(
                                          color: context.quranTheme.hintColor,
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
                                            const EdgeInsets.only(right: 8),
                                        child: Text(
                                          '${bookmarkTextList[index].lastRead} :  ${'الايه'}  ${convertNumbers(bookmarkTextList[index].ayahNumber.toString())}  -  ${'الصفحه'} ${bookmarkTextList[index].pageNumber! + 1}',
                                          style: TextStyle(
                                            fontFamily: 'naskh',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: context
                                                .quranTheme.colorScheme.surface,
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
                      context
                          .read<ReadQuranBloc>()
                          .pageController
                          .jumpToPage(ayah.page - 1);
                      context.pop();
                      context.pop();
                      // quranCtrl.changeSurahListOnTap(juz.page);
                    },
                  ),
                  hDivider(
                    color:
                        context.quranTheme.colorScheme.primary.withOpacity(0.2),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
