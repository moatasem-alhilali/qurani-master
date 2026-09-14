import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/request_state_extension.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/audios/presentation/view/pages/base_audio_deatil.dart';
import 'package:quran_app/features/categories/data/model/category_section_model.dart';
import 'package:quran_app/features/categories/data/model/category_video_model.dart';
import 'package:quran_app/features/categories/data/remote/category_repository_imp.dart';
import 'package:quran_app/features/categories/presentation/bloc/category_bloc.dart';
import 'package:quran_app/features/categories/presentation/view/pages/category_detail_screen.dart';
import 'package:quran_app/features/categories/presentation/view/widgets/category_skin_widgets.dart';

/// أبواب تصنيف واحد: بحث نحيل فوق قائمة صفوف تفصلها خطوط شعرة.
class CategoryDataScreen extends StatefulWidget {
  const CategoryDataScreen({
    required this.id,
    required this.title,
    required this.url,
    super.key,
  });

  final int id;
  final String url;
  final String title;

  @override
  State<CategoryDataScreen> createState() => _CategoryDataScreenState();
}

class _CategoryDataScreenState extends State<CategoryDataScreen> {
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<CategorySectionModel> _filter(List<CategorySectionModel> data) {
    final query = _search.text.trim().toLowerCase();
    if (query.isEmpty) return data;
    return data
        .where(
          (item) => (item.title ?? '').toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocProvider(
      create: (context) => CategoryBloc(
        repositoryImpl: sl.get<CategoryRepositoryImpl>(),
      )..add(GetCategoriesEvent(widget.id, widget.url)),
      child: Theme(
        data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
        child: AppScaffoldWidget(
          title: widget.title,
          body: ColoredBox(
            color: skin.ground,
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                return state.categoryState.handle<dynamic>(
                  onLoading: const CategoryThinLoader(),
                  onSuccess: () {
                    final items = _filter(state.categories);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CategorySearchField(
                          controller: _search,
                          onChanged: (_) => setState(() {}),
                        ),
                        skin.divider(),
                        if (items.isEmpty)
                          const CategoryNotice(
                            message: 'لا توجد نتائج لهذا البحث.',
                          )
                        else
                          for (var i = 0; i < items.length; i++)
                            CategoryRow(
                              title: items[i].title ?? '',
                              subtitle: items[i].itemsCount == null
                                  ? null
                                  : '${items[i].itemsCount} عنصرًا',
                              icon: AppIcons.bookOpen,
                              isLast: i == items.length - 1,
                              onTap: () => _onTap(items[i], context),
                            ),
                        SizedBox(height: 22.h),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(CategorySectionModel allData, BuildContext context) {
    if (allData.dataType == 'multicategories') {
      context.push(
        CategoryDataScreen(
          id: allData.id ?? 0,
          title: allData.title ?? widget.title,
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

    context.push(
      CategoryDataScreen(
        id: allData.id ?? 0,
        title: widget.title,
        url: allData.apiUrl,
      ),
    );
  }
}
