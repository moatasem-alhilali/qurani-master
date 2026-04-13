import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/url_launcher_utils.dart';
import 'package:quran_app/features/traveler/data/models/traveler_place.dart';
import 'package:quran_app/features/traveler/data/services/traveler_country_policy.dart';
import 'package:quran_app/features/traveler/data/services/traveler_places_service.dart';

class TravelPlacesMapScreen extends StatefulWidget {
  const TravelPlacesMapScreen({
    required this.placeType,
    super.key,
  });

  final TravelerPlaceType placeType;

  @override
  State<TravelPlacesMapScreen> createState() => _TravelPlacesMapScreenState();
}

class _TravelPlacesMapScreenState extends State<TravelPlacesMapScreen> {
  final MapController _mapController = MapController();

  static const List<int> _radiusOptions = [1000, 3000, 5000, 10000];

  TravelerLocationContext? _locationContext;
  List<TravelerPlace> _places = const [];
  TravelerPlace? _selectedPlace;

  bool _isLoadingLocation = true;
  bool _isLoadingPlaces = false;
  bool _isRestrictedForCountry = false;
  String? _errorMessage;

  late int _radiusMeters;

  @override
  void initState() {
    super.initState();
    _radiusMeters = widget.placeType == TravelerPlaceType.mosque ? 3000 : 5000;
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    setState(() {
      _isLoadingLocation = true;
      _isRestrictedForCountry = false;
      _errorMessage = null;
    });

    final hasAccess = await _ensureLocationAccess();
    if (!hasAccess) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoadingLocation = false;
      });
      return;
    }

    try {
      final location = await TravelerPlacesService.resolveCurrentLocation();
      if (!mounted) {
        return;
      }

      final restricted = widget.placeType ==
              TravelerPlaceType.halalRestaurant &&
          TravelerCountryPolicy.isIslamicCountryCode(location.isoCountryCode);

      setState(() {
        _locationContext = location;
        _isRestrictedForCountry = restricted;
        _isLoadingLocation = false;
      });

      if (restricted) {
        return;
      }

      await _loadNearbyPlaces();
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoadingLocation = false;
        _errorMessage = 'تعذر تحديد موقعك الحالي. حاول مرة أخرى.';
      });
    }
  }

  Future<bool> _ensureLocationAccess() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        setState(() {
          _errorMessage =
              'خدمة الموقع غير مفعلة. فعّلها لإظهار النتائج القريبة.';
        });
      }
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      if (mounted) {
        setState(() {
          _errorMessage = 'يجب منح صلاحية الموقع حتى تعمل هذه الميزة.';
        });
      }
      return false;
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        setState(() {
          _errorMessage = 'تم رفض صلاحية الموقع نهائيًا. افتح إعدادات التطبيق.';
        });
      }
      return false;
    }

    return true;
  }

  Future<void> _loadNearbyPlaces() async {
    final location = _locationContext;
    if (location == null) {
      return;
    }

    setState(() {
      _isLoadingPlaces = true;
      _errorMessage = null;
    });

    try {
      final places = await TravelerPlacesService.fetchNearbyPlaces(
        placeType: widget.placeType,
        latitude: location.latitude,
        longitude: location.longitude,
        radiusMeters: _radiusMeters,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _places = places;
        _selectedPlace = places.isEmpty ? null : places.first;
        _isLoadingPlaces = false;
      });

      final target = _selectedPlace;
      if (target != null) {
        _moveMapTo(
          LatLng(target.latitude, target.longitude),
          15.3,
        );
      } else {
        _moveMapTo(
          LatLng(location.latitude, location.longitude),
          _zoomForRadius(),
        );
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoadingPlaces = false;
        _errorMessage = 'تعذر جلب النتائج القريبة الآن. حاول مجددًا.';
      });
    }
  }

  void _moveMapTo(LatLng center, double zoom) {
    try {
      _mapController.move(center, zoom);
    } catch (_) {}
  }

  double _zoomForRadius() {
    if (_radiusMeters <= 1000) {
      return 14.9;
    }
    if (_radiusMeters <= 3000) {
      return 13.8;
    }
    if (_radiusMeters <= 5000) {
      return 13;
    }
    return 12.1;
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

  Future<void> _openNearbySearch() async {
    final location = _locationContext;
    if (location == null) {
      return;
    }

    final query = Uri.encodeComponent(
      '${widget.placeType.queryLabel} near '
      '${location.latitude},${location.longitude}',
    );
    final url = 'https://www.google.com/maps/search/?api=1&query=$query';
    await _openUrl(url);
  }

  Future<void> _openUrl(String url) async {
    final launched = await UrlLauncherUtils.launchWebUrl(url);
    if (!mounted || launched) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('تعذر فتح الرابط الآن.'),
        ),
      );
  }

  Future<void> _openPhone(String phoneNumber) async {
    final launched = await UrlLauncherUtils.launchPhone(phoneNumber);
    if (!mounted || launched) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('تعذر فتح تطبيق الاتصال.'),
        ),
      );
  }

  void _onSelectPlace(TravelerPlace place) {
    setState(() {
      _selectedPlace = place;
    });
    _moveMapTo(LatLng(place.latitude, place.longitude), 15.3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.placeType.title),
      ),
      body: SafeArea(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoadingLocation) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_isRestrictedForCountry) {
      return _buildRestrictedView(context);
    }

    if (_locationContext == null) {
      return _buildErrorView(context);
    }

    return Stack(
      children: [
        Positioned.fill(
          child: _buildMap(context),
        ),
        Positioned(
          top: 10.h,
          left: 10.w,
          right: 10.w,
          child: _buildFloatingTopControls(context),
        ),
        if (_selectedPlace != null)
          Positioned(
            left: 10.w,
            right: 10.w,
            bottom: 96.h,
            child: _buildSelectedPlaceCard(context),
          ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _buildPlacesBottomSheet(context),
        ),
      ],
    );
  }

  Widget _buildFloatingTopControls(BuildContext context) {
    final location = _locationContext;
    final countLabel =
        _isLoadingPlaces ? 'جارِ التحديث...' : 'عدد النتائج: ${_places.length}';

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
                onPressed: _openNearbySearch,
                style: FilledButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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
                  onPressed: _isLoadingPlaces ? null : _loadNearbyPlaces,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('تحديث'),
                ),
                SizedBox(width: 8.w),
                FilledButton.tonalIcon(
                  onPressed: () {
                    final current = _locationContext;
                    if (current == null) {
                      return;
                    }
                    _moveMapTo(
                      LatLng(current.latitude, current.longitude),
                      _zoomForRadius(),
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
                      selected: _radiusMeters == radius,
                      onSelected: _isLoadingPlaces
                          ? null
                          : (selected) {
                              if (!selected || _radiusMeters == radius) {
                                return;
                              }
                              setState(() {
                                _radiusMeters = radius;
                              });
                              _loadNearbyPlaces();
                            },
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_errorMessage != null) ...[
            SizedBox(height: 8.h),
            Text(
              _errorMessage!,
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

  Widget _buildMap(BuildContext context) {
    final location = _locationContext;
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
      ..._places.map(
        (place) {
          final selected = _selectedPlace?.id == place.id;
          return Marker(
            point: LatLng(place.latitude, place.longitude),
            width: selected ? 50.w : 42.w,
            height: selected ? 50.w : 42.w,
            child: GestureDetector(
              onTap: () => _onSelectPlace(place),
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
              initialZoom: _zoomForRadius(),
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

  Widget _buildPlacesBottomSheet(BuildContext context) {
    final initialSize = _places.isEmpty ? 0.12 : 0.16;
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
                        'عرض القائمة (${_places.length})',
                        style: TextStyle(
                          color: context.onSurfaceColor,
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (_isLoadingPlaces)
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
                  scrollController: scrollController,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectedPlaceCard(BuildContext context) {
    final selected = _selectedPlace;
    if (selected == null) {
      return const SizedBox.shrink();
    }

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
    BuildContext context, {
    ScrollController? scrollController,
  }) {
    if (_isLoadingPlaces) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_places.isEmpty) {
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
      itemCount: _places.length,
      separatorBuilder: (_, __) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        final place = _places[index];
        final selected = _selectedPlace?.id == place.id;

        return InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () => _onSelectPlace(place),
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

  Widget _buildRestrictedView(BuildContext context) {
    final country = _locationContext?.countryName;

    return Padding(
      padding: EdgeInsets.all(16.sp),
      child: Center(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.sp),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: context.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 36.sp,
                color: context.primaryColor,
              ),
              SizedBox(height: 12.h),
              Text(
                'ميزة المطاعم الحلال مخصصة للدول غير الإسلامية.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.onSurfaceColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                country == null || country.trim().isEmpty
                    ? 'تم إيقاف هذه الصفحة وفق الدولة الحالية.'
                    : 'موقعك الحالي في $country لذلك تم إيقافها تلقائيًا.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.onSurfaceColor.withValues(alpha: 0.62),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 14.h),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) => const TravelPlacesMapScreen(
                          placeType: TravelerPlaceType.mosque,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.mosque_rounded),
                  label: const Text('عرض المساجد القريبة'),
                ),
              ),
              SizedBox(height: 8.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('رجوع'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.sp),
      child: Center(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.sp),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: context.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_off_rounded,
                size: 36.sp,
                color: context.errorColor,
              ),
              SizedBox(height: 12.h),
              Text(
                _errorMessage ?? 'تعذر الوصول للموقع الحالي.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.onSurfaceColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 14.h),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _bootstrap,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('إعادة المحاولة'),
                ),
              ),
              SizedBox(height: 8.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: Geolocator.openLocationSettings,
                  icon: const Icon(Icons.settings_rounded),
                  label: const Text('فتح إعدادات الموقع'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _radiusLabel(int radius) {
    if (radius < 1000) {
      return '$radius م';
    }
    return '${(radius / 1000).toStringAsFixed(radius % 1000 == 0 ? 0 : 1)} كم';
  }
}
