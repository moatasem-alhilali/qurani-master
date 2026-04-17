import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_places/travel_places_bloc.dart';

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
    final location = state.locationContext;
    final center = location == null
        ? const LatLng(15.3694, 44.1910)
        : LatLng(location.latitude, location.longitude);

    final markers = <Marker>[
      Marker(
        point: center,
        width: 30.w,
        height: 30.w,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.primaryColor,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      ),
      ...state.places.map(
        (place) {
          final selected = state.selectedPlace?.id == place.id;
          return Marker(
            point: LatLng(place.latitude, place.longitude),
            width: selected ? 50.w : 42.w,
            height: selected ? 50.w : 42.w,
            child: GestureDetector(
              onTap: () => context
                  .read<TravelPlacesBloc>()
                  .add(SelectPlaceEvent(place)),
              child: Icon(
                Icons.location_on_rounded,
                color: selected ? context.primaryColor : Colors.red,
                size: selected ? 46.sp : 38.sp,
              ),
            ),
          );
        },
      ),
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
        Positioned(
          top: 132.h,
          left: 12.w,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.scaffoldBackgroundColor.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
              child: Text(
                'اضغط على العلامة لعرض التفاصيل',
                style: TextStyle(
                  color: context.onSurfaceColor,
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
