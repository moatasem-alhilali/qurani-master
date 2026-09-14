import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/traveler/data/models/traveler_place.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_places/travel_places_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_places/travel_places_list_items.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/traveler_shell.dart';

/// قائمة الأماكن المنزلقة أسفل الخريطة.
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
    final skin = AppSkin.of(context);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: skin.hairline)),
          ),
          padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 10.h),
          child: Row(
            children: [
              const TravelerIconChip(icon: AppIcons.list),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'أقرب الأماكن',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: skin.ink,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      'وجدنا ${state.places.length} نتيجة قربك',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: skin.inkSoft.withValues(alpha: 0.78),
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              if (state.isLoadingPlaces)
                SizedBox(
                  width: 15.sp,
                  height: 15.sp,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.8,
                    valueColor: AlwaysStoppedAnimation<Color>(skin.accent),
                  ),
                ),
            ],
          ),
        ),
        TravelPlacesListItems(state: state, placeType: placeType),
      ],
    );
  }
}
