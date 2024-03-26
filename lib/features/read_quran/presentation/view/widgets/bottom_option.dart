import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/bloc/base_bloc.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/theme/app_themes.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/drawer_slide/surah_juz_list.dart';
import 'package:quran_app/core/widgets/read_quran/svg_picture.dart';
import 'package:quran_app/features/bookmark/presentation/view/widgets/bookmark_list.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';
import 'package:quran_app/features/search/presentation/view/widgets/sarch_ayah.dart';

class BottomOption extends StatelessWidget {
  const BottomOption({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadQuranBloc, ReadQuranState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: currentThemeData.colorScheme.background,
            // borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -2),
                blurRadius: 3,
                spreadRadius: 3,
                color: currentThemeData.colorScheme.primary.withOpacity(.15),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      context.showBottomSheet(
                        backgroundColor:
                            currentThemeData.colorScheme.background,
                        child: SizedBox(
                          height: context.getHight(80),
                          child: SurahJuzList(),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        bookmark_list(height: 25.0, width: 25.0),
                        Text(
                          "السور",
                          style: TextStyle(
                            color: currentThemeData.colorScheme.surface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      context.showBottomSheet(
                        backgroundColor:
                            currentThemeData.colorScheme.background,
                        child: SizedBox(
                          height: context.getHight(80),
                          child: BookMarkList(),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        bookmark_list(height: 25.0, width: 25.0),
                        Text(
                          "المحفوظ",
                          style: TextStyle(
                            color: currentThemeData.colorScheme.surface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      context.showBottomSheet(
                          child: SearchAyah(),
                          backgroundColor:
                              currentThemeData.colorScheme.background);
                    },
                    child: Column(
                      children: [
                        search_icon(height: 25.0, width: 25.0),
                        Text(
                          "البحث",
                          style: TextStyle(
                            color: currentThemeData.colorScheme.surface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      context.showBottomSheet(
                        backgroundColor:
                            currentThemeData.colorScheme.background,
                        child: SettingTheme(),
                      );
                    },
                    child: Column(
                      children: [
                        options(height: 25.0, width: 25.0),
                        Text(
                          "الاعدادات",
                          style: TextStyle(
                            color: currentThemeData.colorScheme.surface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ).animate().fade(),
        );
      },
    );
  }
}

class SettingTheme extends StatelessWidget {
  SettingTheme({
    super.key,
  });
  List<String> titles = ["أزرق", "بني", "أخضر", "الداكن"];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadQuranBloc, ReadQuranState>(
      builder: (context, state) {
        return BlocBuilder<BaseBloc, BaseState>(
          builder: (context, state) {
            return SizedBox(
              child: Row(
                children: [
                  for (int i = 0; i < titles.length; i++)
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          currentThemeType = i + 1;
                          print(currentThemeType);
                          await CashHelper.setData(
                              key: 'currentThemeType', value: currentThemeType);
                          if (context.mounted) {
                            context
                                .read<BaseBloc>()
                                .add(SetStateBaseBlocEvent());
                            context
                                .read<ReadQuranBloc>()
                                .add(SetStateRBlocEvent());
                            context.pop();
                            context.pop();
                          }
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: theme(
                                height: context.getHight(15),
                                theme: (i + 1).toString(),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  titles[i],
                                  style: TextStyle(
                                    color: currentThemeData.cardColor,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: (currentThemeType - 1) == i
                                        ? currentThemeData.cardColor
                                        : currentThemeData.colorScheme.surface,
                                    child: (currentThemeType - 1) == i
                                        ? const FittedBox(
                                            child: Icon(Icons.check))
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
