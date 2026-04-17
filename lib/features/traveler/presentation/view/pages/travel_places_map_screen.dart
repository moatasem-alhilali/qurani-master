import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/package/flutter_sliding_box.dart';
import 'package:quran_app/features/traveler/data/models/traveler_place.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_places/travel_places_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_places/travel_places_bottom_sheet.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_places/travel_places_error_view.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_places/travel_places_map_layer.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_places/travel_places_restricted_view.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_places/travel_places_selected_card.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_places/travel_places_top_controls.dart';

class TravelPlacesMapScreen extends StatelessWidget {
  const TravelPlacesMapScreen({
    required this.placeType,
    super.key,
  });

  final TravelerPlaceType placeType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TravelPlacesBloc(placeType: placeType),
      child: _TravelPlacesMapOrchestrator(placeType: placeType),
    );
  }
}

class _TravelPlacesMapOrchestrator extends StatefulWidget {
  const _TravelPlacesMapOrchestrator({required this.placeType});
  
  final TravelerPlaceType placeType;

  @override
  State<_TravelPlacesMapOrchestrator> createState() => _TravelPlacesMapOrchestratorState();
}

class _TravelPlacesMapOrchestratorState extends State<_TravelPlacesMapOrchestrator> {
  final MapController _mapController = MapController();

  void _moveMapTo(LatLng center, double zoom) {
    try {
      _mapController.move(center, zoom);
    } catch (_) {}
  }

  double _zoomForRadius(int radiusMeters) {
    if (radiusMeters <= 1000) return 14.9;
    if (radiusMeters <= 3000) return 13.8;
    if (radiusMeters <= 5000) return 13;
    return 12.1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.placeType.title),
      ),
      body: SafeArea(
        child: BlocConsumer<TravelPlacesBloc, TravelPlacesState>(
          listenWhen: (previous, current) =>
              previous.selectedPlace != current.selectedPlace ||
              previous.places != current.places,
          listener: (context, state) {
            final target = state.selectedPlace;
            if (target != null) {
              _moveMapTo(
                LatLng(target.latitude, target.longitude),
                15.3,
              );
            } else if (state.locationContext != null) {
              _moveMapTo(
                LatLng(state.locationContext!.latitude,
                    state.locationContext!.longitude),
                _zoomForRadius(state.radiusMeters),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoadingLocation) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.isRestrictedForCountry) {
              return const TravelPlacesRestrictedView();
            }

            if (state.locationContext == null) {
              return const TravelPlacesErrorView();
            }

            return SlidingBox(
              minHeight: state.places.isEmpty ? 60.h : 90.h,
              maxHeight: MediaQuery.of(context).size.height * 0.58,
              color: context.scaffoldBackgroundColor.withValues(alpha: 0.96),
              style: BoxStyle.shadow,
              body: TravelPlacesListSheet(
                state: state,
                placeType: widget.placeType,
              ),
              backdrop: Backdrop(
                body: Stack(
                  children: [
                    Positioned.fill(
                      child: TravelPlacesMapLayer(
                        state: state,
                        mapController: _mapController,
                        zoomForRadius: _zoomForRadius(state.radiusMeters),
                      ),
                    ),
                    Positioned(
                      top: 10.h,
                      left: 10.w,
                      right: 10.w,
                      child: TravelPlacesTopControls(
                        state: state,
                        placeType: widget.placeType,
                        onMoveToLocation: () {
                          final current = state.locationContext;
                          if (current == null) return;
                          _moveMapTo(
                            LatLng(current.latitude, current.longitude),
                            _zoomForRadius(state.radiusMeters),
                          );
                        },
                      ),
                    ),
                    if (state.selectedPlace != null)
                      Positioned(
                        left: 10.w,
                        right: 10.w,
                        bottom: 120.h,
                        child: TravelPlacesSelectedCard(
                          selected: state.selectedPlace!,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
