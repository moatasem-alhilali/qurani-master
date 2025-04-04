// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'theme_bloc.dart';

@immutable
class ThemeState {
  final int currentThemeType;
  const ThemeState({
    this.currentThemeType = 1,
  });

  ThemeState copyWith({
    int? currentThemeType,
  }) {
    return ThemeState(
      currentThemeType: currentThemeType ?? this.currentThemeType,
    );
  }
}
