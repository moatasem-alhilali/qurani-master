import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/radio/data/models/radio_station_model.dart';
import 'package:quran_app/features/radio/data/service/radio_favourites_store.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/radio_station_artwork.dart';

/// صفّ المفضّلة: أغلفة صغيرة تُدير القرص إلى محطتها بلمسة.
///
/// الصفحة السابقة كانت تحفظ محطةً واحدة فقط، فمن يتنقّل بين ثلاثة قرّاء
/// يبحث عنهم في أربعة وعشرين صفًّا كل مرّة.
class RadioFavouritesStrip extends StatelessWidget {
  const RadioFavouritesStrip({
    required this.favourites,
    required this.stations,
    required this.currentId,
    required this.onSelect,
    super.key,
  });

  final RadioFavouritesStore favourites;
  final List<RadioStationModel> stations;
  final int? currentId;
  final ValueChanged<RadioStationModel> onSelect;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return ValueListenableBuilder<Set<int>>(
      valueListenable: favourites.favourites,
      builder: (context, ids, _) {
        final picked =
            stations.where((station) => ids.contains(station.id)).toList();

        if (picked.isEmpty) {
          // بدل إخفاء القسم: سطر يشرح كيف تُضاف المفضّلة، وإلا بقيت الميزة
          // مخفيّة خلف ضغطة مطوّلة لا يعرفها أحد.
          return Padding(
            padding: EdgeInsets.fromLTRB(16.w, 11.h, 16.w, 11.h),
            child: Row(
              children: [
                AppIcon(
                  AppIcons.heart,
                  color: skin.inkSoft.withValues(alpha: 0.5),
                  size: 13.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'اضغط مطوّلًا على أي محطة لإضافتها إلى المفضّلة.',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.inkSoft.withValues(alpha: 0.7),
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return SizedBox(
          height: 62.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
            itemCount: picked.length,
            separatorBuilder: (context, _) => SizedBox(width: 10.w),
            itemBuilder: (context, i) => _FavouriteAvatar(
              station: picked[i],
              isCurrent: picked[i].id == currentId,
              onTap: () => onSelect(picked[i]),
            ),
          ),
        );
      },
    );
  }
}

class _FavouriteAvatar extends StatelessWidget {
  const _FavouriteAvatar({
    required this.station,
    required this.isCurrent,
    required this.onTap,
  });

  final RadioStationModel station;
  final bool isCurrent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Semantics(
      button: true,
      label: station.shortName,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(isCurrent ? 1.8 : 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border:
                isCurrent ? Border.all(color: skin.accent, width: 1.5) : null,
          ),
          child: RadioStationArtwork(
            imageUrl: station.imageUrl,
            size: 38.w,
            borderRadius: 11.r,
            initials: station.initials,
          ),
        ),
      ),
    );
  }
}

/// زرّ المفضّلة داخل المؤشّر — يخصّ المحطة المعروضة على القرص.
class RadioFavouriteButton extends StatelessWidget {
  const RadioFavouriteButton({
    required this.favourites,
    required this.station,
    super.key,
  });

  final RadioFavouritesStore favourites;
  final RadioStationModel? station;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final current = station;
    if (current == null) return SizedBox(width: 38.w);

    return ValueListenableBuilder<Set<int>>(
      valueListenable: favourites.favourites,
      builder: (context, ids, _) {
        final isFavourite = ids.contains(current.id);

        return IconButton(
          onPressed: () => favourites.toggle(current.id),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints.tightFor(width: 40.w, height: 40.w),
          tooltip: isFavourite ? 'إزالة من المفضّلة' : 'إضافة إلى المفضّلة',
          icon: AppIcon(
            AppIcons.heart,
            color: isFavourite
                ? skin.accent
                : skin.inkSoft.withValues(alpha: 0.55),
            size: 19.sp,
            strokeWidth: isFavourite ? 2.4 : 1.8,
          ),
        );
      },
    );
  }
}
