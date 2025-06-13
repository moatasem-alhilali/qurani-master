import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/read_quran/svg_picture.dart';

class SettingThemeSheet extends StatelessWidget {
  SettingThemeSheet({super.key});

  final List<String> titles = ["أزرق", "بني", "أخضر", "الداكن"];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Row(
          children: List.generate(
            titles.length,
            (i) {
              final isSelected = (currentThemeType - 1) == i;

              return Expanded(
                child: InkWell(
                  onTap: () async {
                    currentThemeType = i + 1;
                    context
                        .read<ThemeBloc>()
                        .add(ChangeThemeEvent(theme: i + 1));
                    await CacheService()
                        .setInt('currentThemeType', currentThemeType);
                    if (context.mounted) {
                      context.pop();
                      context.pop();
                    }
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: theme(
                            height: context.getHight(15), theme: '${i + 1}'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            titles[i],
                            style: TextStyle(
                                color: context.currentThemeData.cardColor),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: isSelected
                                  ? context.currentThemeData.cardColor
                                  : context
                                      .currentThemeData.colorScheme.surface,
                              child: isSelected
                                  ? const Icon(Icons.check, size: 14)
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
