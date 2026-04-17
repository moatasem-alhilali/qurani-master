import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:latlong2/latlong.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/url_launcher_utils.dart';
import 'package:quran_app/features/traveler/data/models/traveler_place.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_places/travel_places_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_places/travel_places_error_view.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_places/travel_places_restricted_view.dart';

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
      child: TravelPlacesMapView(placeType: placeType),
    );
  }
}

class TravelPlacesMapView extends StatefulWidget {
  const TravelPlacesMapView({required this.placeType, super.key});
  
  final TravelerPlaceType placeType;

  @override
  State<TravelPlacesMapView> createState() => _TravelPlacesMapViewState();
}

class _TravelPlacesMapViewState extends State<TravelPlacesMapView> {
  final MapController _mapController = MapController();
  static const List<int> _radiusOptions = [1000, 3000, 5000, 10000];

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

  String _radiusLabel(int meters) {
    if (meters >= 1000) {
      final km = meters / 1000;
      return '${km.toStringAsFixed(km.truncateToDouble() == km ? 0 : 1)} كم';
    }
    return '$meters م';
  }

  Future<void> _openDirections(TravelerPlace place) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=${place.latitude},${place.longitude}&travelmode=driving';
    await _openUrl(url);
  }

  Future<void> _openPlace(TravelerPlace place) async {
    final query = Uri.encodeComponent(
      '${place.name} ${place.latitude},${place.longitude}',
    );
    final url = 'https://www.google.com/maps/search/?api=1&query=$query';
    await _openUrl(url);
  }

  Future<void> _openNearbySearch(BuildContext context) async {
    final state = context.read<TravelPlacesBloc>().state;
    final location = state.locationContext;
    if (location == null) return;

    final query = Uri.encodeComponent(
      '${widget.placeType.queryLabel} near '
      '${location.latitude},${location.longitude}',
    );
    final url = 'https://www.google.com/maps/search/?api=1&query=$query';
    await _openUrl(url);
  }

  Future<void> _openUrl(String url) async {
    final launched = await UrlLauncherUtils.launchWebUrl(url);
    if (!mounted || launched) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('تعذر فتح الرابط الآن.')),
      );
  }

  Future<void> _openPhone(String phoneNumber) async {
    final launched = await UrlLauncherUtils.launchPhone(phoneNumber);
    if (!mounted || launched) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('تعذر فتح تطبيق الاتصال.')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.placeType.title),
      ),
      body: SafeArea(
        child: BlocConsumer<TravelPlacesBloc, TravelPlacesState>(
          listenWhen: (previous, current) => previous.selectedPlace != current.selectedPlace || previous.places != current.places,
          listener: (context, state) {
            final target = state.selectedPlace;
            if (target != null) {
              _moveMapTo(
                LatLng(target.latitude, target.longitude),
                15.3,
              );
            } else if (state.locationContext != null) {
              _moveMapTo(
                LatLng(state.locationContext!.latitude, state.locationContext!.longitude),
                _zoomForRadius(state.radiusMeters),
              );
            }
          },
          builder: (context, state) {
            return _buildBody(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, TravelPlacesState state) {
    if (state.isLoadingLocation) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.isRestrictedForCountry) {
      return const TravelPlacesRestrictedView();
    }

    if (state.locationContext == null) {
      return const TravelPlacesErrorView();
    }

    return Stack(
      children: [
        Positioned.fill(
          child: _buildMap(context, state),
        ),
        Positioned(
          top: 10.h,
          left: 10.w,
          right: 10.w,
          child: _buildFloatingTopControls(context, state),
        ),
        if (state.selectedPlace != null)
          Positioned(
            left: 10.w,
            right: 10.w,
            bottom: 96.h,
            child: _buildSelectedPlaceCard(context, state),
          ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _buildPlacesBottomSheet(context, state),
        ),
      ],
    );
  }
  
  Widget _buildFloatingTopControls(BuildContext context, TravelPlacesState state) {
    final location = state.locationContext;
    final countLabel = state.isLoadingPlaces ? 'جارِ التحديث...' : 'عدد النتائج: ${state.places.length}';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: context.scaffoldBackgroundColor.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: context.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  location?.label ?? 'موقعي الحالي',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              FilledButton(
                onPressed: () => _openNearbySearch(context),
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                ),
                child: const Text('فتح التطبيق'),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            countLabel,
            style: TextStyle(
              color: context.onSurfaceColor.withValues(alpha: 0.62),
              fontSize: 11.8.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilledButton.tonalIcon(
                  onPressed: state.isLoadingPlaces ? null : () => context.read<TravelPlacesBloc>().add(LoadNearbyPlacesEvent()),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('تحديث'),
                ),
                SizedBox(width: 8.w),
                FilledButton.tonalIcon(
                  onPressed: () {
                    final current = state.locationContext;
                    if (current == null) return;
                    _moveMapTo(
                      LatLng(current.latitude, current.longitude),
                      _zoomForRadius(state.radiusMeters),
                    );
                  },
                  icon: const Icon(Icons.my_location_rounded),
                  label: const Text('موقعي'),
                ),
                SizedBox(width: 8.w),
                ..._radiusOptions.map(
                  (radius) => Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: ChoiceChip(
                      label: Text(_radiusLabel(radius)),
                      selected: state.radiusMeters == radius,
                      onSelected: state.isLoadingPlaces
                          ? null
                          : (selected) {
                              if (!selected || state.radiusMeters == radius) return;
                              context.read<TravelPlacesBloc>().add(ChangeRadiusEvent(radius));
                            },
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (state.errorMessage != null) ...[
            SizedBox(height: 8.h),
            Text(
              state.errorMessage!,
              style: TextStyle(
                color: context.errorColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context, TravelPlacesState state) {
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
              onTap: () => context.read<TravelPlacesBloc>().add(SelectPlaceEvent(place)),
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
            mapController: _mapController,
            options: MapOptions(
              initialCenter: center,
              initialZoom: _zoomForRadius(state.radiusMeters),
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

  Widget _buildPlacesBottomSheet(BuildContext context, TravelPlacesState state) {
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
                child: _buildPlacesList(
                  context,
                  state,
                  scrollController: scrollController,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectedPlaceCard(BuildContext context, TravelPlacesState state) {
    final selected = state.selectedPlace;
    if (selected == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: context.scaffoldBackgroundColor.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: context.outlineVariant.withValues(alpha: 0.32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            selected.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.onSurfaceColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            '${selected.distanceLabel} • ${selected.walkingEtaLabel}',
            style: TextStyle(
              color: context.primaryColor,
              fontSize: 11.8.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            selected.address,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.onSurfaceColor.withValues(alpha: 0.65),
              fontSize: 11.8.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: [
              FilledButton(
                onPressed: () => _openDirections(selected),
                child: const Text('الاتجاه'),
              ),
              OutlinedButton(
                onPressed: () => _openPlace(selected),
                child: const Text('Google Maps'),
              ),
              if ((selected.phone ?? '').trim().isNotEmpty)
                OutlinedButton(
                  onPressed: () => _openPhone(selected.phone!),
                  child: const Text('اتصال'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlacesList(
    BuildContext context,
    TravelPlacesState state,
    {ScrollController? scrollController}
  ) {
    if (state.isLoadingPlaces) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.places.isEmpty) {
      return Center(
        child: Text(
          widget.placeType.emptyMessage,
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
          onTap: () => context.read<TravelPlacesBloc>().add(SelectPlaceEvent(place)),
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
                    widget.placeType == TravelerPlaceType.mosque
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
