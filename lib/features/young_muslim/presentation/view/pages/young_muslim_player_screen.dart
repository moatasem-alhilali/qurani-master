import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/young_muslim/domain/entities/young_muslim_entities.dart';
import 'package:quran_app/features/young_muslim/domain/repositories/young_muslim_repository.dart';
import 'package:quran_app/features/young_muslim/presentation/cubit/young_muslim_player_cubit.dart';
import 'package:quran_app/features/young_muslim/presentation/view/widgets/young_muslim_quiz_sheet.dart';
import 'package:quran_app/features/young_muslim/presentation/view/widgets/young_muslim_shared_widgets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

part 'young_muslim_player_screen_content.dart';

class YoungMuslimPlayerScreen extends StatefulWidget {
  const YoungMuslimPlayerScreen({
    required this.videoId,
    super.key,
  });

  final String videoId;

  @override
  State<YoungMuslimPlayerScreen> createState() =>
      _YoungMuslimPlayerScreenState();
}

class _YoungMuslimPlayerScreenState extends State<YoungMuslimPlayerScreen> {
  late final YoungMuslimPlayerCubit _cubit;
  int _lastCompletionTrigger = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_restorePortraitMode());
    _cubit = YoungMuslimPlayerCubit(
      repository: context.read<YoungMuslimRepository>(),
    )..initialize(widget.videoId);
  }

  @override
  void dispose() {
    unawaited(_restorePortraitMode());
    unawaited(_cubit.persistOnExit());
    unawaited(_cubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<YoungMuslimPlayerCubit, YoungMuslimPlayerState>(
        listenWhen: (previous, current) =>
            previous.completionTrigger != current.completionTrigger,
        listener: (context, state) async {
          if (state.completionTrigger == 0 ||
              state.completionTrigger == _lastCompletionTrigger) {
            return;
          }
          _lastCompletionTrigger = state.completionTrigger;
          await _handleCompletionFlow(state.session);
        },
        child: AppScaffoldWidget(
          title: 'تشغيل آمن للأطفال',
          showLargeHeader: false,
          initialOffset: null,
          body: Padding(
            padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 28.h),
            child: BlocBuilder<YoungMuslimPlayerCubit, YoungMuslimPlayerState>(
              buildWhen: (previous, current) {
                return previous.loadState != current.loadState ||
                    previous.session != current.session ||
                    previous.autoPlayEnabled != current.autoPlayEnabled ||
                    previous.errorMessage != current.errorMessage;
              },
              builder: (context, state) {
                final session = state.session;
                final controller = _cubit.controller;

                Widget child;
                if (session == null && state.loadState == RequestState.error) {
                  child = _PlayerErrorBody(message: state.errorMessage);
                } else if (session == null || controller == null) {
                  child = const YoungMuslimLoadingPanel();
                } else {
                  child = _PlayerContent(
                    session: session,
                    controller: controller,
                    autoPlayEnabled: state.autoPlayEnabled,
                    onToggleAutoPlay: _cubit.toggleAutoPlay,
                    onPlayNext: _cubit.playNextVideo,
                    onPlaySelected: _cubit.playSelectedVideo,
                    onEnterFullScreen: _enterFullScreenMode,
                    onExitFullScreen: _restorePortraitMode,
                  );
                }

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: KeyedSubtree(
                    key: ValueKey(
                      state.session?.video.id ??
                          '${widget.videoId}_${state.loadState.name}',
                    ),
                    child: child,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleCompletionFlow(
    YoungMuslimPlayerSessionEntity? session,
  ) async {
    if (session == null) {
      return;
    }

    if (session.videoQuiz != null) {
      await YoungMuslimQuizSheet.show(
        context: context,
        quizSet: session.videoQuiz!,
        title: 'سؤال الحلقة بعد المشاهدة',
      );
      if (!mounted) {
        return;
      }
    }

    if (session.nextVideo == null && session.seriesQuiz != null) {
      await YoungMuslimQuizSheet.show(
        context: context,
        quizSet: session.seriesQuiz!,
        title: 'تحدي السلسلة',
      );
      if (!mounted) {
        return;
      }
    }

    await _cubit.handlePostQuizAutoPlay();
  }

  Future<void> _enterFullScreenMode() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> _restorePortraitMode() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
}
