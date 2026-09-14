import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_athkar/travel_athkar_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_athkar/travel_athkar_content.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_athkar/travel_athkar_header_actions.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_athkar/travel_athkar_summary_card.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/traveler_shell.dart';

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
  State<_TravelAthkarOrchestrator> createState() =>
      _TravelAthkarOrchestratorState();
}

class _TravelAthkarOrchestratorState extends State<_TravelAthkarOrchestrator> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  void _jumpToFirstPage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_carouselController.ready) return;
      _carouselController.jumpToPage(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TravelerScaffold(
      title: 'أذكار السفر',
      actions: [
        TravelAthkarHeaderActions(onJumpToFirstPage: _jumpToFirstPage),
      ],
      child: BlocBuilder<TravelAthkarBloc, TravelAthkarState>(
        builder: (context, state) {
          if (state.status == TravelAthkarStatus.loading ||
              state.status == TravelAthkarStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TravelAthkarStatus.failure &&
              state.errorMessage != null) {
            return TravelerNotice(
              icon: AppIcons.error,
              message: state.errorMessage!,
              isError: true,
              actionLabel: 'إعادة المحاولة',
              onAction: () =>
                  context.read<TravelAthkarBloc>().add(LoadAthkarEvent()),
            );
          }

          return Column(
            children: [
              TravelAthkarSummaryCard(state: state),
              Expanded(
                child: TravelAthkarContent(
                  state: state,
                  carouselController: _carouselController,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
