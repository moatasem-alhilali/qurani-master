import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/dialog/option_quran_dialog.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/header_read_quran_widget.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/read_quran_page_widget.dart';
import 'package:quran_app/main.dart';

class ReadQuranScreen extends StatefulWidget {
  const ReadQuranScreen({super.key});

  @override
  State<ReadQuranScreen> createState() => _ReadQuranScreenState();
}

class _ReadQuranScreenState extends State<ReadQuranScreen> {
  @override
  void initState() {
    if (lastPageRead != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ReadQuranBloc>().pageController.jumpToPage(lastPageRead);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final quranCtrl = context.read<ReadQuranBloc>().quranRH;

        return Scaffold(
          backgroundColor: context.quranTheme.colorScheme.background,
          body: SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => showDialog<void>(
                context: context,
                builder: (_) => const OptionQuranDialog(),
              ),
              child: Container(
                padding: context.customOrientation(
                  const EdgeInsets.symmetric(vertical: 8),
                  EdgeInsets.zero,
                ) as EdgeInsetsGeometry,
                height: context.getScreenHeight(),
                child: quranCtrl.pages.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : PageView.builder(
                        itemCount: 604,
                        controller:
                            context.read<ReadQuranBloc>().pageController,
                        padEnds: false,
                        onPageChanged: (val) async {
                          context.read<ReadQuranBloc>().add(
                                SetLastPageReadEvent(page: val),
                              );
                        },
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (_, index) {
                          return Center(
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: HeaderReadQuranWidget(
                                    index: index,
                                  ),
                                ),
                                Align(
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      final width = constraints.maxWidth;
                                      var horizontal = 30.0;
                                      if (width <= 400) {
                                        horizontal = 30.0;
                                      }

                                      if (width > 400) {
                                        horizontal = 25.0;
                                      }
                                      logger.d(width.round());

                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: horizontal,
                                        ),
                                        child: ReadQuranPageWidget(
                                          pageIndex: index,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    convertNumbers('${index + 1}'),
                                    style: TextStyle(
                                      fontSize: context.customOrientation(
                                        18.0,
                                        22.0,
                                      ) as double,
                                      fontFamily: 'naskh',
                                      color: const Color(0xff77554B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
