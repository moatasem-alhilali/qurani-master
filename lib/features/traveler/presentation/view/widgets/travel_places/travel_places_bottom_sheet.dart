import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/traveler/data/models/traveler_place.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_places/travel_places_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_places/travel_places_list_items.dart';

class TravelPlacesListSheet extends StatelessWidget {
  const TravelPlacesListSheet({
    required this.state,
    required this.placeType,
    super.key,
  });

  final TravelPlacesState state;
  final TravelerPlaceType placeType;

  @override
  Widget build(BuildContext context) {
    return Column(
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
        TravelPlacesListItems(
          state: state,
          placeType: placeType,
        ),
      ],
    );
  }
}
