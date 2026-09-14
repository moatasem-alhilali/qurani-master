import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/radio/data/models/radio_station_model.dart';
import 'package:quran_app/features/radio/presentation/bloc/radio_bloc.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/components/player_control_button.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/components/radio_player_ui_manager.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/radio_station_artwork.dart';

/// المشغّل الموسّع: الصورة ثم الاسم ثم خطّ البثّ ثم الأزرار.
///
/// كان خلفه صورةٌ مموّهة بلون مستخرج من غلاف المحطة، فيختلف لون الشاشة مع كل
/// محطة ويختفي النص أحيانًا. الأرضية الآن أرضية التطبيق نفسها، والبطل هو خطّ
/// البثّ وأزرار التحكّم.
class ExpandedRadioPlayer extends StatelessWidget {
  const ExpandedRadioPlayer({
    required this.station,
    required this.isPlaying,
    required this.isLoading,
    super.key,
  });

  final RadioStationModel station;
  final bool isPlaying;
  final bool isLoading;

  String get _statusLabel {
    if (isLoading) {
      return 'جارٍ الاتصال بالبثّ…';
    }
    return isPlaying ? 'البثّ المباشر يعمل الآن' : 'البثّ متوقّف';
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Material(
      color: skin.ground,
      child: Container(
        constraints: BoxConstraints(
          minHeight: context.getScreenHeight() * 0.90,
        ),
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // مقبض السحب — شعرة واحدة لا شريط ثقيل.
            Center(
              child: Container(
                width: 34.w,
                height: 3.h,
                decoration: BoxDecoration(
                  color: skin.hairline,
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
            ),
            SizedBox(height: 26.h),
            Center(
              child: RadioStationArtwork(
                imageUrl: station.imageUrl,
                heroTag: 'radio_station_${station.id}_expanded',
                size: context.getScreenHeight() * 0.30,
                borderRadius: 14.r,
              ),
            ),
            SizedBox(height: 26.h),
            Text(
              station.name,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: skin.ink,
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                height: 1.3,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              _statusLabel,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w500,
                height: 1.35,
              ),
            ),
            SizedBox(height: 18.h),
            _LiveBar(isPlaying: isPlaying),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'بثّ مباشر',
                  style: TextStyle(
                    color: skin.inkSoft.withValues(alpha: 0.62),
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isPlaying)
                  AppIcon(AppIcons.sound, color: skin.accent, size: 13.sp),
              ],
            ),
            SizedBox(height: 28.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlayerControlButton(
                  icon: AppIcons.stop,
                  tooltip: 'إيقاف البثّ',
                  onTap: () => context.read<RadioBloc>().add(
                        const RadioStopRequested(),
                      ),
                ),
                SizedBox(width: 26.w),
                PlayerControlButton(
                  icon: isPlaying ? AppIcons.pause : AppIcons.play,
                  isPrimary: true,
                  tooltip: isPlaying ? 'إيقاف مؤقّت' : 'تشغيل',
                  onTap: () => context.read<RadioBloc>().add(
                        const RadioTogglePlayPauseRequested(),
                      ),
                ),
                SizedBox(width: 26.w),
                PlayerControlButton(
                  icon: AppIcons.down,
                  tooltip: 'إخفاء المشغّل',
                  onTap: RadioPlayerUiManager.instance.closeBox,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// خطّ البثّ: يمتلئ ذهبًا ما دام البثّ يعمل، ويعود شعرةً عند التوقّف.
class _LiveBar extends StatelessWidget {
  const _LiveBar({required this.isPlaying});

  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Container(
      height: 3.h,
      decoration: BoxDecoration(
        color: skin.hairline,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: AnimatedFractionallySizedBox(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOut,
        alignment: AlignmentDirectional.centerStart,
        widthFactor: isPlaying ? 1.0 : 0.0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(999.r),
          ),
        ),
      ),
    );
  }
}
