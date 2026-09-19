import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/features/wird/presentation/bloc/wird_bloc.dart';
import 'package:quran_app/l10n/l10n.dart';

/// حالة التشغيل المتتابع: سطر واحد يقول ما يُتلى الآن وكم بقي من تكراره.
class WirdPlayAllStatus extends StatelessWidget {
  const WirdPlayAllStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

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
        final index = state.activeItemIndex;

        if (!state.isQueueRepeated ||
            index == null ||
            index < 0 ||
            index >= items.length) {
          if (state.isQueueRepeated &&
              state.processingState == ProcessingState.completed &&
              items.isNotEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Text(
                context.l10n.wirdPlayAllFinished,
                style: TextStyle(
                  color: skin.accent,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }

        final item = items[index];
        final repeatTotal = state.currentRepeatTotal == 0
            ? item.counter
            : state.currentRepeatTotal;
        final repeatIndex =
            state.currentRepeatIndex == 0 ? 1 : state.currentRepeatIndex;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.wirdNowPlaying,
                      style: TextStyle(
                        color: skin.accent,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: skin.ink,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                context.l10n.wirdRepeatProgress(repeatIndex, repeatTotal),
                style: TextStyle(
                  color: skin.inkSoft.withValues(alpha: 0.78),
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
