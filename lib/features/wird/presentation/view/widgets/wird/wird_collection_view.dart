import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
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
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  void _goToPage(int index) {
    _carouselController.animateToPage(
      index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  Widget _buildItemCard(
    BuildContext context,
    List<WirdModel> items,
    int index,
    WirdState state, {
    bool isLast = false,
  }) {
    final item = items[index];
    final remaining = state.remainingCounters[index] ?? item.counter;

    return WirdItemCard(
      key: ValueKey('wird_${item.title}_$index'),
      item: item,
      index: index,
      isLast: isLast,
      remaining: remaining,
      onDecrement: () {
        if (remaining > 0) {
          context
              .read<WirdBloc>()
              .add(UpdateRemainingCounterEvent(index, remaining - 1));
        }
      },
      onReset: () =>
          context.read<WirdBloc>().add(ResetRemainingCounterEvent(index)),
      hasAudio: state.itemsWithAudio.contains(index),
      isAudioInitializing: state.isAudioInitializing,
      isCurrentAudio: state.activeItemIndex == index,
      isAudioPlaying: state.isPlaying,
      audioProcessingState: state.processingState,
      onAudioPressed: () =>
          context.read<WirdBloc>().add(ToggleAudioWirdEvent(index)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocBuilder<WirdBloc, WirdState>(
      builder: (context, state) {
        final items = state.data ?? [];
        if (items.isEmpty) return const SizedBox.shrink();

        final isList = state.displayMode == WirdDisplayMode.listView;

        return ColoredBox(
          color: skin.ground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: const Row(
                  children: [
                    Expanded(child: WirdPlayAllButton()),
                    WirdDisplayModeToggle(),
                  ],
                ),
              ),
              const WirdPlayAllStatus(),
              skin.divider(),
              if (isList)
                ListView.builder(
                  itemCount: items.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _buildItemCard(
                      context,
                      items,
                      index,
                      state,
                      isLast: index == items.length - 1,
                    );
                  },
                )
              else ...[
                _PagerBar(
                  current: state.currentPageIndex,
                  total: items.length,
                  onPrevious: state.currentPageIndex <= 0
                      ? null
                      : () => _goToPage(state.currentPageIndex - 1),
                  onNext: state.currentPageIndex >= items.length - 1
                      ? null
                      : () => _goToPage(state.currentPageIndex + 1),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.70,
                  child: CarouselSlider.builder(
                    controller: _carouselController,
                    itemCount: items.length,
                    options: CarouselOptions(
                      height: MediaQuery.sizeOf(context).height * 0.70,
                      viewportFraction: 0.92,
                      enableInfiniteScroll: false,
                      initialPage: state.currentPageIndex,
                      onPageChanged: (index, _) {
                        context.read<WirdBloc>().add(ChangePageEvent(index));
                      },
                    ),
                    itemBuilder: (context, index, _) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: _buildItemCard(
                          context,
                          items,
                          index,
                          state,
                          isLast: true,
                        ),
                      );
                    },
                  ),
                ),
              ],
              SizedBox(height: 18.h),
            ],
          ),
        );
      },
    );
  }
}

/// شريط التنقّل بين الأذكار في عرض البطاقة الواحدة.
class _PagerBar extends StatelessWidget {
  const _PagerBar({
    required this.current,
    required this.total,
    required this.onPrevious,
    required this.onNext,
  });

  final int current;
  final int total;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'الذكر ${current + 1} من $total',
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _PagerButton(
            icon: AppIcons.chevronRight,
            tooltip: 'السابق',
            onTap: onPrevious,
          ),
          SizedBox(width: 6.w),
          _PagerButton(
            icon: AppIcons.chevronLeft,
            tooltip: 'التالي',
            onTap: onNext,
          ),
        ],
      ),
    );
  }
}

class _PagerButton extends StatelessWidget {
  const _PagerButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final HugeIconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final enabled = onTap != null;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(
            color: enabled ? skin.iconChip : skin.raised,
            borderRadius: BorderRadius.circular(10.r),
            border: enabled ? null : Border.all(color: skin.hairline),
          ),
          child: Center(
            child: AppIcon(
              icon,
              color:
                  enabled ? skin.accent : skin.inkSoft.withValues(alpha: 0.38),
              size: 15.sp,
            ),
          ),
        ),
      ),
    );
  }
}
