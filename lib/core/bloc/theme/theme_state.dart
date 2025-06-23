// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'theme_bloc.dart';

@immutable
class ThemeState {
  final String currentThemeType;
  const ThemeState({
    this.currentThemeType = ThemeManager.blue,
  });

  ThemeState copyWith({
    String? currentThemeType,
  }) {
    return ThemeState(
      currentThemeType: currentThemeType ?? this.currentThemeType,
    );
  }
}
