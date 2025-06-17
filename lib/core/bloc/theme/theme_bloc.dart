import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/core/theme/quran_themes.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ChangeThemeEvent>(_onThemeChange);
  }
  MyColorTheme get currentThemeData =>
      ThemeManager.getThemeByType(state.currentThemeType);
  FutureOr<void> _onThemeChange(
    ChangeThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    currentThemeType = event.theme;
    await CacheService().setInt('currentThemeType', currentThemeType);
    emit(
      state.copyWith(
        currentThemeType: event.theme,
      ),
    );
  }
}

extension ThemeContextExtension on BuildContext {
  MyColorTheme get quranTheme {
    final type = read<ThemeBloc>().state.currentThemeType;
    return ThemeManager.getThemeByType(type);
  }

  ThemeData get themeApp {
    final type = read<ThemeBloc>().state.currentThemeType;
    return ThemeManager.getThemeApp(type);
  }
}
