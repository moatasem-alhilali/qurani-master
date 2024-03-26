part of 'base_bloc.dart';

@immutable
abstract class BaseEvent {}

class ChangeThemeEvent extends BaseEvent {}
class SetStateBaseBlocEvent extends BaseEvent {}
class CheckInternetBaseBloc extends BaseEvent {}

class ChangeScreenEvent extends BaseEvent {
  final int current;
  ChangeScreenEvent({required this.current});
}
