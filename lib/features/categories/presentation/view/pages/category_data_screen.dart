import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_item_book.dart';
import 'package:quran_app/core/components/my_text_form_field.dart';
import 'package:quran_app/core/components/shimmer_base.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/auto_text.dart';
import 'package:quran_app/core/widgets/ui_screen.dart';
import 'package:quran_app/features/audios/presentation/view/pages/base_audio_deatil.dart';
import 'package:quran_app/features/categories/data/category_repository_imp.dart';
import 'package:quran_app/features/categories/presentation/bloc/category_bloc.dart';
import 'package:quran_app/features/categories/presentation/view/widgets/quran_sheet.dart';
import 'package:quran_app/main.dart';

class CategoryDataScreen extends StatelessWidget {
  CategoryDataScreen({
    super.key,
    required this.id,
    required this.title,
    required this.url,
  });
  final int id;
  final String url;
  final String title;
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryBloc(
        repositoryImpl: sl.get<CategoryRepositoryImpl>(),
      )..add(GetCategoryEvent(id, url)),
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          return BaseUiScreen(
            title: title.autoSize(context),
            child: BlocConsumer<CategoryBloc, CategoryState>(
              listener: (context, state) {},
              builder: (context, state) {
                switch (state.categoryState) {
                  case RequestState.defaults:
                    return const SizedBox();
                  case RequestState.loading:
                    return const CircularProgressIndicator();
                  case RequestState.error:
                    return const SizedBox();
                  case RequestState.success:
                    return Column(
                      children: [
                        MyTextFormField(
                          controller: search,
                          hintText: "بحث",
                          suffixIcon: search.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    search.clear();
                                    context
                                        .read<CategoryBloc>()
                                        .add(SetStateEvent());
                                  },
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                ).animate().fade()
                              : null,
                          onChanged: (text) {
                            _onSearchTextChanged(state.category);
                            context.read<CategoryBloc>().add(SetStateEvent());
                          },
                        ),
                        Expanded(
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount:
                                _onSearchTextChanged(state.category).length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1 / 1.5,
                            ),
                            itemBuilder: (context, index) {
                              var allData =
                                  _onSearchTextChanged(state.category)[index];
                              return BaseAnimate(
                                index: index,
                                child: BaseBookItem(
                                  allData['title'],
                                  () {
                                    _onTap(allData, context);
                                  },
                                  type: allData['datatype'].toString(),
                                ),
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
          );
        },
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

  void _onTap(allData, BuildContext context) {
    // logger.d(allData);

    if (allData['datatype'] == 'multicategories') {
      context.push(
        CategoryDataScreen(
          id: allData['id'],
          title: allData['title'],
          url: allData['apiurl'],
        ),
      );
      return;
    }
    if (allData['datatype'] != "category") {
      if (allData['datatype'] == 'quran') {
        allData['api_url'] = allData['apiurl'];
        context.push(BaseAudioDetail(data: allData));
      } else {
        context.showBottomSheet(
          child: QuranBooksDetail(data: allData),
        );
      }
      return;
    }
    if (allData['datatype'] == "category") {
      context.push(
        CategoryDataScreen(
          id: allData['id'],
          title: title,
          url: allData['apiurl'],
        ),
      );
      return;
    }
  }
}
