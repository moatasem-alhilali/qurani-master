import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_item_book.dart';
import 'package:quran_app/core/components/my_text_form_field.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/auto_text.dart';
import 'package:quran_app/core/widgets/ui_screen.dart';
import 'package:quran_app/features/categories/data/category_repository_imp.dart';
import 'package:quran_app/features/categories/presentation/bloc/category_bloc.dart';
import 'package:quran_app/features/categories/presentation/view/widgets/quran_sheet.dart';
import 'package:quran_app/features/categories/presentation/view/widgets/sheet_audio.dart';

class CategoryTypeDetail extends StatelessWidget {
  CategoryTypeDetail({super.key, this.data});
  final dynamic data;
  TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BaseUiScreen(
      title: data['title'].toString().autoSize(context),
      child: BlocProvider(
        create: (context) => CategoryBloc(
          repositoryImpl: sl.get<CategoryRepositoryImpl>(),
        )..add(GetQuranBookEvent(data['api_url'])),
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            switch (state.quranBooksState) {
              case RequestState.defaults:
                return const Center(child: CircularProgressIndicator());
              case RequestState.loading:
                return const Center(child: CircularProgressIndicator());

              case RequestState.error:
                return const Center(
                    child: CircularProgressIndicator(color: Colors.red));

              case RequestState.success:
                var allData = state.quranBooksDetailSearch;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyTextFormField(
                      controller: search,
                      hintText: "بحث",
                      suffixIcon: search.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                search.clear();
                              },
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ).animate().fade()
                          : null,
                      onChanged: (text) {
                        _onSearchTextChanged(allData);
                        context.read<CategoryBloc>().add(SetStateEvent());
                      },
                    ),
                    Expanded(
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _onSearchTextChanged(allData).length,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1 / 1.5,
                        ),
                        itemBuilder: (context, index) {
                          var data = _onSearchTextChanged(allData)[index];
                          return BaseBookItem(
                            data['title'],
                            () {
                              data['apiurl'] = data['api_url'];
                              if (data['type'] == 'audios') {
                                context.showBottomSheet(
                                  child: SheetAudios(baseData: data),
                                );
                                return;
                              } else {
                                context.showBottomSheet(
                                  child: QuranBooksDetail(data: data),
                                );
                              }
                            },
                            type: data['type'],
                          );
                          //  _Item(allData);
                        },
                      ),
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }

  List<dynamic> _onSearchTextChanged(List data) {
    final res = data
        .where((data) => data['title']
            .toString()
            .toLowerCase()
            .contains(search.text.toLowerCase()))
        .toList();
    return res;
  }
}

class _ItemDownloaded extends StatelessWidget {
  _ItemDownloaded({Key? key}) : super(key: key);

  dynamic data;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      // height: context.getHight(8),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (data['description'] != null)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: data['description']
                      .toString()
                      .autoSize(context, maxLines: 5),
                ),
                const SizedBox(height: 10),
                const Divider(),
              ],
            ),
        ],
      ),
    );
  }
}
