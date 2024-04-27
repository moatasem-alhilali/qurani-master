import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quran_app/core/local/cash.dart';
import 'package:quran_app/core/theme/app_themes.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/widgets/read_quran/svg_picture.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/bottom_option.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/quran_page.dart';
import 'package:quran_app/main_view.dart';

class ReadQuranScreen extends StatelessWidget {
  const ReadQuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        CashConfig.setLastRead();
        return true;
      },
      child: Scaffold(
        backgroundColor: currentThemeData.colorScheme.background,
        body: SafeArea(
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              // context.read<ReadQuranBloc>().add(ToggleEvent());

              showDialog(
                context: context,
                builder: (context) {
                  return Scaffold(
                    backgroundColor: Colors.transparent,
                    body: SizedBox(
                      height: context.getScreenHeight(),
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
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
                                    color: currentThemeData.colorScheme.primary
                                        .withOpacity(.15),
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(),
                                  InkWell(
                                    onTap: () {
                                      context.showBottomSheet(
                                        backgroundColor: currentThemeData
                                            .colorScheme.background,
                                        child: SettingTheme(),
                                      );
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        options(
                                          height: 25.0,
                                          width: 25.0,
                                          color: currentThemeData
                                              .colorScheme.surface,
                                        ),
                                        Text(
                                          "الاعدادات",
                                          style: TextStyle(
                                            color: currentThemeData
                                                .colorScheme.surface,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              
                                ],
                              ),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.bottomCenter,
                            child: BottomOption(),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: context.getHight(70),
                              width: double.infinity,
                              color: Colors.transparent,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  context.pop();
                                },
                                child: const CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: const QuranPage(),
          ),
        ),
      ),
    );
  }
}
