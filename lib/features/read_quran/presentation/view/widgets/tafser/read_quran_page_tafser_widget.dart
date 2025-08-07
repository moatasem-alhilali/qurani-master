import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/widgets/read_quran/besm_allah_widget.dart';
import 'package:quran_app/core/widgets/read_quran/surah_name_with_banner.dart';
import 'package:quran_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:quran_app/features/read_quran/data/QuranReadHelperSqlite.dart';
import 'package:quran_app/features/read_quran/data/model/new_surah_model.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran/read_quran_bloc.dart';
import 'package:quran_app/gen/fonts.gen.dart';
import 'package:quran_app/main.dart';

class ReadQuranPageTafserWidget extends StatefulWidget {
  const ReadQuranPageTafserWidget({required this.pageIndex, super.key});
  final int pageIndex;

  @override
  State<ReadQuranPageTafserWidget> createState() =>
      _ReadQuranPageTafserWidgetState();
}

class _ReadQuranPageTafserWidgetState extends State<ReadQuranPageTafserWidget> {
  int? selectedAyahUQNumber;

  List<List<NewAyahModel>>? _cachedAyahsData;
  int? _cachedDataVersion;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkBloc, BookmarkState>(
      builder: (context, _) {
        return BlocBuilder<ReadQuranBloc, ReadQuranState>(
          builder: (context, state) {
            if (state.loadQuranState == RequestState.loading) {
              return const SizedBox();
            }
            if (state.loadQuranState == RequestState.error) {
              return const SizedBox();
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                final currentPageAyahsSeparatedForBasmalah =
                    _getCachedAyahsData(state);
                return RepaintBoundary(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    margin: const EdgeInsets.symmetric(vertical: 32),
                    child: state.pages.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              currentPageAyahsSeparatedForBasmalah.length,
                              (i) {
                                final ayahs =
                                    currentPageAyahsSeparatedForBasmalah[i];
                                return Column(
                                  children: [
                                    const RepaintBoundary(
                                      child: SizedBox.shrink(),
                                    ),
                                    RepaintBoundary(
                                      child: SurahBannerFirstPlace(
                                        pageIndex: widget.pageIndex,
                                        i: i,
                                      ),
                                    ),
                                    RepaintBoundary(
                                      child: _buildBasmalahIfNeeded(
                                        state,
                                        ayahs,
                                        context,
                                        widget.pageIndex,
                                      ),
                                    ),
                                    RepaintBoundary(
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.7,
                                        child: SingleChildScrollView(
                                          // scrollDirection: Axis.horizontal,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: ayahs.map((ayah) {
                                              return CardWidget(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 5,
                                                  vertical: 5,
                                                ),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6.r),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      '${ayah.text} ﴿${ayah.ayahNumber}﴾ ',
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      style: TextStyle(
                                                        fontFamily: FontFamily
                                                            .amiriQuran,
                                                        fontSize: 18.sp,
                                                        height: 1.6,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        vertical: 8.sp,
                                                      ),
                                                      child: const Divider(),
                                                    ),
                                                    Text(
                                                      ayah.tafsir ?? '',
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      style: TextStyle(
                                                        fontFamily: FontFamily
                                                            .scheherazade,
                                                        fontSize: 12.sp,
                                                        height: 1.6,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    RepaintBoundary(
                                      child: SurahBannerLastPlace(
                                        pageIndex: widget.pageIndex,
                                        i: i,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  List<List<NewAyahModel>> _getCachedAyahsData(ReadQuranState state) {
    final currentDataVersion = state.pages.length;
    if (_cachedAyahsData == null || _cachedDataVersion != currentDataVersion) {
      _cachedDataVersion = currentDataVersion;
      _cachedAyahsData = state.getCurrentPageAyahsSeparatedForBasmalah(
        widget.pageIndex,
      );
    }
    return _cachedAyahsData!;
  }

  Widget _buildBasmalahIfNeeded(
    ReadQuranState state,
    List<NewAyahModel> ayahs,
    BuildContext context,
    int pageIndex,
  ) {
    final surahNumber = state.getSurahNumberFromPage(pageIndex);
    final isFirstAyah = ayahs.first.ayahNumber == 1;
    final isExcludedSurah = surahNumber == 9 || surahNumber == 1;

    if (isExcludedSurah || !isFirstAyah) return const SizedBox.shrink();

    return const Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: BesmAllahWidget(), // سيبدّل داخليًا حسب السورة لو عندك منطق
    );
  }
}
