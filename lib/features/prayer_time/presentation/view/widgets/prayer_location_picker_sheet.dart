import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/prayer_time/data/model/prayer_location_selection.dart';
import 'package:quran_app/features/prayer_time/data/service/prayer_location_resolver.dart';

/// ورقة اختيار المنطقة: بحث أو نقطة على الخريطة.
///
/// الورقة سطح واحد على `skin.ground`: نتائج البحث صفوف نحيلة بفواصل شعرة،
/// والفعل الوحيد المعبّأ ذهبًا هو «استخدام موقع الجهاز».
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
    final skin = AppSkin.of(context);

    return SafeArea(
      top: false,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.84,
        child: DefaultTabController(
          length: 2,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: skin.ground,
              borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
            ),
            child: Column(
              children: [
                SizedBox(height: 9.h),
                Container(
                  width: 34.w,
                  height: 3.h,
                  decoration: BoxDecoration(
                    color: skin.hairline,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
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
                SizedBox(height: 10.h),
                const _PickerTabs(),
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
    final skin = AppSkin.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
      child: Column(
        children: [
          _SearchField(
            controller: _searchController,
            onChanged: _onSearchChanged,
          ),
          SizedBox(height: 6.h),
          Expanded(
            child: _isSearching
                ? Center(
                    child: SizedBox.square(
                      dimension: 22.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(skin.accent),
                      ),
                    ),
                  )
                : _searchResults.isEmpty
                    ? _SearchEmptyState(
                        hasQuery: _searchController.text.trim().isNotEmpty,
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final result = _searchResults[index];
                          return _LocationResultRow(
                            result: result,
                            isLast: index == _searchResults.length - 1,
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
    final skin = AppSkin.of(context);
    final selected = _selectedMapLocation;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
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
                                color: AppColors.gold,
                                size: 32.sp,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    left: 10.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: skin.ground.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: skin.hairline),
                      ),
                      child: Row(
                        children: [
                          AppIcon(
                            _isResolvingMapLocation
                                ? AppIcons.refresh
                                : AppIcons.mapPin,
                            color: skin.accent,
                            size: 14.sp,
                          ),
                          SizedBox(width: 7.w),
                          Expanded(
                            child: Text(
                              _isResolvingMapLocation
                                  ? 'جارِ قراءة اسم الموقع المحدد...'
                                  : 'اضغط على الخريطة لتحديد المنطقة',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: skin.ink,
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w600,
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
          _MapSelectionRow(
            selected: selected,
            isApplying: _isApplyingMapLocation,
            onApply: _applyMapLocation,
          ),
        ],
      ),
    );
  }
}

class _PickerHeader extends StatelessWidget {
  const _PickerHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'اختيار المنطقة',
                style: TextStyle(
                  color: skin.ink,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              Text(
                'ابحث أو حدّد نقطة من الخريطة',
                style: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.78),
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: onClose,
          borderRadius: BorderRadius.circular(999.r),
          child: Padding(
            padding: EdgeInsets.all(5.w),
            child: AppIcon(AppIcons.close, color: skin.inkSoft, size: 16.sp),
          ),
        ),
      ],
    );
  }
}

/// الفعل الرئيسي في الورقة — الوحيد المعبّأ ذهبًا.
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
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Ink(
        decoration: BoxDecoration(
          color: isLoading
              ? AppColors.gold.withValues(alpha: 0.5)
              : AppColors.gold,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: SizedBox(
          height: 38.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox.square(
                  dimension: 13.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.brandIvory,
                    ),
                  ),
                )
              else
                const AppIcon(
                  AppIcons.location,
                  color: AppColors.brandIvory,
                  size: 15,
                ),
              SizedBox(width: 8.w),
              Text(
                isLoading
                    ? 'جارِ استخدام موقع الجهاز...'
                    : 'استخدام موقع الجهاز الحالي',
                style: TextStyle(
                  color: AppColors.brandIvory,
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// تبويبان بخطّ سفلي واحد — بلا صندوق حولهما.
class _PickerTabs extends StatelessWidget {
  const _PickerTabs();

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return TabBar(
      indicatorColor: skin.accent,
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: skin.hairline,
      dividerHeight: 1,
      labelColor: skin.ink,
      labelStyle: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w700),
      unselectedLabelColor: skin.inkSoft.withValues(alpha: 0.7),
      unselectedLabelStyle: TextStyle(
        fontSize: 11.5.sp,
        fontWeight: FontWeight.w600,
      ),
      tabs: const [
        Tab(text: 'بحث'),
        Tab(text: 'الخريطة'),
      ],
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
    final skin = AppSkin.of(context);
    final border = UnderlineInputBorder(
      borderSide: BorderSide(color: skin.hairline),
    );

    return TextField(
      controller: controller,
      onChanged: onChanged,
      cursorColor: skin.accent,
      style: TextStyle(
        color: skin.ink,
        fontSize: 12.5.sp,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: 'اسم المدينة أو الدولة',
        hintStyle: TextStyle(
          color: skin.inkSoft.withValues(alpha: 0.6),
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: AppIcon(AppIcons.search, color: skin.accent, size: 15.sp),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 32.w),
        filled: false,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 10.h),
        border: border,
        enabledBorder: border,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: skin.accent),
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
    final skin = AppSkin.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(
            hasQuery ? AppIcons.searchOff : AppIcons.search,
            color: skin.accent,
            size: 22.sp,
          ),
          SizedBox(height: 8.h),
          Text(
            hasQuery ? 'لم نعثر على نتائج مطابقة' : 'ابدأ بكتابة اسم المدينة',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: skin.inkSoft.withValues(alpha: 0.78),
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationResultRow extends StatelessWidget {
  const _LocationResultRow({
    required this.result,
    required this.isLast,
    required this.onTap,
  });

  final PrayerLocationSelection result;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        padding: EdgeInsets.symmetric(vertical: 11.h),
        child: Row(
          children: [
            Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: skin.iconChip,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: AppIcon(
                  AppIcons.mapPin,
                  color: skin.accent,
                  size: 15.sp,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    result.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.ink,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  if (result.detailsLabel.isNotEmpty)
                    Text(
                      result.detailsLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: skin.inkSoft.withValues(alpha: 0.78),
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            AppIcon(AppIcons.chevronLeft, color: skin.accent, size: 15.sp),
          ],
        ),
      ),
    );
  }
}

class _MapSelectionRow extends StatelessWidget {
  const _MapSelectionRow({
    required this.selected,
    required this.isApplying,
    required this.onApply,
  });

  final PrayerLocationSelection? selected;
  final bool isApplying;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final canApply = selected != null && !isApplying;

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: skin.hairline)),
      ),
      padding: EdgeInsets.only(top: 10.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selected?.label ?? 'لم يتم تحديد موقع بعد',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                Text(
                  (selected?.detailsLabel.isNotEmpty ?? false)
                      ? selected!.detailsLabel
                      : 'اضغط على الخريطة لاختيار المنطقة',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: skin.inkSoft.withValues(alpha: 0.78),
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          InkWell(
            onTap: canApply ? onApply : null,
            borderRadius: BorderRadius.circular(999.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isApplying)
                    SizedBox.square(
                      dimension: 13.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(skin.accent),
                      ),
                    )
                  else
                    AppIcon(
                      AppIcons.checkSmall,
                      color: canApply
                          ? skin.accent
                          : skin.inkSoft.withValues(alpha: 0.45),
                      size: 15.sp,
                    ),
                  SizedBox(width: 5.w),
                  Text(
                    isApplying ? 'جارِ الاعتماد' : 'اعتماد',
                    style: TextStyle(
                      color: canApply || isApplying
                          ? skin.accent
                          : skin.inkSoft.withValues(alpha: 0.45),
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w700,
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
