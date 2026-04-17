import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/package/flutter_sliding_box.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/radio/data/service/radio_audio_service.dart';
import 'package:quran_app/features/radio/presentation/bloc/radio_bloc.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/components/collapsed_radio_player.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/components/expanded_radio_player.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/components/radio_player_ui_manager.dart';

class RadioMiniPlayerWidget extends StatefulWidget {
  const RadioMiniPlayerWidget({super.key});

  @override
  State<RadioMiniPlayerWidget> createState() => _RadioMiniPlayerWidgetState();
}

class _RadioMiniPlayerWidgetState extends State<RadioMiniPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RadioBloc, RadioState>(
      listenWhen: (previous, current) =>
          previous.currentStation != current.currentStation ||
          previous.playbackStatus != current.playbackStatus,
      listener: (context, state) {
        final manager = RadioPlayerUiManager.instance;
        if (!manager.boxController.isAttached) {
          return;
        }

        if (!state.hasActiveStation ||
            state.playbackStatus == RadioPlaybackStatus.idle ||
            state.playbackStatus == RadioPlaybackStatus.stopped) {
          manager.clearPending();
          manager.boxController.hideBox();
          return;
        }

        manager.boxController.showBox();
        if (manager.pendingOpen) {
          manager.boxController.openBox();
          manager.clearPending();
        }
      },
      buildWhen: (previous, current) =>
          previous.currentStation != current.currentStation ||
          previous.playbackStatus != current.playbackStatus,
      builder: (context, state) {
        final station = state.currentStation;
        if (station == null ||
            state.playbackStatus == RadioPlaybackStatus.idle ||
            state.playbackStatus == RadioPlaybackStatus.stopped) {
          return const SizedBox.shrink();
        }

        return SafeArea(
          top: false,
          bottom: false,
          child: SizedBox(
            width: double.infinity,
            height: context.getScreenHeight() * 0.80,
            child: SlidingBox(
              controller: RadioPlayerUiManager.instance.boxController,
              minHeight: 92.h,
              maxHeight: context.getScreenHeight() * 0.80,
              color: Colors.transparent,
              draggableIconVisible: false,
              collapsed: true,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28.r),
                topRight: Radius.circular(28.r),
              ),
              collapsedBody: CollapsedRadioPlayer(
                station: station,
                isPlaying: state.isPlaying,
              ),
              physics: const NeverScrollableScrollPhysics(),
              body: ExpandedRadioPlayer(
                station: station,
                isPlaying: state.isPlaying,
                isLoading: state.isLoadingPlayback,
              ),
            ),
          ),
        );
      },
    );
  }
}
