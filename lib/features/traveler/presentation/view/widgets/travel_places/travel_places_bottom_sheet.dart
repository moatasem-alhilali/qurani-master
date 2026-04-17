import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/traveler/data/models/traveler_place.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_places/travel_places_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_places/travel_places_list_items.dart';

class TravelPlacesBottomSheet extends StatelessWidget {
  const TravelPlacesBottomSheet({
    required this.state,
    required this.placeType,
    super.key,
  });

  final TravelPlacesState state;
  final TravelerPlaceType placeType;

  @override
  Widget build(BuildContext context) {
    final initialSize = state.places.isEmpty ? 0.12 : 0.16;
    return DraggableScrollableSheet(
      initialChildSize: initialSize,
      minChildSize: 0.1,
      maxChildSize: 0.58,
      snap: true,
      snapSizes: const [0.1, 0.28, 0.58],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: context.scaffoldBackgroundColor.withValues(alpha: 0.96),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(22.r),
            ),
            border: Border.all(
              color: context.outlineVariant.withValues(alpha: 0.25),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 8.h),
              Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: context.outlineVariant.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(99.r),
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.list_alt_rounded,
                      color: context.primaryColor,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'عرض القائمة (${state.places.length})',
                        style: TextStyle(
                          color: context.onSurfaceColor,
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (state.isLoadingPlaces)
                      SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Divider(
                height: 1,
                color: context.outlineVariant.withValues(alpha: 0.3),
              ),
              Expanded(
                child: TravelPlacesListItems(
                  state: state,
                  placeType: placeType,
                  scrollController: scrollController,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
