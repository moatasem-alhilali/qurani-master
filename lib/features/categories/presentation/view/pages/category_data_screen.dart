import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_home_widget.dart';
import 'package:quran_app/core/components/my_text_form_field.dart';
import 'package:quran_app/core/components/quran_widgets/feature_card_text_widget.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/extensions/request_state_extension.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/audios/presentation/view/pages/base_audio_deatil.dart';
import 'package:quran_app/features/categories/data/model/category_section_model.dart';
import 'package:quran_app/features/categories/data/model/category_video_model.dart';
import 'package:quran_app/features/categories/data/remote/category_repository_imp.dart';
import 'package:quran_app/features/categories/presentation/bloc/category_bloc.dart';
import 'package:quran_app/features/categories/presentation/view/pages/category_detail_screen.dart';

class CategoryDataScreen extends StatelessWidget {
  CategoryDataScreen({
    required this.id,
    required this.title,
    required this.url,
    super.key,
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
      )..add(GetCategoriesEvent(id, url)),
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          return BaseHomeWidget(
            isScroll: false,
            title: title,
            showBackground: false,
            body: BlocConsumer<CategoryBloc, CategoryState>(
              listener: (context, state) {},
              builder: (context, state) {
                return state.categoryState.handle<dynamic>(
                  onSuccess: () {
                    return Column(
                      children: [
                        MyTextFormFieldWidget(
                          controller: search,
                          hintText: 'بحث',
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
                            _onSearchTextChanged(state.categories);
                            context.read<CategoryBloc>().add(SetStateEvent());
                          },
                        ),
                        Expanded(
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount:
                                _onSearchTextChanged(state.categories).length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1 / 1.1,
                            ),
                            itemBuilder: (context, index) {
                              final allData =
                                  _onSearchTextChanged(state.categories)[index];
                              return BaseAnimate(
                                index: 0,
                                child: FeatureCardTextWidget(
                                  title: allData.title ?? '',
                                  onTap: () {
                                    _onTap(allData, context);
                                  },
                                ),
                              );
                              //  _Item(allData);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  List<CategorySectionModel> _onSearchTextChanged(
    List<CategorySectionModel> data,
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

  void _onTap(CategorySectionModel allData, BuildContext context) {
    if (allData.dataType == 'multicategories') {
      context.push(
        CategoryDataScreen(
          id: allData.id!,
          title: allData.title!,
          url: allData.apiUrl,
        ),
      );
      return;
    }
    if (allData.dataType != 'category') {
      if (allData.dataType == 'quran') {
        context.push(BaseAudioDetail(data: allData));
      } else {
        context.push(
          CategoryDetailScreen(
            category: CategoryDetailModel(
              apiUrl: allData.apiUrl,
              title: allData.title,
            ),
          ),
        );
      }
      return;
    }
    if (allData.dataType == 'category') {
      context.push(
        CategoryDataScreen(
          id: allData.id!,
          title: title,
          url: allData.apiUrl,
        ),
      );
      return;
    }
  }
}
