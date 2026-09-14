import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/url_launcher_utils.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/traveler/data/models/traveler_place.dart';
import 'package:quran_app/features/traveler/presentation/bloc/travel_places/travel_places_bloc.dart';
import 'package:quran_app/features/traveler/presentation/view/widgets/traveler_shell.dart';

/// صفوف الأماكن القريبة: نحيلة، بفواصل شعرة، بلا بطاقة حول كل مكان.
class TravelPlacesListItems extends StatelessWidget {
  const TravelPlacesListItems({
    required this.state,
    required this.placeType,
    super.key,
  });

  final TravelPlacesState state;
  final TravelerPlaceType placeType;

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingPlaces) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.places.isEmpty) {
      return TravelerNotice(
        icon: AppIcons.searchOff,
        message: placeType.emptyMessage,
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
      itemCount: state.places.length,
      itemBuilder: (context, index) {
        final place = state.places[index];
        return _PlaceRow(
          place: place,
          placeType: placeType,
          selected: state.selectedPlace?.id == place.id,
          isLast: index == state.places.length - 1,
        );
      },
    );
  }
}

class _PlaceRow extends StatelessWidget {
  const _PlaceRow({
    required this.place,
    required this.placeType,
    required this.selected,
    required this.isLast,
  });

  final TravelerPlace place;
  final TravelerPlaceType placeType;
  final bool selected;
  final bool isLast;

  Future<void> _openInMaps(BuildContext context) async {
    final query = Uri.encodeComponent(
      '${place.name} ${place.latitude},${place.longitude}',
    );
    final url = 'https://www.google.com/maps/search/?api=1&query=$query';
    final launched = await UrlLauncherUtils.launchWebUrl(url);
    if (!context.mounted || launched) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('تعذر فتح تطبيق الخرائط.')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        context.read<TravelPlacesBloc>().add(SelectPlaceEvent(place));
      },
      child: Container(
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            // المكان المختار يُعلَّم بشريط ذهبي رفيع على حافة الصفّ: شكل
            // يسبق اللون، فلا تختفي الحالة على من لا يميّز الألوان.
            Container(
              width: 2.5.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: selected ? skin.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(999.r),
              ),
            ),
            SizedBox(width: 8.w),
            TravelerIconChip(
              icon: placeType == TravelerPlaceType.mosque
                  ? AppIcons.mosque
                  : AppIcons.restaurant,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    place.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.ink,
                      fontSize: 12.5.sp,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    '${place.distanceLabel} · ${place.address}',
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
            SizedBox(width: 6.w),
            TravelerIconAction(
              icon: AppIcons.direction,
              tooltip: 'فتح في خرائط جوجل',
              onTap: () => _openInMaps(context),
            ),
          ],
        ),
      ),
    );
  }
}
