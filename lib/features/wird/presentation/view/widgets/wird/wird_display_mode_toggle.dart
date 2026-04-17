import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/wird/presentation/bloc/wird_bloc.dart';

class WirdDisplayModeToggle extends StatelessWidget {
  const WirdDisplayModeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WirdBloc, WirdState>(
      buildWhen: (p, c) => p.displayMode != c.displayMode,
      builder: (context, state) {
        final isListMode = state.displayMode == WirdDisplayMode.listView;

        return Tooltip(
          message: isListMode ? 'التحويل إلى PageView' : 'التحويل إلى ListView',
          child: IconButton(
            visualDensity: VisualDensity.compact,
            style: IconButton.styleFrom(
              backgroundColor: context.surfaceColor,
              side: BorderSide(
                color: context.outlineVariant.withValues(alpha: 0.32),
              ),
            ),
            onPressed: () => context.read<WirdBloc>().add(ChangeDisplayModeEvent()),
            icon: Icon(
              isListMode ? Icons.view_carousel_rounded : Icons.view_agenda_rounded,
              color: context.primaryColor,
              size: 20,
            ),
          ),
        );
      },
    );
  }
}
