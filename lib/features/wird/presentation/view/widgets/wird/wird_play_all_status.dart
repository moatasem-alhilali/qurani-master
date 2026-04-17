import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/wird/presentation/bloc/wird_bloc.dart';

class WirdPlayAllStatus extends StatelessWidget {
  const WirdPlayAllStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WirdBloc, WirdState>(
      buildWhen: (p, c) => 
        p.isQueueRepeated != c.isQueueRepeated ||
        p.activeItemIndex != c.activeItemIndex ||
        p.processingState != c.processingState ||
        p.currentRepeatIndex != c.currentRepeatIndex ||
        p.currentRepeatTotal != c.currentRepeatTotal ||
        p.data != c.data,
      builder: (context, state) {
        final items = state.data ?? [];
        if (!state.isQueueRepeated ||
            state.activeItemIndex == null ||
            state.activeItemIndex! < 0 ||
            state.activeItemIndex! >= items.length) {
          if (state.isQueueRepeated &&
              state.processingState == ProcessingState.completed &&
              items.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CardWidget(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  'تم الانتهاء من تشغيل جميع الأذكار.',
                  style: context.titleSmall,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }

        final item = items[state.activeItemIndex!];
        final repeatTotal =
            state.currentRepeatTotal == 0 ? item.counter : state.currentRepeatTotal;
        final repeatIndex = state.currentRepeatIndex == 0 ? 1 : state.currentRepeatIndex;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: CardWidget(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الذكر الحالي',
                  style: context.labelMedium?.copyWith(
                    color: context.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.title,
                  style: context.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  'التكرار: $repeatIndex / $repeatTotal',
                  style: context.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
