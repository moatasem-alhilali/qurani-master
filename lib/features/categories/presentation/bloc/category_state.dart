part of 'category_bloc.dart';

@immutable
class CategoryState {
  List<dynamic> category;
  dynamic categoryDetail;
  RequestState categoryState;

  //
  Map<String, dynamic> quranBooksDetail;
  List<dynamic> quranBooksDetailSearch;
  RequestState quranBooksState;

  CategoryState({
    this.categoryState = RequestState.defaults,
    this.category = const [],
    this.categoryDetail = const [],
    this.quranBooksDetailSearch = const [],
    //
    this.quranBooksState = RequestState.defaults,
    this.quranBooksDetail = const {},
  });

  CategoryState copyWith({
    RequestState? famousCategoryState,
    List<dynamic>? famousCategory,
    dynamic? categoryDetail,

    //
    RequestState? quranBooksState,
    Map<String, dynamic>? quranBooksDetail,
      List<dynamic>? quranBooksDetailSearch,
  }) {
    return CategoryState(
      //famous Category

      category: famousCategory ?? category,
      categoryDetail: categoryDetail ?? this.categoryDetail,
      categoryState: famousCategoryState ?? categoryState,

      //
      quranBooksDetail: quranBooksDetail ?? this.quranBooksDetail,
      quranBooksState: quranBooksState ?? this.quranBooksState,
      quranBooksDetailSearch: quranBooksDetailSearch ?? this.quranBooksDetailSearch,
    );
  }
}
