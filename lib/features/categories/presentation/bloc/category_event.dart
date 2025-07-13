part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent {}

class SetStateEvent extends CategoryEvent {}

class GetCategoriesEvent extends CategoryEvent {
  GetCategoriesEvent(this.id, this.url);
  final int id;
  final String url;
}

class GetCategoryDetailEvent extends CategoryEvent {
  GetCategoryDetailEvent(this.url);
  final String url;
}

class SearchCategoryEvent extends CategoryEvent {
  SearchCategoryEvent(this.text);
  final String text;
}

class GetCategoryOptionEvent extends CategoryEvent {
  GetCategoryOptionEvent(this.url);
  final String url;
}
