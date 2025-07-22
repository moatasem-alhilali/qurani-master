import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/util/text_highlighting_util.dart';
import 'package:quran_app/core/widgets/read_quran/surah_name_with_banner.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/old_read_quran/old_read_quran_bloc.dart';
import 'package:quran_app/features/search/presentation/bloc/search_bloc.dart';

class SearchAyahListWidget extends StatefulWidget {
  const SearchAyahListWidget({
    super.key,
  });

  @override
  State<SearchAyahListWidget> createState() => _SearchAyahListWidgetState();
}

class _SearchAyahListWidgetState extends State<SearchAyahListWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        switch (state.ayahState) {
          case RequestState.initial:
            return SizedBox(
              height: context.getHight(50),
              child: Center(
                child: Text(
                  'قم بالبحث عن الايه',
                  style: titleLarge(context),
                ),
              ),
            );

          case RequestState.loading:
            return const SizedBox();

          case RequestState.error:
            return const SizedBox();
          case RequestState.success:
            final ayahList = state.ayaData;

            if (ayahList.isEmpty) {
              return Center(
                child: Text(
                  'لا يوجد نتائج',
                  style: titleMedium(context),
                ),
              );
            }

            return ListView.builder(
              itemCount: ayahList.length,
              controller: context.read<SearchBloc>().scrollController,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final search = ayahList[index];

                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        // vertical: 12.sp,
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        // tileColor: context.background,
                        onTap: () {
                          context.read<OldReadQuranBloc>().add(
                                OldJumpToPageEvent(
                                  page: (search.pageNum as int) - 1,
                                ),
                              );
                          // context.pop();
                        },
                        title: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextHighlightingUtil.createHighlightedText(
                            search.searchText,
                            state.currentSearchTerm,
                            defaultStyle: TextStyle(
                              fontFamily: 'uthmanic2',
                              fontWeight: FontWeight.normal,
                              fontSize: 22,
                              color: context.quranTheme.hintColor,
                            ),
                            highlightStyle: TextStyle(
                              fontFamily: 'uthmanic2',
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.red,
                              backgroundColor: Colors.yellow.withOpacity(0.3),
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        subtitle: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: context.quranTheme.primaryColorLight,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: (index % 2 == 0
                                        ? context.quranTheme.colorScheme.primary
                                            .withOpacity(.15)
                                        : Colors.transparent),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(4),
                                      bottomRight: Radius.circular(4),
                                    ),
                                  ),
                                  child: Text(
                                    " ${'الجزء'}: ${search.partNum}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: context.quranTheme.canvasColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: context.quranTheme.primaryColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      bottomLeft: Radius.circular(4),
                                    ),
                                  ),
                                  child: Text(
                                    " ${'الصفحه'}: ${search.pageNum}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: context.quranTheme.canvasColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: context.quranTheme.primaryColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      bottomLeft: Radius.circular(4),
                                    ),
                                  ),
                                  child: Text(
                                    " ${'الايه'}: ${search.ayaNum}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: context.quranTheme.canvasColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        leading: context.surahNameWidget(
                          search.surahNum.toString(),
                          context.quranTheme.hintColor!,
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            );
        }
      },
    );
  }
}
