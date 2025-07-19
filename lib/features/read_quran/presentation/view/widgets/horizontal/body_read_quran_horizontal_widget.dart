import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/read_quran/presentation/bloc/read_quran_bloc.dart';
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
            color: context.primaryScheme.withValues(alpha: 0.1),
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
                              child: HeaderReadQuranHorizontalWidget(
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
