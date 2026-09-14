import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_athkar/travel_athkar_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_athkar/travel_athkar_card.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/traveler_shell.dart';

/// جسم شاشة أذكار السفر: وضع صفحات أو وضع قائمة، وكلاهما على أرضية واحدة.
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
    final skin = AppSkin.of(context);
    final visibleItems = state.filteredItems;

    if (visibleItems.isEmpty) {
      return const TravelerNotice(
        icon: AppIcons.searchOff,
        message: 'لا توجد أذكار مطابقة لبحثك.',
      );
    }

    if (state.displayMode == AthkarDisplayMode.listView) {
      return ListView.builder(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
        itemCount: visibleItems.length,
        itemBuilder: (context, index) {
          final item = visibleItems[index];
          return TravelAthkarCard(
            item: item,
            current: state.repeatCounts[item.key] ?? 0,
            showDivider: index != visibleItems.length - 1,
          );
        },
      );
    }

    final safeIndex = state.currentPageIndex >= visibleItems.length
        ? visibleItems.length - 1
        : state.currentPageIndex;

    // صفحة واحدة بعرض الشاشة كاملًا: لا حافة بطاقة تطلّ من الجانب، والفاصل
    // الوحيد هو عدّاد الصفحات أسفل الشاشة.
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
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  initialPage: safeIndex,
                  onPageChanged: (value, _) {
                    context
                        .read<TravelAthkarBloc>()
                        .add(UpdatePageIndexEvent(value));
                  },
                ),
                itemBuilder: (context, index, _) {
                  final item = visibleItems[index];
                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
                    child: TravelAthkarCard(
                      item: item,
                      current: state.repeatCounts[item.key] ?? 0,
                    ),
                  );
                },
              );
            },
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: skin.hairline)),
          ),
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Text(
            'الذكر ${safeIndex + 1} من ${visibleItems.length}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.78),
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}
