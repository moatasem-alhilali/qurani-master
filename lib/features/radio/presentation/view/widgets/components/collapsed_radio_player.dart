import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/radio/data/models/radio_station_model.dart';
import 'package:quran_app/features/radio/presentation/bloc/radio_bloc.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/components/mini_equalizer.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/components/radio_player_ui_manager.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/radio_station_artwork.dart';

/// شريط المشغّل المصغّر: شريط خدمة لا بطاقة — شعرة تفصله عن المحتوى فوقه.
class CollapsedRadioPlayer extends StatelessWidget {
  const CollapsedRadioPlayer({
    required this.station,
    required this.isPlaying,
    super.key,
  });

  final RadioStationModel station;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Material(
      color: skin.raised,
      child: InkWell(
        onTap: RadioPlayerUiManager.instance.openBox,
        child: Container(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 10.w, 10.h),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: skin.hairline)),
          ),
          child: Row(
            children: [
              RadioStationArtwork(
                imageUrl: station.imageUrl,
                heroTag: 'radio_station_${station.id}',
                size: 32.w,
                borderRadius: 10.r,
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
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      isPlaying ? 'يُبثّ الآن' : 'البثّ متوقّف',
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
              if (isPlaying) ...[
                const MiniEqualizer(),
                SizedBox(width: 10.w),
              ],
              IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints.tightFor(width: 34.w, height: 34.w),
                onPressed: () => context.read<RadioBloc>().add(
                      const RadioTogglePlayPauseRequested(),
                    ),
                icon: AppIcon(
                  isPlaying ? AppIcons.pause : AppIcons.play,
                  color: skin.accent,
                  size: 18.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
