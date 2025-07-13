part of 'category_bloc.dart';

@immutable
class CategoryState {
  CategoryState({
    this.categoryState = RequestState.initial,
    this.categories = const <CategorySectionModel>[],
    this.categoryDetail,
    this.categoriesOptions = const [],
    //
    this.quranBooksState = RequestState.initial,
    this.categoriesOptionsSearch = const [],
  });
  List<CategorySectionModel> categories;
  CategoryDetailModel? categoryDetail;
  RequestState categoryState;

  //

  List<CategoryDetailModel> categoriesOptions;
  List<CategoryDetailModel> categoriesOptionsSearch;
  RequestState quranBooksState;

  CategoryState copyWith({
    RequestState? categoryState,
    List<CategorySectionModel>? categories,
    CategoryDetailModel? categoryDetail,

    //
    RequestState? quranBooksState,
    List<CategoryDetailModel>? categoriesOptions,
    List<CategoryDetailModel>? categoriesOptionsSearch,
  }) {
    return CategoryState(
      //famous Category

      categories: categories ?? this.categories,
      categoryDetail: categoryDetail ?? this.categoryDetail,
      categoryState: categoryState ?? this.categoryState,

      //
      quranBooksState: quranBooksState ?? this.quranBooksState,
      categoriesOptions: categoriesOptions ?? this.categoriesOptions,
      categoriesOptionsSearch:
          categoriesOptionsSearch ?? this.categoriesOptionsSearch,
    );
  }
}
