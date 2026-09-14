import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/radio/data/models/radio_station_model.dart';
import 'package:quran_app/features/radio/data/service/radio_favourites_store.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/radio_station_artwork.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/radio_waveform.dart';

/// صفّ محطة في القائمة.
///
/// النسخة السابقة كانت تكتب تحت كل اسم النصّ نفسه — «بثّ مباشر متواصل» —
/// أربعًا وعشرين مرّة. سطرٌ لا يحمل معلومة يسرق نصف ارتفاع الصفّ ويضاعف طول
/// القائمة بلا مقابل، فحُذف: الصفّ الآن سطر واحد، والحالة تُقرأ من الموجة
/// المتحرّكة وحدها.
///
/// الضغط المطوّل يضيف المحطة للمفضّلة ويزيلها — وهو المدخل الوحيد لها.
class RadioStationTile extends StatelessWidget {
  const RadioStationTile({
    required this.station,
    required this.isCurrent,
    required this.isPlayingCurrent,
    required this.favourites,
    required this.onTap,
    this.showDivider = true,
    super.key,
  });

  final RadioStationModel station;
  final bool isCurrent;
  final bool isPlayingCurrent;
  final RadioFavouritesStore favourites;
  final VoidCallback onTap;
  final bool showDivider;

  void _toggleFavourite(BuildContext context) {
    final added = favourites.toggle(station.id);
    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 1400),
          content: Text(
            added
                ? 'أُضيفت ${station.shortName} إلى المفضّلة'
                : 'أُزيلت ${station.shortName} من المفضّلة',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return InkWell(
      onTap: onTap,
      onLongPress: () => _toggleFavourite(context),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(vertical: 9.h),
        decoration: showDivider
            ? BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              )
            : null,
        child: Row(
          children: [
            RadioStationArtworkSlot(station: station, isCurrent: isCurrent),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                station.shortName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isCurrent ? skin.accent : skin.ink,
                  fontSize: 12.5.sp,
                  fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                  height: 1.25,
                ),
              ),
            ),
            ValueListenableBuilder<Set<int>>(
              valueListenable: favourites.favourites,
              builder: (context, ids, _) {
                if (!ids.contains(station.id)) return const SizedBox.shrink();
                return Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: AppIcon(
                    AppIcons.heart,
                    color: skin.accent.withValues(alpha: 0.75),
                    size: 12.sp,
                  ),
                );
              },
            ),
            if (isPlayingCurrent)
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: const RadioWaveform(isActive: true, barCount: 3),
              ),
          ],
        ),
      ),
    );
  }
}

/// مربّع الغلاف داخل الصفّ.
class RadioStationArtworkSlot extends StatelessWidget {
  const RadioStationArtworkSlot({
    required this.station,
    required this.isCurrent,
    super.key,
  });

  final RadioStationModel station;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: isCurrent
            ? Border.all(color: skin.accent.withValues(alpha: 0.85), width: 1.4)
            : null,
      ),
      padding: EdgeInsets.all(isCurrent ? 1.6 : 0),
      child: RadioStationArtwork(
        imageUrl: station.imageUrl,
        size: 30.w,
        borderRadius: 9.r,
        initials: station.initials,
      ),
    );
  }
}
