import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_athkar/travel_athkar_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_athkar/travel_athkar_content.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_athkar/travel_athkar_header_actions.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_athkar/travel_athkar_summary_card.dart';

class TravelAthkarScreen extends StatelessWidget {
  const TravelAthkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TravelAthkarBloc(),
      child: const _TravelAthkarOrchestrator(),
    );
  }
}

class _TravelAthkarOrchestrator extends StatefulWidget {
  const _TravelAthkarOrchestrator();

  @override
  State<_TravelAthkarOrchestrator> createState() => _TravelAthkarOrchestratorState();
}

class _TravelAthkarOrchestratorState extends State<_TravelAthkarOrchestrator> {
  final CarouselSliderController _carouselController = CarouselSliderController();

  void _jumpToFirstPage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_carouselController.ready) return;
      _carouselController.jumpToPage(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      title: 'أذكار السفر',
      showLargeHeader: false,
      initialOffset: null,
      trailing: TravelAthkarHeaderActions(
        onJumpToFirstPage: _jumpToFirstPage,
      ),
      slivers: [
        BlocBuilder<TravelAthkarBloc, TravelAthkarState>(
          builder: (context, state) {
            if (state.status == TravelAthkarStatus.loading ||
                state.status == TravelAthkarStatus.initial) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state.status == TravelAthkarStatus.failure &&
                state.errorMessage != null) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.sp),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: context.onSurfaceColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        FilledButton.icon(
                          onPressed: () => context
                              .read<TravelAthkarBloc>()
                              .add(LoadAthkarEvent()),
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return SliverFillRemaining(
              child: Padding(
                padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 12.h),
                child: Column(
                  children: [
                    TravelAthkarSummaryCard(state: state),
                    SizedBox(height: 10.h),
                    Expanded(
                      child: TravelAthkarContent(
                        state: state,
                        carouselController: _carouselController,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
