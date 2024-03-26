import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/my_text_form_field.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/theme/app_themes.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/read_quran/surah_name_with_banner.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';
import 'package:quran_app/features/search/data/model/aya.dart';
import 'package:quran_app/features/search/data/search_repository_imp.dart';
import 'package:quran_app/features/search/presentation/bloc/search_bloc.dart';

class SearchAyah extends StatelessWidget {
  SearchAyah({
    super.key,
  });

  final searchTextEditing = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: context.getHight(80),
        child: BlocProvider<SearchBloc>(
          create: (context) =>
              SearchBloc(repositoryImpl: sl.get<SearchRepositoryImpl>()),
          child: Column(
            children: [
              BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  return MyTextFormField(
                    hintStyle: TextStyle(
                      color: currentThemeData.colorScheme.surface,
                      fontSize: 14,
                    ),
                    hintText: 'ادخل اسم الايه',
                    style: TextStyle(
                      color: currentThemeData.cardColor,
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
                    case RequestState.defaults:
                      return const SizedBox();

                    case RequestState.loading:
                      return const SizedBox();

                    case RequestState.error:
                      return const SizedBox();
                    case RequestState.success:
                      final ayahList = state.ayaData;

                      return Expanded(
                        child: ListView.builder(
                          itemCount: ayahList.length,
                          controller: BlocProvider.of<SearchBloc>(context)
                              .scrollController,
                          itemBuilder: (context, index) {
                            Aya search = ayahList[index];

                            return Column(
                              children: <Widget>[
                                Container(
                                  color: (index % 2 == 0
                                      ? currentThemeData.colorScheme.surface
                                          .withOpacity(.05)
                                      : currentThemeData.colorScheme.surface
                                          .withOpacity(.1)),
                                  child: ListTile(
                                    onTap: () {
                                      context
                                          .read<ReadQuranBloc>()
                                          .pageController
                                          .jumpToPage(search.pageNum! - 1);
                                      context.pop();
                                      context.pop();
                                    },
                                    title: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        search.searchText,
                                        style: TextStyle(
                                          fontFamily: "uthmanic2",
                                          fontWeight: FontWeight.normal,
                                          fontSize: 22,
                                          color: currentThemeData.hintColor,
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
                                            currentThemeData.primaryColorLight,
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
                                                        ? currentThemeData
                                                            .colorScheme.primary
                                                            .withOpacity(.15)
                                                        : Colors.transparent),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(4),
                                                      bottomRight:
                                                          Radius.circular(4),
                                                    )),
                                                child: Text(
                                                  " ${'الجزء'}: ${search.partNum}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: currentThemeData
                                                        .canvasColor,
                                                    fontSize: 12,
                                                  ),
                                                )),
                                          ),
                                          Expanded(
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: currentThemeData
                                                        .primaryColor,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(4),
                                                      bottomLeft:
                                                          Radius.circular(4),
                                                    )),
                                                child: Text(
                                                  " ${'الصفحه'}: ${search.pageNum}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: currentThemeData
                                                          .canvasColor,
                                                      fontSize: 12),
                                                )),
                                          ),
                                          Expanded(
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: currentThemeData
                                                        .primaryColor,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(4),
                                                      bottomLeft:
                                                          Radius.circular(4),
                                                    )),
                                                child: Text(
                                                  " ${'الايه'}: ${search.ayaNum}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: currentThemeData
                                                          .canvasColor,
                                                      fontSize: 12),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    leading: context.surahNameWidget(
                                      search.surahNum.toString(),
                                      currentThemeData.hintColor!,
                                    ),
                                  ),
                                ),
                                const Divider()
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
      ),
    );
  }
}
