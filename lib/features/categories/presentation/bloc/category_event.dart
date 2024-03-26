part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent {}

class SetStateEvent extends CategoryEvent {}

class GetCategoryEvent extends CategoryEvent {
    final int id;
    final String url;
  GetCategoryEvent(this.id,this.url);
}






class GetQuranBookEvent extends CategoryEvent {
  final String url;
  GetQuranBookEvent(this.url);
}
class SearchCategoryEvent extends CategoryEvent {
  final String text;
  SearchCategoryEvent(this.text);
}