import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_places/travel_places_bloc.dart';
import 'package:quran_app/l10n/l10n.dart';

class TravelPlacesMapLayer extends StatelessWidget {
  const TravelPlacesMapLayer({
    required this.state,
    required this.mapController,
    required this.zoomForRadius,
    super.key,
  });

  final TravelPlacesState state;
  final MapController mapController;
  final double zoomForRadius;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final location = state.locationContext;
    final center = location == null
        ? const LatLng(15.3694, 44.1910)
        : LatLng(location.latitude, location.longitude);

    final markers = <Marker>[
      Marker(
        point: center,
        width: 16.w,
        height: 16.w,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.gold,
            border: Border.all(color: skin.ground, width: 2),
          ),
        ),
      ),
      ...state.places.map((place) {
        final selected = state.selectedPlace?.id == place.id;
        return Marker(
          point: LatLng(place.latitude, place.longitude),
          width: selected ? 34.w : 28.w,
          height: selected ? 34.w : 28.w,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              context.read<TravelPlacesBloc>().add(SelectPlaceEvent(place));
            },
            // المختار قرص ذهبي مصمت، وغيره قرص من أرضية الصفحة بحلقة:
            // الفرق في الشكل لا في درجة اللون وحدها.
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? skin.accent : skin.ground,
                border: Border.all(color: skin.raisedBorder, width: 1.6),
              ),
              child: Center(
                child: AppIcon(
                  AppIcons.mapPin,
                  color: selected
                      ? (skin.isDark
                          ? AppColors.brandNight
                          : AppColors.brandIvory)
                      : skin.accent,
                  size: selected ? 16.sp : 14.sp,
                ),
              ),
            ),
          ),
        );
      }),
    ];

    return Stack(
      children: [
        Positioned.fill(
          child: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: center,
              initialZoom: zoomForRadius,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'quran_app',
              ),
              MarkerLayer(markers: markers),
            ],
          ),
        ),
        PositionedDirectional(
          top: 108.h,
          start: 12.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: skin.ground.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(color: skin.hairline),
            ),
            child: Text(
              context.l10n.travelerTapMarkerHint,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
