import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/components/my_text_form_field.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/read_quran/surah_name_with_banner.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/old_read_quran/old_read_quran_bloc.dart';
import 'package:quran_app/features/search/presentation/bloc/search_bloc.dart';

class SearchAyahWidget extends StatefulWidget {
  const SearchAyahWidget({
    super.key,
  });

  @override
  State<SearchAyahWidget> createState() => _SearchAyahWidgetState();
}

class _SearchAyahWidgetState extends State<SearchAyahWidget> {
  final searchTextEditing = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: context.getHight(80),
        child: Column(
          children: [
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                return MyTextFormFieldWidget(
                  hintStyle: TextStyle(
                    color: context.primaryScheme,
                    fontSize: 14,
                  ),
                  hintText: 'ادخل اسم الايه',
                  style: TextStyle(
                    color: context.quranTheme.cardColor,
                  ),
                  onChanged: (text) {
                    BlocProvider.of<SearchBloc>(context)
                        .add(SearchQuranEvent(text));
                  },
                );
              },
            ),
            BlocBuilder<SearchBloc, SearchState>(
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

                    return Expanded(
                      child: ListView.builder(
                        itemCount: ayahList.length,
                        controller: BlocProvider.of<SearchBloc>(context)
                            .scrollController,
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
                                    context.pop();
                                  },
                                  title: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      search.searchText,
                                      style: TextStyle(
                                        fontFamily: 'uthmanic2',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 22,
                                        color: context.quranTheme.hintColor,
                                      ),
                                    ),
                                    // child: RichText(
                                    //   text: TextSpan(
                                    //     children: highlightLine(
                                    //         search.searchText,
                                    //         searchTextEditing.text),
                                    // style: TextStyle(
                                    //   fontFamily: "uthmanic2",
                                    //   fontWeight: FontWeight.normal,
                                    //   fontSize: 22,
                                    //   color: currentThemeData.hintColor,
                                    // ),
                                    //   ),
                                    //   textAlign: TextAlign.justify,
                                    // ),
                                  ),
                                  subtitle: Container(
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color:
                                          context.quranTheme.primaryColorLight,
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
                                                  ? context.quranTheme
                                                      .colorScheme.primary
                                                      .withOpacity(.15)
                                                  : Colors.transparent),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topRight: Radius.circular(4),
                                                bottomRight: Radius.circular(4),
                                              ),
                                            ),
                                            child: Text(
                                              " ${'الجزء'}: ${search.partNum}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: context
                                                    .quranTheme.canvasColor,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: context
                                                  .quranTheme.primaryColor,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(4),
                                                bottomLeft: Radius.circular(4),
                                              ),
                                            ),
                                            child: Text(
                                              " ${'الصفحه'}: ${search.pageNum}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: context
                                                    .quranTheme.canvasColor,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: context
                                                  .quranTheme.primaryColor,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(4),
                                                bottomLeft: Radius.circular(4),
                                              ),
                                            ),
                                            child: Text(
                                              " ${'الايه'}: ${search.ayaNum}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: context
                                                    .quranTheme.canvasColor,
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
                      ),
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
