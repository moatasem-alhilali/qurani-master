import 'package:flutter/material.dart';
import 'package:quran_app/features/quran/presentation/model/surah_model.dart';
import 'package:quran_app/core/util/search_bar_state.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/quran/presentation/page/quran_pdf/widgets/item_surah.dart';

class SearchBar extends SearchDelegate {
  SearchBar({
    required this.hint,
    required this.searchBarState,
  });
  final String hint;
  SearchBarState searchBarState;
  @override
  String get searchFieldLabel => hint;
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Theme.of(context).primaryColor,
        helperStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontFamily: 'ios-1',
        ),
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontFamily: 'ios-1',
        ),
        border: const UnderlineInputBorder(borderSide: BorderSide.none),
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontFamily: 'ios-1',
        ),
      ),
      scaffoldBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.green),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? surahData
        : surahData.where(
            (p) {
              return p.titleAr!.contains(query);
            },
          ).toList();
    return Container(
      padding: const EdgeInsets.only(
        top: 10,
        right: 10,
        left: 10,
      ),
      child: ListView.builder(
        itemCount: suggestionList.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, index) {
          var data = surahData[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: InkWell(
              onTap: () async {
                switch (searchBarState) {
                  case SearchBarState.isDowland:
                  
                    break;
                  case SearchBarState.isSurah:
                    goTo(
                        context: context,
                        index: index,
                        surahData: suggestionList);
                    break;
                  case SearchBarState.isAudioSurah:
                    break;
                }
              },
              child: _SearchBarItem(
                suggestionList: suggestionList,
                index: index,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SearchBarItem extends StatelessWidget {
  const _SearchBarItem(
      {Key? key, required this.suggestionList, required this.index})
      : super(key: key);

  final List<SurahModel> suggestionList;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            surahData[index].place == 'Medina' ? 'مدنية' : 'مكية',
            style: titleSmall(context),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                suggestionList[index].titleAr!,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white),
              ),
              Text(
                textAlign: TextAlign.right,
                'عدد الايات: ${suggestionList[index].count}',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
