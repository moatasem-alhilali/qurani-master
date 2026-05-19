import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
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
        height: MediaQuery.of(context).size.height * 0.84,
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
                SizedBox(height: 9.h),
                _SheetHandle(color: _alpha(context.outlineVariant, 0.55)),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
                  child: _PickerHeader(
                    onClose: () => Navigator.of(context).pop(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                  child: _CurrentLocationButton(
                    isLoading: _isApplyingCurrentLocation,
                    onTap: _selectCurrentLocation,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                  child: _PickerTabs(
                    color: context.primaryColor,
                  ),
                ),
                SizedBox(height: 12.h),
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
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      child: Column(
        children: [
          _SearchField(
            controller: _searchController,
            onChanged: _onSearchChanged,
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: _isSearching
                ? Center(
                    child: CircularProgressIndicator(
                      color: context.primaryColor,
                      strokeWidth: 2.w,
                    ),
                  )
                : _searchResults.isEmpty
                    ? _SearchEmptyState(
                        hasQuery: _searchController.text.trim().isNotEmpty,
                      )
                    : ListView.separated(
                        itemCount: _searchResults.length,
                        separatorBuilder: (_, __) => SizedBox(height: 8.h),
                        itemBuilder: (context, index) {
                          final result = _searchResults[index];
                          return _LocationResultTile(
                            result: result,
                            onTap: () => _selectSearchResult(result),
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
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
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
                              child: AppIcon(
                                AppIcons.mapPin,
                                color: context.primaryColor,
                                size: 34.sp,
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
                        border: Border.all(
                          color: _alpha(context.outlineVariant, 0.18),
                        ),
                      ),
                      child: Row(
                        children: [
                          AppIcon(
                            _isResolvingMapLocation
                                ? AppIcons.refresh
                                : AppIcons.mapPin,
                            color: context.primaryColor,
                            size: 14.sp,
                            strokeWidth: 1.55,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              _isResolvingMapLocation
                                  ? 'جارِ قراءة اسم الموقع المحدد...'
                                  : 'اضغط على الخريطة لتحديد المنطقة',
                              style: TextStyle(
                                color: context.onSurfaceColor,
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
          _MapSelectionCard(
            selected: selected,
            isApplying: _isApplyingMapLocation,
            onApply: _applyMapLocation,
          ),
        ],
      ),
    );
  }
}

Color _alpha(Color color, double value) => color.withValues(alpha: value);

class _SheetHandle extends StatelessWidget {
  const _SheetHandle({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999.r),
      ),
    );
  }
}

class _PickerHeader extends StatelessWidget {
  const _PickerHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'اختيار المنطقة',
                style: TextStyle(
                  color: context.onSurfaceColor,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'ابحث أو حدّد نقطة من الخريطة',
                style: TextStyle(
                  color: _alpha(context.onSurfaceColor, 0.55),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onClose,
          child: Container(
            width: 36.w,
            height: 36.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: _alpha(context.outlineVariant, 0.2)),
            ),
            child: AppIcon(
              AppIcons.close,
              color: context.onSurfaceVariant,
              size: 15.sp,
              strokeWidth: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _CurrentLocationButton extends StatelessWidget {
  const _CurrentLocationButton({
    required this.isLoading,
    required this.onTap,
  });

  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
        decoration: BoxDecoration(
          color: context.primaryColor,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 14.w,
                height: 14.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  color: context.onPrimaryColor,
                ),
              )
            else
              AppIcon(
                AppIcons.location,
                color: context.onPrimaryColor,
                size: 14.sp,
                strokeWidth: 1.6,
              ),
            SizedBox(width: 8.w),
            Text(
              isLoading
                  ? 'جارِ استخدام موقع الجهاز...'
                  : 'استخدام موقع الجهاز الحالي',
              style: TextStyle(
                color: context.onPrimaryColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerTabs extends StatelessWidget {
  const _PickerTabs({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: _alpha(context.outlineVariant, 0.18)),
      ),
      child: TabBar(
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: color.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(12.r),
        ),
        labelColor: context.onSurfaceColor,
        labelStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w900),
        unselectedLabelColor: _alpha(context.onSurfaceColor, 0.5),
        unselectedLabelStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
        ),
        tabs: const [
          Tab(text: 'بحث'),
          Tab(text: 'الخريطة'),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(
        color: context.onSurfaceColor,
        fontSize: 12.5.sp,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        hintText: 'اسم المدينة أو الدولة',
        hintStyle: TextStyle(
          color: _alpha(context.onSurfaceColor, 0.45),
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.all(12.w),
          child: AppIcon(
            AppIcons.search,
            color: context.primaryColor,
            size: 15.sp,
            strokeWidth: 1.6,
          ),
        ),
        filled: true,
        fillColor: context.surfaceColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(
            color: _alpha(context.outlineVariant, 0.24),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(
            color: _alpha(context.outlineVariant, 0.24),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(
            color: _alpha(context.primaryColor, 0.55),
          ),
        ),
      ),
    );
  }
}

class _SearchEmptyState extends StatelessWidget {
  const _SearchEmptyState({required this.hasQuery});

  final bool hasQuery;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: _alpha(context.outlineVariant, 0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(
              hasQuery ? AppIcons.searchOff : AppIcons.search,
              color: context.primaryColor,
              size: 22.sp,
              strokeWidth: 1.55,
            ),
            SizedBox(height: 10.h),
            Text(
              hasQuery ? 'لم نعثر على نتائج مطابقة' : 'ابدأ بكتابة اسم المدينة',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _alpha(context.onSurfaceColor, 0.62),
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationResultTile extends StatelessWidget {
  const _LocationResultTile({
    required this.result,
    required this.onTap,
  });

  final PrayerLocationSelection result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(11.w),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: _alpha(context.outlineVariant, 0.24)),
        ),
        child: Row(
          children: [
            Container(
              width: 34.w,
              height: 34.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _alpha(context.primaryColor, 0.1),
                borderRadius: BorderRadius.circular(11.r),
              ),
              child: AppIcon(
                AppIcons.mapPin,
                color: context.primaryColor,
                size: 15.sp,
                strokeWidth: 1.55,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: context.onSurfaceColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (result.detailsLabel.isNotEmpty) ...[
                    SizedBox(height: 3.h),
                    Text(
                      result.detailsLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _alpha(context.onSurfaceColor, 0.55),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 8.w),
            AppIcon(
              AppIcons.chevronLeft,
              color: _alpha(context.onSurfaceColor, 0.45),
              size: 14.sp,
              strokeWidth: 1.55,
            ),
          ],
        ),
      ),
    );
  }
}

class _MapSelectionCard extends StatelessWidget {
  const _MapSelectionCard({
    required this.selected,
    required this.isApplying,
    required this.onApply,
  });

  final PrayerLocationSelection? selected;
  final bool isApplying;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final canApply = selected != null && !isApplying;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: _alpha(context.outlineVariant, 0.24)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selected?.label ?? 'لم يتم تحديد موقع بعد',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.onSurfaceColor,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  (selected?.detailsLabel.isNotEmpty ?? false)
                      ? selected!.detailsLabel
                      : 'اضغط على الخريطة لاختيار المنطقة',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _alpha(context.onSurfaceColor, 0.55),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: canApply ? onApply : null,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
              decoration: BoxDecoration(
                color: canApply
                    ? context.primaryColor
                    : _alpha(context.onSurfaceColor, 0.08),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  if (isApplying)
                    SizedBox(
                      width: 13.w,
                      height: 13.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.w,
                        color: context.onPrimaryColor,
                      ),
                    )
                  else
                    AppIcon(
                      AppIcons.checkSmall,
                      color: canApply
                          ? context.onPrimaryColor
                          : _alpha(context.onSurfaceColor, 0.42),
                      size: 13.sp,
                      strokeWidth: 1.6,
                    ),
                  SizedBox(width: 6.w),
                  Text(
                    isApplying ? 'جارِ' : 'اعتماد',
                    style: TextStyle(
                      color: canApply || isApplying
                          ? context.onPrimaryColor
                          : _alpha(context.onSurfaceColor, 0.42),
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
