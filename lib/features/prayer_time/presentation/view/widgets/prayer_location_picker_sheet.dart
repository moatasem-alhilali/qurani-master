import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_location_selection.dart';
import 'package:quran_app/features/prayer_time/data/service/prayer_location_resolver.dart';

class PrayerLocationPickerSheet extends StatefulWidget {
  const PrayerLocationPickerSheet({
    required this.onLocationSelected,
    required this.onUseCurrentLocation,
    super.key,
    this.initialLocation,
  });

  final PrayerLocationSelection? initialLocation;
  final Future<void> Function(PrayerLocationSelection selection)
      onLocationSelected;
  final Future<void> Function() onUseCurrentLocation;

  @override
  State<PrayerLocationPickerSheet> createState() =>
      _PrayerLocationPickerSheetState();
}

class _PrayerLocationPickerSheetState extends State<PrayerLocationPickerSheet>
    with SingleTickerProviderStateMixin {
  static const _fallbackCenter = LatLng(15.3694, 44.1910);

  final _searchController = TextEditingController();
  final _mapController = MapController();
  Timer? _debounce;

  List<PrayerLocationSelection> _searchResults = const [];
  PrayerLocationSelection? _selectedMapLocation;
  bool _isSearching = false;
  bool _isApplyingCurrentLocation = false;
  bool _isResolvingMapLocation = false;
  bool _isApplyingMapLocation = false;

  LatLng get _initialCenter {
    final initial = widget.initialLocation;
    if (initial == null) return _fallbackCenter;
    return LatLng(initial.latitude, initial.longitude);
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _selectedMapLocation = widget.initialLocation;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onSearchChanged(String value) async {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      final query = value.trim();
      if (query.isEmpty) {
        if (mounted) {
          setState(() {
            _searchResults = const [];
            _isSearching = false;
          });
        }
        return;
      }

      setState(() {
        _isSearching = true;
      });

      final results = await PrayerLocationResolver.searchByQuery(query);
      if (!mounted) return;

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    });
  }

  Future<void> _selectSearchResult(PrayerLocationSelection selection) async {
    await widget.onLocationSelected(selection);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectCurrentLocation() async {
    setState(() {
      _isApplyingCurrentLocation = true;
    });

    await widget.onUseCurrentLocation();

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _pickMapLocation(LatLng point) async {
    setState(() {
      _isResolvingMapLocation = true;
    });

    final selection = await PrayerLocationResolver.fromCoordinates(
      latitude: point.latitude,
      longitude: point.longitude,
      source: PrayerLocationSource.manualMap,
      fallbackLabel: 'موقع محدد على الخريطة',
    );

    if (!mounted) return;

    setState(() {
      _selectedMapLocation = selection;
      _isResolvingMapLocation = false;
    });
  }

  Future<void> _applyMapLocation() async {
    final selection = _selectedMapLocation;
    if (selection == null) return;

    setState(() {
      _isApplyingMapLocation = true;
    });

    await widget.onLocationSelected(selection);

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: DefaultTabController(
          length: 2,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(28.r),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Container(
                  width: 42.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: _alpha(context.outlineVariant, 0.55),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'اختيار المنطقة',
                              style: TextStyle(
                                color: context.onSurfaceColor,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              'ابحث عن مدينة أو حدّد نقطة مباشرة من الخريطة',
                              style: TextStyle(
                                color: _alpha(context.onSurfaceColor, 0.56),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 0),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _isApplyingCurrentLocation
                          ? null
                          : _selectCurrentLocation,
                      icon: const Icon(Icons.my_location_rounded),
                      label: Text(
                        _isApplyingCurrentLocation
                            ? 'جارِ استخدام موقع الجهاز...'
                            : 'استخدام موقع الجهاز الحالي',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.surfaceColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: TabBar(
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: _alpha(context.primaryColor, 0.16),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      labelColor: context.onSurfaceColor,
                      unselectedLabelColor:
                          _alpha(context.onSurfaceColor, 0.56),
                      tabs: const [
                        Tab(text: 'بحث'),
                        Tab(text: 'الخريطة'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildSearchTab(context),
                      _buildMapTab(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchTab(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 18.h),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'ابحث باسم المدينة أو المحافظة أو الدولة',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: context.surfaceColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 14.h),
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                    ? Center(
                        child: Text(
                          _searchController.text.trim().isEmpty
                              ? 'ابدأ بكتابة اسم مدينة لعرض النتائج'
                              : 'لم نعثر على نتائج مطابقة',
                          style: TextStyle(
                            color: _alpha(context.onSurfaceColor, 0.56),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _searchResults.length,
                        separatorBuilder: (_, __) => SizedBox(height: 10.h),
                        itemBuilder: (context, index) {
                          final result = _searchResults[index];
                          return InkWell(
                            borderRadius: BorderRadius.circular(18.r),
                            onTap: () => _selectSearchResult(result),
                            child: Container(
                              padding: EdgeInsets.all(14.sp),
                              decoration: BoxDecoration(
                                color: context.surfaceColor,
                                borderRadius: BorderRadius.circular(18.r),
                                border: Border.all(
                                  color: _alpha(context.outlineVariant, 0.35),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38.w,
                                    height: 38.w,
                                    decoration: BoxDecoration(
                                      color: _alpha(context.primaryColor, 0.12),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Icon(
                                      Icons.place_outlined,
                                      color: context.primaryColor,
                                      size: 20.sp,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          result.label,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: context.onSurfaceColor,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        if (result.detailsLabel.isNotEmpty) ...[
                                          SizedBox(height: 5.h),
                                          Text(
                                            result.detailsLabel,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: _alpha(
                                                context.onSurfaceColor,
                                                0.56,
                                              ),
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Icon(
                                    Icons.chevron_left_rounded,
                                    color: _alpha(context.onSurfaceColor, 0.5),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapTab(BuildContext context) {
    final selected = _selectedMapLocation;

    return Padding(
      padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 18.h),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22.r),
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _initialCenter,
                      initialZoom: 6.2,
                      onTap: (_, point) => _pickMapLocation(point),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'quran_app',
                      ),
                      if (selected != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(
                                selected.latitude,
                                selected.longitude,
                              ),
                              width: 48.w,
                              height: 48.w,
                              child: Icon(
                                Icons.location_on_rounded,
                                color: context.primaryColor,
                                size: 42.sp,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    left: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: _alpha(context.scaffoldBackgroundColor, 0.92),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Text(
                        _isResolvingMapLocation
                            ? 'جارِ قراءة اسم الموقع المحدد...'
                            : 'اضغط على أي نقطة في الخريطة لتحديد المنطقة',
                        style: TextStyle(
                          color: context.onSurfaceColor,
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 14.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.sp),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: _alpha(context.outlineVariant, 0.35),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selected?.label ?? 'لم يتم تحديد موقع من الخريطة بعد',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (selected != null && selected.detailsLabel.isNotEmpty) ...[
                  SizedBox(height: 5.h),
                  Text(
                    selected.detailsLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _alpha(context.onSurfaceColor, 0.56),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: selected == null || _isApplyingMapLocation
                        ? null
                        : _applyMapLocation,
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: Text(
                      _isApplyingMapLocation
                          ? 'جارِ اعتماد الموقع...'
                          : 'اعتماد الموقع المحدد',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Color _alpha(Color color, double value) => color.withValues(alpha: value);
