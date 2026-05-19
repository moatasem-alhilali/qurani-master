import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/young_muslim/domain/entities/young_muslim_entities.dart';
import 'package:quran_app/features/young_muslim/presentation/bloc/young_muslim_bloc.dart';
import 'package:quran_app/features/young_muslim/presentation/view/pages/young_muslim_player_screen.dart';
import 'package:quran_app/features/young_muslim/presentation/view/widgets/young_muslim_quiz_sheet.dart';
import 'package:quran_app/features/young_muslim/presentation/view/widgets/young_muslim_rewards_sheet.dart';
import 'package:quran_app/features/young_muslim/presentation/view/widgets/young_muslim_shared_widgets.dart';
import 'package:quran_app/features/young_muslim/presentation/view/young_muslim_provider.dart';

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
    return AppScaffoldWidget(
      showLargeHeader: false,
      initialOffset: null,
      titleWidget: BlocSelector<YoungMuslimBloc, YoungMuslimState, String>(
        selector: (state) {
          final details = state.videoDetails;
          if (details != null && details.video.id == widget.videoId) {
            return details.video.topicTitle;
          }
          return 'المسلم الصغير';
        },
        builder: (context, title) => Text(title),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
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
            if (!hasCurrentDetails && state.videoState == RequestState.error) {
              child = _buildErrorBody(context, state.errorMessage);
            } else if (!hasCurrentDetails) {
              child = _buildLoadingBody();
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
    );
  }
}
