// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'theme_bloc.dart';

@immutable
class ThemeState {
  final String currentThemeType;
  final ThemeMode currentThemeMode;
  const ThemeState({
    this.currentThemeType = ThemeColorsManager.blue,
    this.currentThemeMode = ThemeMode.dark,
  });

  ThemeState copyWith({
    String? currentThemeType,
    ThemeMode? currentThemeMode,
  }) {
    return ThemeState(
      currentThemeType: currentThemeType ?? this.currentThemeType,
      currentThemeMode: currentThemeMode ?? this.currentThemeMode,
    );
  }
}
