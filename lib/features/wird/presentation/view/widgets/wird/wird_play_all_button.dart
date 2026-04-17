import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/features/wird/presentation/bloc/wird_bloc.dart';

class WirdPlayAllButton extends StatelessWidget {
  const WirdPlayAllButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WirdBloc, WirdState>(
      buildWhen: (p, c) =>
          p.itemsWithAudio != c.itemsWithAudio ||
          p.isAudioInitializing != c.isAudioInitializing ||
          p.processingState != c.processingState ||
          p.isQueueRepeated != c.isQueueRepeated ||
          p.isPlaying != c.isPlaying,
      builder: (context, state) {
        final hasAudio = state.itemsWithAudio.isNotEmpty;
        final isBuffering = state.isAudioInitializing ||
            state.processingState == ProcessingState.loading ||
            state.processingState == ProcessingState.buffering;

        if (!hasAudio) {
          return const SizedBox.shrink();
        }

        if (isBuffering) {
          return FilledButton.tonalIcon(
            onPressed: null,
            icon: const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            label: const Text('تهيئة الصوت'),
          );
        }

        var icon = Icons.play_circle_fill_rounded;
        var label = 'تشغيل الكل';

        if (state.isQueueRepeated && state.isPlaying) {
          icon = Icons.pause_circle_filled_rounded;
          label = 'إيقاف مؤقت';
        } else if (state.isQueueRepeated &&
            state.processingState == ProcessingState.completed) {
          icon = Icons.replay_circle_filled_rounded;
          label = 'إعادة التشغيل';
        }

        return FilledButton.tonalIcon(
          onPressed: () => context.read<WirdBloc>().add(TogglePlayAllWirdEvent()),
          icon: Icon(icon),
          label: Text(label),
        );
      },
    );
  }
}
