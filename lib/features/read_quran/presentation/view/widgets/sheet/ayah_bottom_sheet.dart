import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/bloc/audio/share_audio_bloc.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/models_public/position_data_model.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:rxdart/rxdart.dart';

class AyahBottomSheet extends StatelessWidget {
  AyahBottomSheet({
    required this.verseNumber,
    required this.surahNumber,
    required this.ayah,
    super.key,
    this.text,
  });

  final int verseNumber;
  final int surahNumber;
  String? text;
  String? ayah;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShareAudioBloc, ShareAudioState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 5),
            Text(
              'السماع',
              style: titleMedium(context).copyWith(
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 10),
            CardWidget(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: SliderAudio(
                audioPlayer: state.audioPlayer ?? AudioPlayer(),
              ),
            ),
            Text(
              'الايه',
              style: titleMedium(context).copyWith(
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 10),
            CardWidget(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.all(8.sp),
              width: double.infinity,
              child: Text(
                ayah ?? '',
                textAlign: TextAlign.right,
                style: titleMedium(context).copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'quran',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'تفسير الأية',
                style: titleMedium(context).copyWith(
                  fontSize: 16.sp,
                ),
              ),
            ),
            const Divider(),
            CardWidget(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(8),
              child: Text(
                text ?? '',
                textAlign: TextAlign.right,
                style: titleMedium(context).copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SliderAudio extends StatelessWidget {
  const SliderAudio({
    required this.audioPlayer,
    super.key,
  });
  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        // vertical: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          StreamBuilder<PositionData>(
            stream: _positionDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return ProgressBar(
                progressBarColor: context.primaryScheme,
                baseBarColor: context.primaryScheme.withOpacity(0.24),
                bufferedBarColor: context.primaryScheme.withOpacity(0.24),
                thumbColor: context.primaryScheme,
                barHeight: 10,
                timeLabelTextStyle: titleMedium(context).copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                progress: positionData?.position ?? Duration.zero,
                buffered: positionData?.bufferedPosition ?? Duration.zero,
                total: positionData?.duration ?? Duration.zero,
                onSeek: audioPlayer.seek,
              );
            },
          ),
          ControllerReader(
            audioPlayer: audioPlayer,
          ),
        ],
      ),
    );
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        audioPlayer.positionStream,
        audioPlayer.bufferedPositionStream,
        audioPlayer.durationStream,
        (position, bufferedPosition, duration) {
          return PositionData(
            position,
            bufferedPosition,
            duration ?? Duration.zero,
          );
        },
      );
}

//

class ControllerReader extends StatelessWidget {
  const ControllerReader({required this.audioPlayer, super.key});
  final AudioPlayer audioPlayer;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (!(playing ?? false)) {
          return IconButton(
            onPressed: audioPlayer.play,
            icon: Icon(
              Icons.play_arrow,
              size: 40,
              color: context.primaryScheme,
            ),
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            onPressed: audioPlayer.pause,
            icon: Icon(
              Icons.pause,
              size: 40,
              color: context.primaryScheme,
            ),
          );
        } else {
          return Icon(
            Icons.play_arrow_rounded,
            size: 40,
            color: context.primaryScheme,
          );
        }
      },
      stream: audioPlayer.playerStateStream,
    );
  }
}
