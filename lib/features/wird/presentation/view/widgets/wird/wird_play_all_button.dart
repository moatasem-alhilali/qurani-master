import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/wird/presentation/bloc/wird_bloc.dart';

/// «تشغيل الكل»: صفّ نحيل بأيقونة في مربّع صغير، لا زرّ مملوء.
class WirdPlayAllButton extends StatelessWidget {
  const WirdPlayAllButton({super.key});

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocBuilder<WirdBloc, WirdState>(
      buildWhen: (p, c) =>
          p.itemsWithAudio != c.itemsWithAudio ||
          p.isAudioInitializing != c.isAudioInitializing ||
          p.processingState != c.processingState ||
          p.isQueueRepeated != c.isQueueRepeated ||
          p.isPlaying != c.isPlaying,
      builder: (context, state) {
        if (state.itemsWithAudio.isEmpty) {
          return const SizedBox.shrink();
        }

        final isBuffering = state.isAudioInitializing ||
            state.processingState == ProcessingState.loading ||
            state.processingState == ProcessingState.buffering;

        var icon = AppIcons.play;
        var label = 'تشغيل الورد كاملًا';

        if (isBuffering) {
          label = 'تهيئة الصوت';
        } else if (state.isQueueRepeated && state.isPlaying) {
          icon = AppIcons.pause;
          label = 'إيقاف مؤقت';
        } else if (state.isQueueRepeated &&
            state.processingState == ProcessingState.completed) {
          icon = AppIcons.replay;
          label = 'إعادة تشغيل الورد';
        }

        return InkWell(
          onTap: isBuffering
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  context.read<WirdBloc>().add(TogglePlayAllWirdEvent());
                },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 9.h),
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
                    child: isBuffering
                        ? SizedBox(
                            width: 13.sp,
                            height: 13.sp,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.6,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(skin.accent),
                            ),
                          )
                        : AppIcon(icon, color: skin.accent, size: 15.sp),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: skin.ink,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
