part of 'theme_bloc.dart';

@immutable
abstract class ThemeEvent {}

class ChangeThemeEvent extends ThemeEvent {
  String theme;
  ChangeThemeEvent({required this.theme});
}

class InitThemeEvent extends ThemeEvent {}
