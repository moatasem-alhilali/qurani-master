import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran/read_quran_bloc.dart';

class QuranSurahList extends StatefulWidget {
  const QuranSurahList({super.key});

  @override
  State<QuranSurahList> createState() => _QuranSurahListState();
}

class _QuranSurahListState extends State<QuranSurahList> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadQuranBloc, ReadQuranState>(
      builder: (context, readQuranState) {
        // Filter surahs based on search query
        final filteredSurahs = readQuranState.surahs.where((surah) {
          if (_searchQuery.isEmpty) return true;

          final query = _searchQuery.toLowerCase();
          final englishName = surah.nameEn!.toLowerCase();
          final surahNumber = surah.surahNumber.toString();
          final arabicNumber = convertNumbers(surahNumber);

          return englishName.contains(query) ||
              surahNumber.contains(query) ||
              arabicNumber.contains(query);
        }).toList();
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              // Search field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'البحث عن سورة...',

                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).hintColor,
                      size: 20.sp,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Theme.of(context).hintColor,
                              size: 20.sp,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    // border: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(8),
                    //   borderSide: BorderSide(
                    //     color: context.quranTheme.colorScheme.primary
                    //         .withOpacity(0.3),
                    //   ),
                    // ),
                    // enabledBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(8),
                    //   borderSide: BorderSide(
                    //     color: context.quranTheme.colorScheme.primary
                    //         .withOpacity(0.3),
                    //   ),
                    // ),
                    // focusedBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(8),
                    //   borderSide: BorderSide(
                    //     color: context.quranTheme.colorScheme.primary,
                    //   ),
                    // ),
                    // contentPadding: const EdgeInsets.symmetric(
                    //   horizontal: 12,
                    //   vertical: 12,
                    // ),
                    // filled: false,
                    // // fillColor: context.quranTheme.colorScheme.surface,
                  ),
                  // style: TextStyle(
                  //   fontSize: 14.sp,
                  //   color: context.primaryColor,
                  // ),
                  // textAlign: TextAlign.right,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              // Existing ListView
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredSurahs.length,
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    final surah = filteredSurahs[index];
                    final originalIndex = readQuranState.surahs.indexOf(surah);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '${'الجزء'} ${surah.ayahCount}',
                              style: context.titleMedium?.copyWith(
                                // color: context.quranTheme.colorScheme.primary,
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
                                                    color: context.primaryColor,
                                                  ),
                                                ),
                                                Transform.translate(
                                                  offset: const Offset(0, 1),
                                                  child: Text(
                                                    convertNumbers(
                                                      surah.surahNumber
                                                          .toString(),
                                                    ),
                                                    style: context.titleMedium
                                                        ?.copyWith(
                                                      color:
                                                          context.primaryColor,
                                                      fontFamily: 'kufi',
                                                      fontSize: 14.sp,
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
                                              SvgPicture.asset(
                                                'assets/svg/surah_name/00${originalIndex + 1}.svg',
                                                width: 90,
                                                color: context.primaryColor,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 8,
                                                ),
                                                child: Text(
                                                  surah.nameEn!,
                                                  style: context.titleMedium
                                                      ?.copyWith(
                                                    // fontFamily: 'naskh',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12.sp,
                                                    color: context.primaryColor,
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
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'عدد الايات',
                                                      style: context.titleMedium
                                                          ?.copyWith(
                                                        // fontFamily: 'uthman',
                                                        fontSize: 13.sp,
                                                        color: context
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      convertNumbers(
                                                        surah.ayahCount
                                                            .toString(),
                                                      ),
                                                      style: context.titleMedium
                                                          ?.copyWith(
                                                        // fontFamily: 'kufi',
                                                        fontSize: 13.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: context
                                                            .primaryColor,
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
                                  final ayahs = readQuranState
                                      .getAyahsBySurahNumber(surah.surahNumber);
                                  final page = ayahs.first.page! - 1;
                                  context
                                      .read<ReadQuranBloc>()
                                      .add(JumpToPageEvent(page: page));
                                  context.pop();
                                  // final page = surah.surahNumber;
                                  // context
                                  //     .read<ReadQuranBloc>()
                                  //     .pageController
                                  //     .jumpToPage(
                                  //       page - 1,
                                  //     );
                                  // context.pop();
                                },
                              ),
                              hDivider(
                                color: context.primaryColor.withOpacity(0.2),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
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
