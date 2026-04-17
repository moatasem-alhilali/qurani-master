import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/wird/data/models/wird_model.dart';
import 'package:quran_app/features/wird/presentation/bloc/wird_bloc.dart';
import 'package:quran_app/features/wird/presentation/view/widgets/wird/wird_display_mode_toggle.dart';
import 'package:quran_app/features/wird/presentation/view/widgets/wird/wird_item_card.dart';
import 'package:quran_app/features/wird/presentation/view/widgets/wird/wird_play_all_button.dart';
import 'package:quran_app/features/wird/presentation/view/widgets/wird/wird_play_all_status.dart';

class WirdCollectionView extends StatefulWidget {
  const WirdCollectionView({super.key});

  @override
  State<WirdCollectionView> createState() => _WirdCollectionViewState();
}

class _WirdCollectionViewState extends State<WirdCollectionView> {
  final CarouselSliderController _carouselController = CarouselSliderController();

  void _goToPage(int index) {
    _carouselController.animateToPage(
      index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  Widget _buildItemCard(BuildContext context, List<WirdModel> items, int index, WirdState state) {
    final item = items[index];
    final remaining = state.remainingCounters[index] ?? item.counter;
    
    return WirdItemCard(
      key: ValueKey('wird_${item.title}_$index'),
      item: item,
      index: index,
      remaining: remaining,
      onDecrement: () {
        if (remaining > 0) {
          context.read<WirdBloc>().add(UpdateRemainingCounterEvent(index, remaining - 1));
        }
      },
      onReset: () => context.read<WirdBloc>().add(ResetRemainingCounterEvent(index)),
      hasAudio: state.itemsWithAudio.contains(index),
      isAudioInitializing: state.isAudioInitializing,
      isCurrentAudio: state.activeItemIndex == index,
      isAudioPlaying: state.isPlaying,
      audioProcessingState: state.processingState,
      onAudioPressed: () => context.read<WirdBloc>().add(ToggleAudioWirdEvent(index)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WirdBloc, WirdState>(
      builder: (context, state) {
        final items = state.data ?? [];
        if (items.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: WirdPlayAllButton(),
                    ),
                    SizedBox(width: 8),
                    WirdDisplayModeToggle(),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              const WirdPlayAllStatus(),
              const SizedBox(height: 4),
              if (state.displayMode == WirdDisplayMode.listView)
                ListView.separated(
                  itemCount: items.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (_, __) => const SizedBox(height: 2),
                  itemBuilder: (context, index) {
                    return _buildItemCard(context, items, index, state);
                  },
                )
              else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        'ذكر ${state.currentPageIndex + 1} / ${items.length}',
                        style: context.titleSmall?.copyWith(
                          color: context.onSurfaceColor.withValues(alpha: 0.7),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: state.currentPageIndex <= 0
                            ? null
                            : () => _goToPage(state.currentPageIndex - 1),
                        icon: const Icon(Icons.chevron_right_rounded),
                        tooltip: 'السابق',
                      ),
                      IconButton(
                        onPressed: state.currentPageIndex >= items.length - 1
                            ? null
                            : () => _goToPage(state.currentPageIndex + 1),
                        icon: const Icon(Icons.chevron_left_rounded),
                        tooltip: 'التالي',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.70,
                  child: CarouselSlider.builder(
                    controller: _carouselController,
                    itemCount: items.length,
                    options: CarouselOptions(
                      height: MediaQuery.sizeOf(context).height * 0.70,
                      viewportFraction: 0.86,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.04,
                      initialPage: state.currentPageIndex,
                      onPageChanged: (index, _) {
                        context.read<WirdBloc>().add(ChangePageEvent(index));
                      },
                    ),
                    itemBuilder: (context, index, _) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _buildItemCard(context, items, index, state),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
