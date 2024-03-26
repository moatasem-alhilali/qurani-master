import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran_app/core/theme/app_themes.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';

class BookmarkPageTab extends StatelessWidget {
  const BookmarkPageTab({super.key});

  @override
  Widget build(BuildContext context) {
    final bookmarksList =
        context.read<BookmarkBloc>().bookmarksController.bookmarksList;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: currentThemeData.colorScheme.background,
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: bookmarksList.length,
        itemBuilder: (_, index) {
          final surah = bookmarksList[index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  GestureDetector(
                    child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: (index % 2 == 0
                              ? currentThemeData.colorScheme.primary
                                  .withOpacity(.15)
                              : Colors.transparent),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
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
                                          color: currentThemeData
                                              .colorScheme.primary,
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: const Offset(0, 1),
                                        child: Text(
                                          (index + 1).toString(),
                                          // convertNumbers(
                                          //     surah.surahNumber.toString()),
                                          style: TextStyle(
                                              color:
                                                  currentThemeData.hintColor,
                                              fontFamily: "kufi",
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              height: 2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      surah.sorahName ?? "",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: currentThemeData.hintColor,
                                      ),
                                    ),
                                    Text(
                                      surah.lastRead ?? "",
                                      style: TextStyle(
                                        color: currentThemeData.hintColor,
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
                                            style: TextStyle(
                                              fontFamily: "uthman",
                                              fontSize: 13,
                                              color: currentThemeData
                                                  .colorScheme.surface,
                                            ),
                                          ),
                                          Text(
                                            surah.pageNum.toString(),
                                            style: TextStyle(
                                              fontFamily: "kufi",
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: currentThemeData
                                                  .colorScheme.surface,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                    onTap: () {
                      context
                          .read<ReadQuranBloc>()
                          .pageController
                          .jumpToPage(surah.pageNum! - 1);
                       context.pop();
                  context.pop();
                      // quranCtrl.changeSurahListOnTap(surah.ayahs.first.page);
                    },
                  ),
                  hDivider(
                      color: currentThemeData.colorScheme.primary
                          .withOpacity(0.2)),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget hDivider({double? width, double? height, Color? color}) {
  return Container(
    height: height ?? 2,
    width: width ?? double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
    color: color,
  );
}
