import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/traveler/presentation/bloc/flight_prayer/flight_prayer_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/flight_prayer/flight_edge_marker.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/flight_prayer/prayer_marker.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/flight_prayer/round_map_button.dart';

class FlightPrayerMapLayer extends StatelessWidget {
  const FlightPrayerMapLayer({
    required this.mapController,
    required this.zoom,
    required this.onMoveMapTo,
    super.key,
  });

  final MapController mapController;
  final double zoom;
  final void Function(LatLng center, double zoom) onMoveMapTo;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlightPrayerBloc, FlightPrayerState>(
      builder: (context, state) {
        final timeline = state is FlightPrayerSuccess
            ? state.result
            : context.read<FlightPrayerBloc>().lastResult;
        const fallbackCenter = LatLng(24.7136, 46.6753);

        final polylinePoints = timeline == null
            ? const <LatLng>[]
            : timeline.track.trackPoints
                .map((point) => LatLng(point.latitude, point.longitude))
                .toList();

        final center =
            polylinePoints.isEmpty ? fallbackCenter : polylinePoints.first;

        final markers = <Marker>[];
        if (timeline != null && polylinePoints.isNotEmpty) {
          final start = timeline.track.trackPoints.first;
          final end = timeline.track.trackPoints.last;

          markers
            ..add(
              Marker(
                point: LatLng(start.latitude, start.longitude),
                width: 38.w,
                height: 38.w,
                child: FlightEdgeMarker(
                  icon: Icons.flight_takeoff_rounded,
                  color: context.primaryColor,
                ),
              ),
            )
            ..add(
              Marker(
                point: LatLng(end.latitude, end.longitude),
                width: 38.w,
                height: 38.w,
                child: const FlightEdgeMarker(
                  icon: Icons.flight_land_rounded,
                  color: Colors.red,
                ),
              ),
            );

          for (final prayer in timeline.prayerEvents) {
            markers.add(
              Marker(
                point: LatLng(prayer.latitude, prayer.longitude),
                width: 64.w,
                height: 34.h,
                child: PrayerMarker(
                  text: prayer.shortName,
                  onTap: () => onMoveMapTo(
                    LatLng(prayer.latitude, prayer.longitude),
                    7.2,
                  ),
                ),
              ),
            );
          }
        }

        return FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: center,
            initialZoom: zoom,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'quran_app',
            ),
            if (polylinePoints.isNotEmpty)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: polylinePoints,
                    color: context.primaryColor.withValues(alpha: 0.9),
                    strokeWidth: 4.2,
                  ),
                ],
              ),
            MarkerLayer(markers: markers),
          ],
        );
      },
    );
  }
}

class FlightPrayerMapControls extends StatelessWidget {
  const FlightPrayerMapControls({
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onFocusRoute,
    super.key,
  });

  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onFocusRoute;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoundMapButton(
          icon: Icons.route_rounded,
          onTap: onFocusRoute,
        ),
        SizedBox(height: 8.h),
        RoundMapButton(
          icon: Icons.add_rounded,
          onTap: onZoomIn,
        ),
        SizedBox(height: 8.h),
        RoundMapButton(
          icon: Icons.remove_rounded,
          onTap: onZoomOut,
        ),
      ],
    );
  }
}
