import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/radio/data/models/radio_station_model.dart';
import 'package:quran_app/features/radio/presentation/bloc/radio_bloc.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/components/mini_equalizer.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/components/radio_player_ui_manager.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/radio_station_artwork.dart';

/// صفّ محطة: نحيل، تفصله شعرة عمّا تحته.
///
/// المحطة الجارية وحدها ترتفع — فتُعرف من طرف العين بلا حاجة إلى شارة ولا
/// إطار حول كل محطة.
class RadioStationTile extends StatelessWidget {
  const RadioStationTile({
    required this.station,
    required this.isCurrent,
    required this.isPlayingCurrent,
    this.isLast = false,
    super.key,
  });

  final RadioStationModel station;
  final bool isCurrent;
  final bool isPlayingCurrent;
  final bool isLast;

  void _onTap(BuildContext context) {
    HapticFeedback.selectionClick();
    if (isCurrent) {
      // المحطة نفسها تعمل بالفعل: اللمس يفتح المشغّل بدل إعادة الاتصال.
      RadioPlayerUiManager.instance.openBox();
      return;
    }
    context.read<RadioBloc>().add(RadioStationPlayRequested(station));
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    final row = Row(
      children: [
        RadioStationArtwork(
          imageUrl: station.imageUrl,
          heroTag: 'radio_station_${station.id}',
          size: isCurrent ? 34.w : 30.w,
          borderRadius: 11.r,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                station.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: skin.ink,
                  fontSize: isCurrent ? 14.sp : 12.5.sp,
                  fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                  height: 1.2,
                ),
              ),
              Text(
                isCurrent
                    ? (isPlayingCurrent ? 'يُبثّ الآن' : 'آخر محطة مفتوحة')
                    : 'بثّ مباشر متواصل',
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
        if (isPlayingCurrent) ...[
          const MiniEqualizer(),
          SizedBox(width: 10.w),
        ],
        AppIcon(
          isPlayingCurrent ? AppIcons.pause : AppIcons.play,
          color: skin.accent,
          size: 15.sp,
        ),
      ],
    );

    if (isCurrent) {
      return Padding(
        padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 6.h),
        child: InkWell(
          onTap: () => _onTap(context),
          borderRadius: BorderRadius.circular(12.r),
          child: Ink(
            padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: skin.raised,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: skin.raisedBorder),
              boxShadow: skin.raisedShadow,
            ),
            child: row,
          ),
        ),
      );
    }

    return InkWell(
      onTap: () => _onTap(context),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: skin.hairline)),
              ),
        child: row,
      ),
    );
  }
}
