import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/package/flutter_sliding_box.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/dialog/option_quran_dialog.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/header_read_quran_widget.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/read_quran_page_widget.dart';

class ReadQuranScreen extends StatefulWidget {
  const ReadQuranScreen({super.key});

  @override
  State<ReadQuranScreen> createState() => _ReadQuranScreenState();
}

class _ReadQuranScreenState extends State<ReadQuranScreen> {
  BoxController boxController = BoxController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // if (lastPageRead != 0) {
      //   context.read<ReadQuranBloc>().pageController.jumpToPage(lastPageRead);
      // }
      boxController.closeBox();
    });
    super.initState();
  }

  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.scaffoldBackgroundColor,
          body: SlidingBox(
            minHeight: 50,
            // collapsed: true,
            // style: BoxStyle.shadow,
            maxHeight: MediaQuery.of(context).size.height - 200,
            controller: boxController,
            backdrop: Backdrop(
              fading: true,
              appBar: BackdropAppBar(
                searchBox: SearchBox(
                  controller: textEditingController,
                  color: Theme.of(context).colorScheme.surface,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 18,
                  ),
                  body: Center(
                    child: Text(
                      'Search Result',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              body: const _BodyQuran(),
            ),
            body: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(25),
                    child: IconButton(
                      iconSize: 27,
                      icon: Icon(
                        Icons.search_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        textEditingController.text = '';
                        boxController.showSearchBox();
                      },
                    ),
                  ),
                ),
                const OptionQuranDialog(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BodyQuran extends StatelessWidget {
  const _BodyQuran({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadQuranBloc, ReadQuranState>(
      builder: (context, state) {
        final pageController = context.read<ReadQuranBloc>().pageController;
        return SafeArea(
          child: Container(
            padding: context.customOrientation(
              const EdgeInsets.symmetric(vertical: 8),
              EdgeInsets.zero,
            ) as EdgeInsetsGeometry,
            height: context.getScreenHeight(),
            child: state.loadQuranState == RequestState.loading
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : PageView.builder(
                    itemCount: 604,
                    controller: pageController,
                    padEnds: false,
                    onPageChanged: (val) async {
                      context.read<ReadQuranBloc>().add(
                            SetLastPageReadEvent(page: val),
                          );
                    },
                    // physics: const ClampingScrollPhysics(),
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
                          ],
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
