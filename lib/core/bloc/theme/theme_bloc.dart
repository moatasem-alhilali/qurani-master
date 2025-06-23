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
    on<ChangeThemeEvent>(_onThemeChange);
    on<InitThemeEvent>(_onInitTheme);
  }
  MyColorTheme get currentThemeData =>
      ThemeManager.getThemeByType(state.currentThemeType);
  FutureOr<void> _onThemeChange(
    ChangeThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final currentThemeType = event.theme;
    await CacheService().setString(ThemeManager.cacheKey, currentThemeType);
    emit(
      state.copyWith(
        currentThemeType: event.theme,
      ),
    );
  }

  FutureOr<void> _onInitTheme(
    InitThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final currentThemeType =
        CacheService().getString(ThemeManager.cacheKey) ?? ThemeManager.blue;
    emit(state.copyWith(currentThemeType: currentThemeType));
  }
}

extension ThemeContextExtension on BuildContext {
  MyColorTheme get quranTheme {
    final type =
        CacheService().getString(ThemeManager.cacheKey) ?? ThemeManager.blue;
    return ThemeManager.getThemeByType(type);
  }

  ThemeData get themeApp {
    final type =
        CacheService().getString(ThemeManager.cacheKey) ?? ThemeManager.blue;
    return ThemeManager.getThemeApp(type);
  }
}
