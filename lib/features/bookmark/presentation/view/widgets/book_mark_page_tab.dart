import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/components/quran_widgets/enhanced_spiritual_loading_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';

class BookmarkPageTab extends StatelessWidget {
  const BookmarkPageTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkBloc, BookmarkState>(
      builder: (context, state) {
        final bookmarksList = state.pageBookmarksList;
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
                    style: context.titleMedium.copyWith(
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
                                ? context.quranTheme.colorScheme.primary
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
                                            color: context
                                                .quranTheme.colorScheme.primary,
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: const Offset(0, 1),
                                          child: Text(
                                            (index + 1).toString(),
                                            // convertNumbers(
                                            //     surah.surahNumber.toString()),
                                            style: TextStyle(
                                              color: context.primaryScheme,
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
                                        surah.sorahName ?? '',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: context.primaryScheme,
                                        ),
                                      ),
                                      Text(
                                        surah.lastRead ?? '',
                                        style: TextStyle(
                                          color: context.primaryScheme,
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
                                                fontFamily: 'uthman',
                                                fontSize: 13,
                                                color: context.quranTheme
                                                    .colorScheme.surface,
                                              ),
                                            ),
                                            Text(
                                              surah.pageNum.toString(),
                                              style: TextStyle(
                                                fontFamily: 'kufi',
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: context.quranTheme
                                                    .colorScheme.surface,
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
                        color: context.quranTheme.colorScheme.primary
                            .withOpacity(0.2),
                      ),
                    ],
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

Widget hDivider({double? width, double? height, Color? color}) {
  return Container(
    height: height ?? 2,
    width: width ?? double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    color: color,
  );
}
