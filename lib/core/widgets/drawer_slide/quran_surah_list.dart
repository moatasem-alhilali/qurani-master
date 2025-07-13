import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';

class QuranSurahList extends StatelessWidget {
  const QuranSurahList({super.key});

  @override
  Widget build(BuildContext context) {
    final quranCtrl = context.read<ReadQuranBloc>().quranRH;
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: quranCtrl.surahs.length,
      shrinkWrap: true,
      itemBuilder: (_, index) {
        final surah = quranCtrl.surahs[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '${'الجزء'} ${surah.ayahs.first.juz}',
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontFamily: 'kufi',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  height: 2,
                ),
              ),
            ),
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
                                      convertNumbers(
                                        surah.surahNumber.toString(),
                                      ),
                                      style: TextStyle(
                                        color: context.quranTheme.hintColor,
                                        fontFamily: 'kufi',
                                        fontSize: 14.sp,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/surah_name/00${index + 1}.svg',
                                  width: 90,
                                  color: context.quranTheme.hintColor,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(
                                    surah.englishName,
                                    style: TextStyle(
                                      // fontFamily: 'naskh',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp,
                                      color: context.primaryScheme,
                                    ),
                                  ),
                                ),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'عدد الايات',
                                        style: TextStyle(
                                          // fontFamily: 'uthman',
                                          fontSize: 13.sp,
                                          color: context.primaryScheme,
                                        ),
                                      ),
                                      Text(
                                        convertNumbers(
                                          surah.ayahs.last.ayahNumber
                                              .toString(),
                                        ),
                                        style: TextStyle(
                                          // fontFamily: 'kufi',
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.bold,
                                          color: context.primaryScheme,
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
                    final page = surah.ayahs.first.page - 1;
                    context
                        .read<ReadQuranBloc>()
                        .add(JumpToPageEvent(page: page));
                    context.pop();
                  },
                ),
                hDivider(
                  color:
                      context.quranTheme.colorScheme.primary.withOpacity(0.2),
                ),
              ],
            ),
          ],
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
