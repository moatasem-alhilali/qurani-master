import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/core/local/cash.dart';
import 'package:quran_app/core/theme/app_themes.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  MyColorTheme get currentThemeData =>
      ThemeManager.getThemeByType(state.currentThemeType);
  ThemeBloc() : super(const ThemeState()) {
    on<ChangeThemeEvent>(_onThemeChange);
  }
  FutureOr<void> _onThemeChange(
    ChangeThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    currentThemeType = event.theme;
    await CashHelper.setData(
      key: 'currentThemeType',
      value: currentThemeType,
    );
    emit(
      state.copyWith(
        currentThemeType: event.theme,
      ),
    );
  }
}

extension ThemeContextExtension on BuildContext {
  MyColorTheme get currentThemeData {
    final type = read<ThemeBloc>().state.currentThemeType;
    return ThemeManager.getThemeByType(type);
  }
}
