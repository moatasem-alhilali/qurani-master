import 'package:flutter/material.dart';
import 'package:quran_app/core/components/custom_search_delegate.dart';
import 'package:quran_app/core/components/float_button.dart';
import 'package:quran_app/core/function/function_navigate.dart';
import 'package:quran_app/core/util/search_bar_state.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';

class ActionsIcon extends StatelessWidget {
  const ActionsIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 5),
          FloatButton(
            herotag: "btn5",
            icon: Icons.bookmark,
            text: 'العلامة',
            onPressed: () {
              FunctionNavigate.goToPdfRead(context: context);
              fabIsClicked = true;
            },
          ),
          const SizedBox(width: 5),
          FloatButton(
            herotag: "btn4",
            icon: Icons.search,
            text: 'البحث على سورة',
            onPressed: () async {
              showSearch(
                context: context,
                delegate: SearchBar(
                  hint: 'اسم السورة',
                  searchBarState: SearchBarState.isSurah,
                ),
              );
            },
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }
}
