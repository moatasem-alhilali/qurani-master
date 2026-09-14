import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/util/url_launcher_utils.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/traveler/data/models/traveler_place.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_places/travel_places_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/traveler_shell.dart';

/// شريط التحكّم فوق الخريطة: الموقع، عدد النتائج، ثم نطاق البحث.
///
/// يطفو فوق بلاط الخريطة فلا بدّ له من أرضية؛ لكنّها أرضية الصفحة نفسها
/// بحدّ شعرة وبلا ظلّ — لا بطاقة بيضاء غريبة عن اللوحة.
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
      ..showSnackBar(
        const SnackBar(content: Text('تعذر فتح الرابط الآن.')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final location = state.locationContext;
    final countLabel = state.isLoadingPlaces
        ? 'جارٍ التحديث…'
        : 'عدد النتائج ${state.places.length}';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
      decoration: BoxDecoration(
        color: skin.ground.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: skin.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      location?.label ?? 'موقعي الحالي',
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
                      countLabel,
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
              TravelerPillButton(
                label: 'الخرائط',
                icon: AppIcons.direction,
                filled: true,
                onTap: () => _openNearbySearch(context),
              ),
            ],
          ),
          SizedBox(height: 9.h),
          Divider(height: 1, thickness: 1, color: skin.hairline),
          SizedBox(height: 9.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                TravelerPillButton(
                  label: 'تحديث',
                  icon: AppIcons.refresh,
                  onTap: state.isLoadingPlaces
                      ? null
                      : () {
                          HapticFeedback.selectionClick();
                          context
                              .read<TravelPlacesBloc>()
                              .add(LoadNearbyPlacesEvent());
                        },
                ),
                SizedBox(width: 6.w),
                TravelerPillButton(
                  label: 'موقعي',
                  icon: AppIcons.location,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onMoveToLocation();
                  },
                ),
                for (final radius in _radiusOptions) ...[
                  SizedBox(width: 6.w),
                  _RadiusChip(
                    label: _radiusLabel(radius),
                    selected: state.radiusMeters == radius,
                    onTap: state.isLoadingPlaces
                        ? null
                        : () {
                            if (state.radiusMeters == radius) return;
                            HapticFeedback.selectionClick();
                            context
                                .read<TravelPlacesBloc>()
                                .add(ChangeRadiusEvent(radius));
                          },
                  ),
                ],
              ],
            ),
          ),
          if (state.errorMessage != null) ...[
            SizedBox(height: 8.h),
            Text(
              state.errorMessage!,
              style: TextStyle(
                color: AppColors.error,
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// نطاق البحث: المختار يُقرأ بعلامة صحّ ووزن أثقل، لا بلون مختلف وحده.
class _RadiusChip extends StatelessWidget {
  const _RadiusChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: selected ? skin.iconChip : null,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: selected ? skin.raisedBorder : skin.hairline,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              AppIcon(AppIcons.checkSmall, color: skin.accent, size: 12.sp),
              SizedBox(width: 4.w),
            ],
            Text(
              label,
              style: TextStyle(
                color: selected ? skin.accent : skin.inkSoft,
                fontSize: 9.5.sp,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
