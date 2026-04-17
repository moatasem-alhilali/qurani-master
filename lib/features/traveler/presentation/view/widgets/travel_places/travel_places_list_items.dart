import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/traveler/data/models/traveler_place.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_places/travel_places_bloc.dart';

class TravelPlacesListItems extends StatelessWidget {
  const TravelPlacesListItems({
    required this.state,
    required this.placeType,
    required this.scrollController,
    super.key,
  });

  final TravelPlacesState state;
  final TravelerPlaceType placeType;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingPlaces) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.places.isEmpty) {
      return Center(
        child: Text(
          placeType.emptyMessage,
          style: TextStyle(
            color: context.onSurfaceColor.withValues(alpha: 0.65),
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return ListView.separated(
      controller: scrollController,
      padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 20.h),
      itemCount: state.places.length,
      separatorBuilder: (_, __) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        final place = state.places[index];
        final selected = state.selectedPlace?.id == place.id;

        return InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () =>
              context.read<TravelPlacesBloc>().add(SelectPlaceEvent(place)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: selected
                  ? context.primaryColor.withValues(alpha: 0.1)
                  : context.surfaceColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: selected
                    ? context.primaryColor.withValues(alpha: 0.45)
                    : context.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 34.w,
                  height: 34.w,
                  decoration: BoxDecoration(
                    color: selected
                        ? context.primaryColor.withValues(alpha: 0.2)
                        : context.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    placeType == TravelerPlaceType.mosque
                        ? Icons.mosque_rounded
                        : Icons.restaurant_rounded,
                    color: context.primaryColor,
                    size: 18.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: context.onSurfaceColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        place.distanceLabel,
                        style: TextStyle(
                          color: context.primaryColor,
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        place.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: context.onSurfaceColor.withValues(alpha: 0.6),
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.chevron_left_rounded,
                  color: context.onSurfaceColor.withValues(alpha: 0.45),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
