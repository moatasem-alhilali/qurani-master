import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/traveler/data/models/traveler_place.dart';
import 'package:quran_app/features/traveler/data/services/makkah_geo.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_places/travel_places_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_places/travel_places_error_view.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_places/travel_places_headline.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_places/travel_places_map_layer.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_places/travel_places_restricted_view.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_places/travel_places_row.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_places/travel_places_selected_card.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/travel_places/travel_places_top_controls.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/traveler_shell.dart';

/// الأماكن القريبة — قرارٌ أوّلًا، وخريطةٌ عند الطلب.
///
/// كانت خريطةً تملأ الشاشة وقائمةً تنزلق فوقها: بنية أي تطبيق خرائط. لكن
/// المسافر هنا لا يستكشف جغرافيا — عنده سؤال واحد: **أيّها؟** والقائمة
/// المرتّبة تجيب عنه أسرع من دبابيس متشابهة على خريطة.
///
/// فصارت القائمة هي الصفحة، والخريطة بمفتاحٍ في الرأس. ولم تُفقد ميزة:
/// النطاق والتحديث وإعادة التمركز والاتجاهات كلّها باقية.
class TravelPlacesMapScreen extends StatelessWidget {
  const TravelPlacesMapScreen({required this.placeType, super.key});

  final TravelerPlaceType placeType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TravelPlacesBloc(placeType: placeType),
      child: _TravelPlacesView(placeType: placeType),
    );
  }
}

class _TravelPlacesView extends StatefulWidget {
  const _TravelPlacesView({required this.placeType});

  final TravelerPlaceType placeType;

  @override
  State<_TravelPlacesView> createState() => _TravelPlacesViewState();
}

class _TravelPlacesViewState extends State<_TravelPlacesView> {
  final MapController _mapController = MapController();

  bool _showMap = false;

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

  void _selectPlace(TravelerPlace place) {
    context.read<TravelPlacesBloc>().add(SelectPlaceEvent(place));
    if (!_showMap) return;
    _moveMapTo(LatLng(place.latitude, place.longitude), 15.3);
  }

  @override
  Widget build(BuildContext context) {
    return TravelerScaffold(
      title: widget.placeType.title,
      actions: [
        TravelerIconAction(
          icon: _showMap ? AppIcons.sections : AppIcons.mapPin,
          tooltip: _showMap ? 'عرض القائمة' : 'عرض الخريطة',
          active: _showMap,
          onTap: () => setState(() => _showMap = !_showMap),
        ),
      ],
      child: BlocConsumer<TravelPlacesBloc, TravelPlacesState>(
        listenWhen: (previous, current) =>
            previous.selectedPlace != current.selectedPlace ||
            previous.places != current.places,
        listener: (context, state) {
          if (!_showMap) return;
          final target = state.selectedPlace;
          if (target != null) {
            _moveMapTo(LatLng(target.latitude, target.longitude), 15.3);
            return;
          }
          final origin = state.locationContext;
          if (origin == null) return;
          _moveMapTo(
            LatLng(origin.latitude, origin.longitude),
            _zoomForRadius(state.radiusMeters),
          );
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

          if (_showMap) return _buildMap(state);
          return _buildList(state);
        },
      ),
    );
  }

  Widget _buildMap(TravelPlacesState state) {
    return Stack(
      children: [
        Positioned.fill(
          child: TravelPlacesMapLayer(
            state: state,
            mapController: _mapController,
            zoomForRadius: _zoomForRadius(state.radiusMeters),
          ),
        ),
        PositionedDirectional(
          top: 8.h,
          start: 12.w,
          end: 12.w,
          child: TravelPlacesTopControls(
            state: state,
            placeType: widget.placeType,
            onMoveToLocation: () {
              final origin = state.locationContext;
              if (origin == null) return;
              _moveMapTo(
                LatLng(origin.latitude, origin.longitude),
                _zoomForRadius(state.radiusMeters),
              );
            },
          ),
        ),
        if (state.selectedPlace != null)
          PositionedDirectional(
            start: 12.w,
            end: 12.w,
            bottom: 16.h,
            child: TravelPlacesSelectedCard(selected: state.selectedPlace!),
          ),
      ],
    );
  }

  Widget _buildList(TravelPlacesState state) {
    final skin = AppSkin.of(context);
    final origin = state.locationContext!;
    // النتائج تأتي مرتّبة بالمسافة من الخدمة، فالأوّل هو الأقرب.
    final places = state.places;

    return ListView(
      padding: EdgeInsets.only(bottom: 28.h),
      children: [
        if (places.isNotEmpty)
          TravelPlacesHeadline(
            place: places.first,
            placeType: widget.placeType,
          ),
        _RadiusBar(state: state),
        if (state.isLoadingPlaces)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 34.h),
            child: const Center(child: CircularProgressIndicator()),
          )
        else if (places.isEmpty)
          TravelerNotice(
            icon: AppIcons.searchOff,
            message: widget.placeType.emptyMessage,
            actionLabel: 'وسّع النطاق',
            onAction: () => context
                .read<TravelPlacesBloc>()
                .add(ChangeRadiusEvent(_nextRadius(state.radiusMeters))),
          )
        else ...[
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 4.h),
            child: Text(
              'كلّها ضمن ${_radiusLabel(state.radiusMeters)} — والسهم يشير إلى جهة كلٍّ منها.',
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.65),
                fontSize: 9.sp,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
          for (var i = 0; i < places.length; i++)
            TravelPlacesRow(
              place: places[i],
              bearingDegrees: GeoBearing.between(
                fromLatitude: origin.latitude,
                fromLongitude: origin.longitude,
                toLatitude: places[i].latitude,
                toLongitude: places[i].longitude,
              ),
              isSelected: state.selectedPlace?.id == places[i].id,
              showDivider: i != places.length - 1,
              onTap: () => _selectPlace(places[i]),
            ),
        ],
      ],
    );
  }

  static int _nextRadius(int current) {
    if (current < 3000) return 3000;
    if (current < 5000) return 5000;
    return 10000;
  }

  static String _radiusLabel(int meters) =>
      meters < 1000 ? '$meters م' : '${meters ~/ 1000} كم';
}

/// شريط نطاق البحث. كان يطفو فوق الخريطة وحدها، فصار في مسار القراءة.
class _RadiusBar extends StatelessWidget {
  const _RadiusBar({required this.state});

  final TravelPlacesState state;

  static const _options = <int>[1000, 3000, 5000, 10000];

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 2.h),
      child: Row(
        children: [
          Text(
            'النطاق',
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.7),
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          SizedBox(width: 10.w),
          for (final radius in _options) ...[
            _RadiusChip(
              label: _TravelPlacesViewState._radiusLabel(radius),
              isSelected: state.radiusMeters == radius,
              onTap: state.isLoadingPlaces || state.radiusMeters == radius
                  ? null
                  : () => context
                      .read<TravelPlacesBloc>()
                      .add(ChangeRadiusEvent(radius)),
            ),
            if (radius != _options.last) SizedBox(width: 6.w),
          ],
          const Spacer(),
          TravelerIconAction(
            icon: AppIcons.refresh,
            tooltip: 'تحديث',
            onTap: () => state.isLoadingPlaces
                ? null
                : context.read<TravelPlacesBloc>().add(LoadNearbyPlacesEvent()),
          ),
        ],
      ),
    );
  }
}

class _RadiusChip extends StatelessWidget {
  const _RadiusChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? skin.iconChip : null,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: isSelected ? Colors.transparent : skin.hairline,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? skin.accent : skin.inkSoft,
            fontSize: 9.5.sp,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            height: 1.3,
          ),
        ),
      ),
    );
  }
}
