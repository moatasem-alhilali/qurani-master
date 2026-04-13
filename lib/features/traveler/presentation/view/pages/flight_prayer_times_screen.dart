import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/traveler/data/models/flight_prayer_models.dart';
import 'package:quran_app/features/traveler/data/services/flight_prayer_service.dart';

class FlightPrayerTimesScreen extends StatefulWidget {
  const FlightPrayerTimesScreen({super.key});

  @override
  State<FlightPrayerTimesScreen> createState() =>
      _FlightPrayerTimesScreenState();
}

class _FlightPrayerTimesScreenState extends State<FlightPrayerTimesScreen> {
  static const List<String> _quickFlightNumbers = <String>[
    'EK202',
    'MS985',
    'SV153',
    'QR116',
    'GF167',
    'TK93',
    'BA130',
    'AF663',
    'LH637',
    'KU412',
    'WY684',
  ];

  final FlightPrayerService _service = FlightPrayerService();
  final MapController _mapController = MapController();
  final TextEditingController _flightController = TextEditingController();

  FlightPrayerTimelineResult? _result;
  bool _isSearching = false;
  String? _errorMessage;
  int _remainingAttempts = 10;
  double _mapZoom = 5.7;

  @override
  void dispose() {
    _flightController.dispose();
    super.dispose();
  }

  Future<void> _searchFlight() async {
    final rawValue = _flightController.text;
    final normalized = FlightPrayerService.normalizeFlightNumber(rawValue);

    if (_remainingAttempts <= 0) {
      setState(() {
        _errorMessage = 'انتهت المحاولات. أعد فتح الصفحة للمحاولة مجددًا.';
      });
      return;
    }

    try {
      FlightPrayerService.validateFlightNumberOrThrow(normalized);
    } on FormatException {
      setState(() {
        _remainingAttempts = _remainingAttempts - 1;
        _errorMessage = 'رقم الرحلة غير صحيح. مثال: EK202 أو MS985';
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _errorMessage = null;
    });

    try {
      final timeline = await _service.buildTimeline(flightNumber: normalized);
      if (!mounted) {
        return;
      }

      setState(() {
        _result = timeline;
        _isSearching = false;
      });

      _focusRoute();
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSearching = false;
        _remainingAttempts = _remainingAttempts - 1;
        _errorMessage = 'تعذر جلب بيانات الرحلة حاليًا.';
      });
    }
  }

  void _focusRoute() {
    final timeline = _result;
    if (timeline == null || timeline.track.trackPoints.isEmpty) {
      return;
    }

    final points = timeline.track.trackPoints;
    final mid = points[points.length ~/ 2];

    _mapZoom = 5.7;
    _moveMapTo(
      LatLng(mid.latitude, mid.longitude),
      _mapZoom,
    );
  }

  void _moveMapTo(LatLng center, double zoom) {
    try {
      _mapController.move(center, zoom);
    } catch (_) {}
  }

  void _zoomIn() {
    final center = _mapController.camera.center;
    _mapZoom = (_mapZoom + 0.8).clamp(3, 14);
    _moveMapTo(center, _mapZoom);
  }

  void _zoomOut() {
    final center = _mapController.camera.center;
    _mapZoom = (_mapZoom - 0.8).clamp(3, 14);
    _moveMapTo(center, _mapZoom);
  }

  Future<List<String>> _flightSuggestions(String query) async {
    final normalized = FlightPrayerService.normalizeFlightNumber(query);
    final source = <String>{
      ..._quickFlightNumbers,
      if (_result != null) _result!.track.flightNumber,
    }.toList()
      ..sort();

    if (normalized.isEmpty) {
      return source.take(8).toList();
    }

    final filtered = source
        .where(
          (item) => item.contains(normalized) || item.startsWith(normalized),
        )
        .toList();

    if (filtered.isNotEmpty) {
      return filtered;
    }

    return <String>[normalized];
  }

  void _onFlightSuggestionSelected(String flightNumber) {
    final normalized = FlightPrayerService.normalizeFlightNumber(flightNumber);
    _flightController.text = normalized;
    _flightController.selection =
        TextSelection.collapsed(offset: normalized.length);
    _searchFlight();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      title: 'مواقيت الصلاة أثناء الطيران',
      showLargeHeader: false,
      initialOffset: null,
      trailing: GenericSearchAnchorAsync<String>(
        hintText: 'بحث برقم الرحلة',
        asyncSuggestions: _flightSuggestions,
        onSelected: _onFlightSuggestionSelected,
        suggestionBuilder: (context, item) {
          return ListTile(
            leading: Icon(
              Icons.flight_rounded,
              color: context.primaryColor,
            ),
            title: Text(
              item,
              style: TextStyle(
                color: context.onSurfaceColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: Text(
              'تشغيل البحث الآن',
              style: TextStyle(
                color: context.onSurfaceColor.withValues(alpha: 0.62),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Stack(
            children: [
              Positioned.fill(
                child: _buildMap(context),
              ),
              Positioned(
                top: 10.h,
                left: 12.w,
                right: 12.w,
                child: _buildTopHud(context),
              ),
              Positioned(
                right: 12.w,
                top: 148.h,
                child: _buildMapControls(context),
              ),
              Positioned(
                left: 12.w,
                right: 12.w,
                bottom: 12.h,
                child: _buildCommandPanel(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopHud(BuildContext context) {
    final timeline = _result;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            context.primaryColor.withValues(alpha: 0.92),
            context.primaryColor.withValues(alpha: 0.72),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withValues(alpha: 0.24),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.flight_takeoff_rounded,
            color: Colors.white,
            size: 18.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timeline == null
                      ? 'اكتب رقم الرحلة أو استخدم زر البحث العلوي'
                      : 'الرحلة: ${timeline.track.flightNumber}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.6.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  timeline == null
                      ? 'تحليل المواقيت على طول مسار الرحلة'
                      : '${timeline.track.originLabel} ⟶ '
                          '${timeline.track.destinationLabel}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.88),
                    fontSize: 11.2.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (timeline != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Text(
                '${timeline.prayerEvents.length} مواقيت',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.8.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    final timeline = _result;
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
            child: _FlightEdgeMarker(
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
            child: const _FlightEdgeMarker(
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
            child: _PrayerMarker(
              text: prayer.shortName,
              onTap: () {
                _moveMapTo(
                  LatLng(prayer.latitude, prayer.longitude),
                  7.2,
                );
              },
            ),
          ),
        );
      }
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: center,
        initialZoom: _mapZoom,
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
  }

  Widget _buildMapControls(BuildContext context) {
    return Column(
      children: [
        _RoundMapButton(
          icon: Icons.route_rounded,
          onTap: _focusRoute,
        ),
        SizedBox(height: 8.h),
        _RoundMapButton(
          icon: Icons.add_rounded,
          onTap: _zoomIn,
        ),
        SizedBox(height: 8.h),
        _RoundMapButton(
          icon: Icons.remove_rounded,
          onTap: _zoomOut,
        ),
      ],
    );
  }

  Widget _buildCommandPanel(BuildContext context) {
    final hasResult = _result != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(
        color: context.scaffoldBackgroundColor.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: context.outlineVariant.withValues(alpha: 0.34),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.flight_rounded,
                color: context.primaryColor,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'محرك الرحلات والمواقيت',
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _AttemptsBadge(
                value: _remainingAttempts,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _flightController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _searchFlight(),
                  decoration: InputDecoration(
                    hintText: 'رقم الرحلة (مثال: EK202)',
                    filled: true,
                    fillColor: context.surfaceColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              SizedBox(
                height: 52.h,
                child: FilledButton.tonalIcon(
                  onPressed: _isSearching ? null : _searchFlight,
                  icon: _isSearching
                      ? SizedBox(
                          width: 15.w,
                          height: 15.w,
                          child:
                              const CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.search_rounded),
                  label: const Text('تشغيل'),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          if (_errorMessage != null)
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                _errorMessage!,
                style: TextStyle(
                  color: context.errorColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'أدخل رقم الرحلة لتحليل المواقيت على طول المسار.',
                style: TextStyle(
                  color: context.onSurfaceColor.withValues(alpha: 0.65),
                  fontSize: 11.8.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (hasResult) ...[
            SizedBox(height: 10.h),
            _buildJourneyStats(context),
            SizedBox(height: 8.h),
            _buildPrayerTimeline(context),
          ],
        ],
      ),
    );
  }

  Widget _buildJourneyStats(BuildContext context) {
    final timeline = _result!;

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        _StatPill(
          label: 'الرحلة',
          value: timeline.track.flightNumber,
          color: context.primaryColor,
        ),
        _StatPill(
          label: 'من',
          value: timeline.track.originLabel,
          color: context.onSurfaceColor,
        ),
        _StatPill(
          label: 'إلى',
          value: timeline.track.destinationLabel,
          color: context.onSurfaceColor,
        ),
        _StatPill(
          label: 'المصدر',
          value: timeline.track.sourceLabel,
          color: context.primaryColor,
        ),
      ],
    );
  }

  Widget _buildPrayerTimeline(BuildContext context) {
    final events = _result!.prayerEvents;

    if (events.isEmpty) {
      return const _HintTile(
        icon: Icons.info_outline_rounded,
        text: 'لم تظهر مواقيت ضمن مدة هذه الرحلة.',
      );
    }

    return SizedBox(
      height: 106.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final event = events[index];
          return _TimelinePrayerCard(
            event: event,
            localTime: _formatLocal(event.eventLocal),
            utcTime: _formatUtc(event.eventUtc),
            onTap: () {
              _moveMapTo(
                LatLng(event.latitude, event.longitude),
                7.3,
              );
            },
          );
        },
      ),
    );
  }

  String _formatLocal(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  String _formatUtc(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime.toUtc());
  }
}

class _FlightEdgeMarker extends StatelessWidget {
  const _FlightEdgeMarker({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.42),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 18.sp,
      ),
    );
  }
}

class _RoundMapButton extends StatelessWidget {
  const _RoundMapButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.scaffoldBackgroundColor.withValues(alpha: 0.94),
        shape: BoxShape.circle,
        border: Border.all(
          color: context.outlineVariant.withValues(alpha: 0.38),
        ),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon),
      ),
    );
  }
}

class _PrayerMarker extends StatelessWidget {
  const _PrayerMarker({
    required this.text,
    required this.onTap,
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.scaffoldBackgroundColor.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: context.primaryColor.withValues(alpha: 0.7),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: context.primaryColor,
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _AttemptsBadge extends StatelessWidget {
  const _AttemptsBadge({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        'المحاولات: $value',
        style: TextStyle(
          color: context.primaryColor,
          fontSize: 11.2.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _HintTile extends StatelessWidget {
  const _HintTile({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: context.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: context.primaryColor, size: 18.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: context.onSurfaceColor.withValues(alpha: 0.75),
                fontSize: 12.2.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 220.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        '$label: $value',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 11.2.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TimelinePrayerCard extends StatelessWidget {
  const _TimelinePrayerCard({
    required this.event,
    required this.localTime,
    required this.utcTime,
    required this.onTap,
  });

  final FlightPrayerEvent event;
  final String localTime;
  final String utcTime;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final sign = event.utcOffsetMinutes >= 0 ? '+' : '-';
    final offsetHours = (event.utcOffsetMinutes.abs() / 60).toStringAsFixed(1);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        width: 166.w,
        padding: EdgeInsets.all(9.sp),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: context.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.prayerNameAr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: context.onSurfaceColor,
                fontSize: 13.2.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              '$localTime محلي',
              style: TextStyle(
                color: context.primaryColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              '$utcTime UTC$sign$offsetHours',
              style: TextStyle(
                color: context.onSurfaceColor.withValues(alpha: 0.65),
                fontSize: 11.3.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
