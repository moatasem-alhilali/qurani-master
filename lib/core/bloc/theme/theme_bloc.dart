import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/core/theme/quran_themes.dart';
import 'package:quran_app/core/theme/theme_manager.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ChangeThemeColorsEvent>(_onThemeChange);
    on<ChangeThemeModeEvent>(_onThemeModeChange);
    on<InitThemeEvent>(_onInitTheme);
  }
  MyColorTheme get currentThemeData =>
      ThemeColorsManager.getThemeByType(state.currentThemeType);
  FutureOr<void> _onThemeChange(
    ChangeThemeColorsEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final currentThemeType = event.theme;
    await CacheService()
        .setString(ThemeColorsManager.cacheKey, currentThemeType);
    emit(
      state.copyWith(
        currentThemeType: event.theme,
      ),
    );
  }

  FutureOr<void> _onThemeModeChange(
    ChangeThemeModeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final currentThemeMode = event.mode;
    await CacheService().setString(ThemeModeManager.cacheKey, currentThemeMode);
    emit(
      state.copyWith(
        currentThemeMode: ThemeMode.values.byName(currentThemeMode),
      ),
    );
  }

  FutureOr<void> _onInitTheme(
    InitThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final currentThemeType =
        CacheService().getString(ThemeColorsManager.cacheKey) ??
            ThemeColorsManager.blue;
    emit(state.copyWith(currentThemeType: currentThemeType));

    final currentThemeMode =
        CacheService().getString(ThemeModeManager.cacheKey) ??
            ThemeModeManager.dark;
    emit(
      state.copyWith(
        currentThemeMode: ThemeMode.values.byName(currentThemeMode),
      ),
    );
  }
}

extension ThemeContextExtension on BuildContext {
  MyColorTheme get quranTheme {
    final type = CacheService().getString(ThemeColorsManager.cacheKey) ??
        ThemeColorsManager.blue;
    return ThemeColorsManager.getThemeByType(type);
  }

  ThemeData get themeApp {
    final type = CacheService().getString(ThemeColorsManager.cacheKey) ??
        ThemeColorsManager.blue;
    return ThemeColorsManager.getThemeApp(type);
  }
}
