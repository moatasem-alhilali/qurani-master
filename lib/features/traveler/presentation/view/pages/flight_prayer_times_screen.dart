import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/generic_search_bar.dart';
import 'package:quran_app/features/traveler/data/services/flight_prayer_service.dart';
import 'package:quran_app/features/traveler/presentation/bloc/flight_prayer/flight_prayer_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/flight_prayer/flight_prayer_command_panel.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/flight_prayer/flight_prayer_hud.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/flight_prayer/flight_prayer_map_layer.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/traveler_shell.dart';

class FlightPrayerTimesScreen extends StatelessWidget {
  const FlightPrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FlightPrayerBloc(FlightPrayerService()),
      child: const _FlightPrayerTimesOrchestrator(),
    );
  }
}

class _FlightPrayerTimesOrchestrator extends StatefulWidget {
  const _FlightPrayerTimesOrchestrator();

  @override
  State<_FlightPrayerTimesOrchestrator> createState() =>
      _FlightPrayerTimesOrchestratorState();
}

class _FlightPrayerTimesOrchestratorState
    extends State<_FlightPrayerTimesOrchestrator> {
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

  void _focusRoute() {
    final result = context.read<FlightPrayerBloc>().lastResult;
    if (result == null || result.track.trackPoints.isEmpty) {
      return;
    }

    final points = result.track.trackPoints;
    final mid = points[points.length ~/ 2];

    _mapZoom = 5.7;
    _moveMapTo(LatLng(mid.latitude, mid.longitude), _mapZoom);
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

  Future<List<String>> _flightSuggestions(
    BuildContext context,
    String query,
  ) async {
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
        .where(
          (item) => item.contains(normalized) || item.startsWith(normalized),
        )
        .toList();

    if (filtered.isNotEmpty) {
      return filtered;
    }

    return <String>[normalized];
  }

  void _onFlightSuggestionSelected(BuildContext context, String flightNumber) {
    final normalized = FlightPrayerService.normalizeFlightNumber(flightNumber);
    _flightController.text = normalized;
    _flightController.selection =
        TextSelection.collapsed(offset: normalized.length);
    _searchFlight(context);
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocListener<FlightPrayerBloc, FlightPrayerState>(
      listener: (context, state) {
        if (state is FlightPrayerSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _focusRoute();
          });
        }
      },
      child: TravelerScaffold(
        title: 'مواقيت الصلاة أثناء الطيران',
        actions: [
          GenericSearchAnchorAsync<String>(
            hintText: 'بحث برقم الرحلة',
            asyncSuggestions: (query) => _flightSuggestions(context, query),
            onSelected: (item) => _onFlightSuggestionSelected(context, item),
            suggestionBuilder: (context, item) {
              return ListTile(
                leading: AppIcon(
                  AppIcons.flight,
                  color: skin.accent,
                  size: 17.sp,
                ),
                title: Text(
                  item,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  'تشغيل البحث الآن',
                  style: TextStyle(
                    color: skin.inkSoft.withValues(alpha: 0.78),
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ],
        // الخريطة ثابتة في أعلى الشاشة والمحتوى وحده هو الذي ينزلق: لو
        // وُضعت الخريطة داخل قائمة متحرّكة لتنازع السحبُ الرأسيُّ معها.
        child: Column(
          children: [
            Container(
              height: 186.h,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: FlightPrayerMapLayer(
                      mapController: _mapController,
                      zoom: _mapZoom,
                      onMoveMapTo: _moveMapTo,
                    ),
                  ),
                  PositionedDirectional(
                    end: 10.w,
                    top: 10.h,
                    child: FlightPrayerMapControls(
                      onFocusRoute: _focusRoute,
                      onZoomIn: _zoomIn,
                      onZoomOut: _zoomOut,
                    ),
                  ),
                ],
              ),
            ),
            const FlightPrayerHud(),
            Expanded(
              child: SingleChildScrollView(
                child: FlightPrayerCommandPanel(
                  controller: _flightController,
                  onSearch: () => _searchFlight(context),
                  onMoveMapTo: _moveMapTo,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
