import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:quran_app/features/young_muslim/domain/entities/young_muslim_entities.dart';
import 'package:quran_app/features/young_muslim/presentation/bloc/young_muslim_bloc.dart';
import 'package:quran_app/features/young_muslim/presentation/view/pages/young_muslim_player_screen.dart';
import 'package:quran_app/features/young_muslim/presentation/view/widgets/young_muslim_quiz_sheet.dart';
import 'package:quran_app/features/young_muslim/presentation/view/widgets/young_muslim_rewards_sheet.dart';
import 'package:quran_app/features/young_muslim/presentation/view/widgets/young_muslim_shared_widgets.dart';
import 'package:quran_app/features/young_muslim/presentation/view/young_muslim_provider.dart';
import 'package:quran_app/l10n/l10n.dart';

part 'young_muslim_video_details_screen_content.dart';

class YoungMuslimVideoDetailsScreen extends StatefulWidget {
  const YoungMuslimVideoDetailsScreen({
    required this.videoId,
    super.key,
  });

  final String videoId;

  @override
  State<YoungMuslimVideoDetailsScreen> createState() =>
      _YoungMuslimVideoDetailsScreenState();
}

class _YoungMuslimVideoDetailsScreenState
    extends State<YoungMuslimVideoDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<YoungMuslimBloc>()
        .add(YoungMuslimVideoRequested(widget.videoId));
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Theme(
      data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
      child: AppScaffoldWidget(
        showLargeHeader: false,
        initialOffset: null,
        titleWidget: BlocSelector<YoungMuslimBloc, YoungMuslimState, String>(
          selector: (state) {
            final details = state.videoDetails;
            if (details != null && details.video.id == widget.videoId) {
              return details.video.topicTitle;
            }
            return context.l10n.youngMuslimTitle;
          },
          builder: (context, title) => Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: skin.ink,
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: ColoredBox(
          color: skin.ground,
          child: BlocBuilder<YoungMuslimBloc, YoungMuslimState>(
            buildWhen: (previous, current) {
              return previous.videoState != current.videoState ||
                  previous.videoDetails != current.videoDetails ||
                  previous.errorMessage != current.errorMessage;
            },
            builder: (context, state) {
              final details = state.videoDetails;
              final hasCurrentDetails =
                  details != null && details.video.id == widget.videoId;

              Widget child;
              if (!hasCurrentDetails &&
                  state.videoState == RequestState.error) {
                child = _buildErrorBody(context, state.errorMessage);
              } else if (!hasCurrentDetails) {
                child = const YoungMuslimLoadingPanel();
              } else {
                child = _buildVideoDetailsContent(context, details);
              }

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: KeyedSubtree(
                  key: ValueKey(
                    '${state.videoState.name}_'
                    '${details?.video.id ?? widget.videoId}',
                  ),
                  child: child,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
