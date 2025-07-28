import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran/read_quran_bloc.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/horizontal/header_read_quran_horizontal_widget.dart';
import 'package:quran_app/features/read_quran/presentation/view/widgets/horizontal/read_quran_page_horizontal_widget.dart';

class BodyReadQuranHorizontalWidget extends StatelessWidget {
  const BodyReadQuranHorizontalWidget({
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
            color: context.primaryColor.withValues(alpha: 0.1),
            height: context.getScreenHeight(),
            child: state.loadQuranState == RequestState.loading
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : PageView.builder(
                    itemCount: 604,
                    controller: pageController,
                    padEnds: false,
                    physics: const ClampingScrollPhysics(),
//
                    onPageChanged: (val) async {
                      context.read<ReadQuranBloc>().add(
                            SetLastPageReadEvent(page: val),
                          );
                      // context.read<ReadQuranBloc>().add(
                      //       GetCurrentPageAyahsSeparatedForBasmalahEvent(
                      //         pageIndex: val,
                      //       ),
                      //     );
                    },
                    // physics: const ClampingScrollPhysics(),
                    itemBuilder: (_, index) {
                      return Center(
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: HeaderReadQuranHorizontalWidget(
                                index: index,
                                state: state,
                              ),
                            ),
                            Align(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final width = constraints.maxWidth;
                                  final height = constraints.maxHeight;
                                  final isLandscape = width > height;

                                  double horizontalPadding;

                                  //for small phones
                                  if (width <= 400) {
                                    horizontalPadding =
                                        isLandscape ? 10.0 : 20.0;
                                  }
                                  //for medium phones
                                  else if (width > 400 && width <= 600) {
                                    horizontalPadding =
                                        isLandscape ? 15.0 : 15.0;
                                  }
                                  //for tablets
                                  else if (width > 600 && width <= 1024) {
                                    horizontalPadding =
                                        isLandscape ? 60.0 : 90.0;
                                  }
                                  //for desktop
                                  else {
                                    horizontalPadding = width * 0.20;
                                  }

                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: horizontalPadding,
                                    ),
                                    child: ReadQuranPageHorizontalWidget(
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
