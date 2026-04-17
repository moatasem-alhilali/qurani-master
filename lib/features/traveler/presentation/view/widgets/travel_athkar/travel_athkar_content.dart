import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_athkar/travel_athkar_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_athkar/travel_athkar_card.dart';

class TravelAthkarContent extends StatelessWidget {
  const TravelAthkarContent({
    required this.state,
    required this.carouselController,
    super.key,
  });

  final TravelAthkarState state;
  final CarouselSliderController carouselController;

  @override
  Widget build(BuildContext context) {
    final visibleItems = state.filteredItems;

    if (visibleItems.isEmpty) {
      return Center(
        child: Text(
          'لا توجد نتائج مطابقة.',
          style: TextStyle(
            color: context.onSurfaceColor.withValues(alpha: 0.65),
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    if (state.displayMode == AthkarDisplayMode.listView) {
      return ListView.separated(
        itemCount: visibleItems.length,
        separatorBuilder: (_, __) => SizedBox(height: 8.h),
        itemBuilder: (context, index) {
          final item = visibleItems[index];
          final current = state.repeatCounts[item.key] ?? 0;
          return TravelAthkarCard(item: item, current: current);
        },
      );
    }

    final safeIndex = state.currentPageIndex >= visibleItems.length
        ? visibleItems.length - 1
        : state.currentPageIndex;

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CarouselSlider.builder(
                controller: carouselController,
                itemCount: visibleItems.length,
                options: CarouselOptions(
                  height: constraints.maxHeight,
                  viewportFraction: 0.86,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.04,
                  initialPage: safeIndex,
                  onPageChanged: (value, _) {
                    context.read<TravelAthkarBloc>().add(UpdatePageIndexEvent(value));
                  },
                ),
                itemBuilder: (context, index, _) {
                  final item = visibleItems[index];
                  final current = state.repeatCounts[item.key] ?? 0;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: TravelAthkarCard(item: item, current: current),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
