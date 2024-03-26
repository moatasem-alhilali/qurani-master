import 'package:flutter/material.dart';
import 'package:quran_app/core/theme/app_themes.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/bottom_option.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/quran_page.dart';
import 'package:quran_app/main_view.dart';

class ReadQuranScreen extends StatelessWidget {
  const ReadQuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setLastRead();
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
