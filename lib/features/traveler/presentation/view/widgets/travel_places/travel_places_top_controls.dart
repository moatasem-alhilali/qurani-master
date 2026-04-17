import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/url_launcher_utils.dart';
import 'package:quran_app/features/traveler/data/models/traveler_place.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_places/travel_places_bloc.dart';

class TravelPlacesTopControls extends StatelessWidget {
  const TravelPlacesTopControls({
    required this.state,
    required this.placeType,
    required this.onMoveToLocation,
    super.key,
  });

  final TravelPlacesState state;
  final TravelerPlaceType placeType;
  final VoidCallback onMoveToLocation;

  static const List<int> _radiusOptions = [1000, 3000, 5000, 10000];

  String _radiusLabel(int meters) {
    if (meters >= 1000) {
      final km = meters / 1000;
      return '${km.toStringAsFixed(km.truncateToDouble() == km ? 0 : 1)} كم';
    }
    return '$meters م';
  }

  Future<void> _openNearbySearch(BuildContext context) async {
    final location = state.locationContext;
    if (location == null) return;

    final query = Uri.encodeComponent(
      '${placeType.queryLabel} near ${location.latitude},${location.longitude}',
    );
    final url = 'https://www.google.com/maps/search/?api=1&query=$query';
    final launched = await UrlLauncherUtils.launchWebUrl(url);
    if (!context.mounted || launched) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('تعذر فتح الرابط الآن.')));
  }

  @override
  Widget build(BuildContext context) {
    final location = state.locationContext;
    final countLabel = state.isLoadingPlaces
        ? 'جارِ التحديث...'
        : 'عدد النتائج: ${state.places.length}';

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
                  onPressed: state.isLoadingPlaces
                      ? null
                      : () => context
                          .read<TravelPlacesBloc>()
                          .add(LoadNearbyPlacesEvent()),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('تحديث'),
                ),
                SizedBox(width: 8.w),
                FilledButton.tonalIcon(
                  onPressed: onMoveToLocation,
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
                              context
                                  .read<TravelPlacesBloc>()
                                  .add(ChangeRadiusEvent(radius));
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
}
