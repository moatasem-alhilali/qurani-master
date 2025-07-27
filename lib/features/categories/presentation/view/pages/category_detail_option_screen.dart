import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/components/my_text_form_field.dart';
import 'package:quran_app/core/components/quran_widgets/feature_card_icon_widget.dart';
import 'package:quran_app/core/components/quran_widgets/feature_card_text_widget.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/categories/data/model/category_section_model.dart';
import 'package:quran_app/features/categories/data/model/category_video_model.dart';
import 'package:quran_app/features/categories/data/remote/category_repository_imp.dart';
import 'package:quran_app/features/categories/presentation/bloc/category_bloc.dart';
import 'package:quran_app/features/categories/presentation/view/pages/category_detail_screen.dart';
import 'package:quran_app/features/categories/presentation/view/widgets/sheet_audio.dart';

class CategoryDetailOptionScreen extends StatelessWidget {
  CategoryDetailOptionScreen({required this.category, super.key});
  final CategorySectionModel category;
  TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryBloc(
        repositoryImpl: sl.get<CategoryRepositoryImpl>(),
      )..add(GetCategoryOptionEvent(category.apiUrl)),
      child: AppScaffoldWidget(
        title: category.title,
        slivers: [
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              return SliverToBoxAdapter(
                child: MyTextFormFieldWidget(
                  controller: search,
                  hintText: 'بحث',
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
                    _onSearchTextChanged(state.categoriesOptionsSearch);
                    context.read<CategoryBloc>().add(SetStateEvent());
                  },
                ),
              );
            },
          ),
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              return state.quranBooksState.whenSliver<dynamic>(
                onSuccess: () {
                  final allData = state.categoriesOptionsSearch;

                  final randomShapeType = CardShapeType
                      .values[Random().nextInt(CardShapeType.values.length)];

                  return SliverList.builder(
                    itemCount: _onSearchTextChanged(allData).length,
                    itemBuilder: (context, index) {
                      final data = _onSearchTextChanged(allData)[index];
                      return FeatureCardIconWidget(
                        title: data.title.toString(),
                        icon: Text(data.type.toString()),
                        height: 100.h,
                        width: double.infinity,
                        shapeType: randomShapeType,
                        onTap: () {
                          if (data.type == 'audios') {
                            context.showBottomSheetUIHeader(
                              child: SheetAudios(
                                baseData: data,
                              ),
                              title: data.title.toString(),
                              subtitle: data.description.toString(),
                            );
                            return;
                          } else {
                            context.push(
                              CategoryDetailScreen(
                                category: data,
                              ),
                            );
                          }
                        },
                      );
                      //  _Item(allData);
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  List<CategoryDetailModel> _onSearchTextChanged(
    List<CategoryDetailModel> data,
  ) {
    final res = data
        .where(
          (data) => data.title
              .toString()
              .toLowerCase()
              .contains(search.text.toLowerCase()),
        )
        .toList();
    return res;
  }
}

//
