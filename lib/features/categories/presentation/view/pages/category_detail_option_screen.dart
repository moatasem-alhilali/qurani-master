import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/categories/data/model/category_section_model.dart';
import 'package:quran_app/features/categories/data/model/category_video_model.dart';
import 'package:quran_app/features/categories/data/remote/category_repository_imp.dart';
import 'package:quran_app/features/categories/presentation/bloc/category_bloc.dart';
import 'package:quran_app/features/categories/presentation/view/pages/category_detail_screen.dart';
import 'package:quran_app/features/categories/presentation/view/widgets/category_skin_widgets.dart';
import 'package:quran_app/features/categories/presentation/view/widgets/sheet_audio.dart';
import 'package:quran_app/l10n/l10n.dart';

/// عناصر تصنيف واحد: بحث ثم صفوف نحيلة، كل صفّ كتاب أو مادة صوتية.
class CategoryDetailOptionScreen extends StatefulWidget {
  const CategoryDetailOptionScreen({required this.category, super.key});

  final CategorySectionModel category;

  @override
  State<CategoryDetailOptionScreen> createState() =>
      _CategoryDetailOptionScreenState();
}

class _CategoryDetailOptionScreenState
    extends State<CategoryDetailOptionScreen> {
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<CategoryDetailModel> _filter(List<CategoryDetailModel> data) {
    final query = _search.text.trim().toLowerCase();
    if (query.isEmpty) return data;
    return data
        .where((item) => (item.title ?? '').toLowerCase().contains(query))
        .toList();
  }

  String _typeLabel(String? type) {
    switch (type) {
      case 'audios':
        return context.l10n.categoriesItemAudio;
      case 'books':
        return context.l10n.categoriesItemBook;
      case 'articles':
        return context.l10n.categoriesItemArticle;
      case 'videos':
        return context.l10n.categoriesItemVideo;
      default:
        return type ?? '';
    }
  }

  HugeIconData _typeIcon(String? type) {
    switch (type) {
      case 'audios':
        return AppIcons.sound;
      case 'videos':
        return AppIcons.play;
      case 'articles':
        return AppIcons.noteEdit;
      default:
        return AppIcons.menuBook;
    }
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocProvider(
      create: (context) => CategoryBloc(
        repositoryImpl: sl.get<CategoryRepositoryImpl>(),
      )..add(GetCategoryOptionEvent(widget.category.apiUrl)),
      child: Theme(
        data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
        child: AppScaffoldWidget(
          title: widget.category.title ?? context.l10n.categoriesFallbackTitle,
          slivers: [
            SliverToBoxAdapter(
              child: ColoredBox(
                color: skin.ground,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CategorySearchField(
                      controller: _search,
                      onChanged: (_) => setState(() {}),
                    ),
                    skin.divider(),
                  ],
                ),
              ),
            ),
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                return state.quranBooksState.whenSliver<dynamic>(
                  onLoading: const CategoryThinLoader(),
                  onSuccess: () {
                    final items = _filter(state.categoriesOptionsSearch);

                    if (items.isEmpty) {
                      return SliverToBoxAdapter(
                        child: CategoryNotice(
                          message: context.l10n.categoriesNoSearchResults,
                        ),
                      );
                    }

                    return SliverList.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final data = items[index];
                        return ColoredBox(
                          color: skin.ground,
                          child: CategoryRow(
                            title: data.title ?? '',
                            subtitle: _typeLabel(data.type),
                            icon: _typeIcon(data.type),
                            isLast: index == items.length - 1,
                            onTap: () => _open(context, data),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context, CategoryDetailModel data) {
    if (data.type == 'audios') {
      showCategoryAudiosSheet(context, baseData: data);
      return;
    }

    context.push(CategoryDetailScreen(category: data));
  }
}
