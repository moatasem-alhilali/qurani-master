part of 'theme_bloc.dart';

@immutable
abstract class ThemeEvent {}

class ChangeThemeColorsEvent extends ThemeEvent {
  String theme;
  ChangeThemeColorsEvent({required this.theme});
}

class ChangeThemeModeEvent extends ThemeEvent {
  String mode;
  ChangeThemeModeEvent({required this.mode});
}

class InitThemeEvent extends ThemeEvent {}
