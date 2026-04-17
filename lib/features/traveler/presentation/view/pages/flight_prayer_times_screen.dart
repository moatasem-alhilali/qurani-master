import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/traveler/data/models/flight_prayer_models.dart';
import 'package:quran_app/features/traveler/data/services/flight_prayer_service.dart';
import 'package:quran_app/features/traveler/presentation/bloc/flight_prayer/flight_prayer_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/flight_prayer/attempts_badge.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/flight_prayer/flight_edge_marker.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/flight_prayer/hint_tile.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/flight_prayer/prayer_marker.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/flight_prayer/round_map_button.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/flight_prayer/stat_pill.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/flight_prayer/timeline_prayer_card.dart';

class FlightPrayerTimesScreen extends StatelessWidget {
  const FlightPrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FlightPrayerBloc(FlightPrayerService()),
      child: const FlightPrayerTimesView(),
    );
  }
}

class FlightPrayerTimesView extends StatefulWidget {
  const FlightPrayerTimesView({super.key});

  @override
  State<FlightPrayerTimesView> createState() => _FlightPrayerTimesViewState();
}

class _FlightPrayerTimesViewState extends State<FlightPrayerTimesView> {
  static const List<String> _quickFlightNumbers = <String>[
    'EK202', 'MS985', 'SV153', 'QR116', 'GF167', 'TK93', 'BA130', 'AF663', 'LH637', 'KU412', 'WY684',
  ];

  final MapController _mapController = MapController();
  final TextEditingController _flightController = TextEditingController();

  double _mapZoom = 5.7;

  @override
  void dispose() {
    _flightController.dispose();
    super.dispose();
  }

  void _searchFlight(BuildContext context) {
    final rawValue = _flightController.text;
    context.read<FlightPrayerBloc>().add(SearchFlightEvent(rawValue));
  }

  void _focusRoute(FlightPrayerTimelineResult? result) {
    if (result == null || result.track.trackPoints.isEmpty) {
      return;
    }

    final points = result.track.trackPoints;
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

  Future<List<String>> _flightSuggestions(BuildContext context, String query) async {
    final normalized = FlightPrayerService.normalizeFlightNumber(query);
    final bloc = context.read<FlightPrayerBloc>();
    final result = bloc.lastResult;
    
    final source = <String>{
      ..._quickFlightNumbers,
      if (result != null) result.track.flightNumber,
    }.toList()
      ..sort();

    if (normalized.isEmpty) {
      return source.take(8).toList();
    }

    final filtered = source
        .where((item) => item.contains(normalized) || item.startsWith(normalized))
        .toList();

    if (filtered.isNotEmpty) {
      return filtered;
    }

    return <String>[normalized];
  }

  void _onFlightSuggestionSelected(BuildContext context, String flightNumber) {
    final normalized = FlightPrayerService.normalizeFlightNumber(flightNumber);
    _flightController.text = normalized;
    _flightController.selection = TextSelection.collapsed(offset: normalized.length);
    _searchFlight(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FlightPrayerBloc, FlightPrayerState>(
      listener: (context, state) {
        if (state is FlightPrayerSuccess) {
          _focusRoute(state.result);
        }
      },
      child: AppScaffoldWidget(
        title: 'مواقيت الصلاة أثناء الطيران',
        showLargeHeader: false,
        initialOffset: null,
        trailing: GenericSearchAnchorAsync<String>(
          hintText: 'بحث برقم الرحلة',
          asyncSuggestions: (query) => _flightSuggestions(context, query),
          onSelected: (item) => _onFlightSuggestionSelected(context, item),
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
      ),
    );
  }

  Widget _buildTopHud(BuildContext context) {
    return BlocBuilder<FlightPrayerBloc, FlightPrayerState>(
      builder: (context, state) {
        final timeline = state is FlightPrayerSuccess ? state.result : context.read<FlightPrayerBloc>().lastResult;

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
      },
    );
  }

  Widget _buildMap(BuildContext context) {
    return BlocBuilder<FlightPrayerBloc, FlightPrayerState>(
      builder: (context, state) {
        final timeline = state is FlightPrayerSuccess ? state.result : context.read<FlightPrayerBloc>().lastResult;
        const fallbackCenter = LatLng(24.7136, 46.6753);

        final polylinePoints = timeline == null
            ? const <LatLng>[]
            : timeline.track.trackPoints
                .map((point) => LatLng(point.latitude, point.longitude))
                .toList();

        final center = polylinePoints.isEmpty ? fallbackCenter : polylinePoints.first;

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
      },
    );
  }

  Widget _buildMapControls(BuildContext context) {
    return Column(
      children: [
        RoundMapButton(
          icon: Icons.route_rounded,
          onTap: () => _focusRoute(context.read<FlightPrayerBloc>().lastResult),
        ),
        SizedBox(height: 8.h),
        RoundMapButton(
          icon: Icons.add_rounded,
          onTap: _zoomIn,
        ),
        SizedBox(height: 8.h),
        RoundMapButton(
          icon: Icons.remove_rounded,
          onTap: _zoomOut,
        ),
      ],
    );
  }

  Widget _buildCommandPanel(BuildContext context) {
    return BlocBuilder<FlightPrayerBloc, FlightPrayerState>(
      builder: (context, state) {
        final isSearching = state is FlightPrayerLoading;
        String? errorMessage;
        if (state is FlightPrayerFailure) {
          errorMessage = state.errorMessage;
        }

        final timeline = state is FlightPrayerSuccess ? state.result : context.read<FlightPrayerBloc>().lastResult;
        final hasResult = timeline != null;

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
                  AttemptsBadge(
                    value: state.remainingAttempts,
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
                      onSubmitted: (_) => _searchFlight(context),
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
                      onPressed: isSearching ? null : () => _searchFlight(context),
                      icon: isSearching
                          ? SizedBox(
                              width: 15.w,
                              height: 15.w,
                              child: const CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.search_rounded),
                      label: const Text('تشغيل'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              if (errorMessage != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    errorMessage,
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
                _buildJourneyStats(context, timeline),
                SizedBox(height: 8.h),
                _buildPrayerTimeline(context, timeline),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildJourneyStats(BuildContext context, FlightPrayerTimelineResult timeline) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        StatPill(
          label: 'الرحلة',
          value: timeline.track.flightNumber,
          color: context.primaryColor,
        ),
        StatPill(
          label: 'من',
          value: timeline.track.originLabel,
          color: context.onSurfaceColor,
        ),
        StatPill(
          label: 'إلى',
          value: timeline.track.destinationLabel,
          color: context.onSurfaceColor,
        ),
        StatPill(
          label: 'المصدر',
          value: timeline.track.sourceLabel,
          color: context.primaryColor,
        ),
      ],
    );
  }

  Widget _buildPrayerTimeline(BuildContext context, FlightPrayerTimelineResult timeline) {
    final events = timeline.prayerEvents;

    if (events.isEmpty) {
      return const HintTile(
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
          return TimelinePrayerCard(
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
