import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/extensions/request_state/request_state_sliver_extension.dart';
import 'package:quran_app/core/services/download_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/audios/data/remote/base_audio_repository_imp.dart';
import 'package:quran_app/features/audios/presentation/bloc/base_audio_bloc.dart';
import 'package:quran_app/features/audios/presentation/view/widgets/audio_player_bar.dart';
import 'package:quran_app/features/audios/presentation/view/widgets/audio_row.dart';
import 'package:quran_app/features/home/presentation/view/widgets/home_section_header.dart';
import 'package:quran_app/l10n/l10n.dart';

/// تفاصيل السلسلة الصوتية: المشغّل في الأعلى ثم مقاطعها صفًّا صفًّا.
///
/// كانت الشاشة تفتح فارغة (الجسم كان معطّلاً)، فأُعيد بناؤها على بيانات
/// الـ bloc نفسها: شريط تقدّم وأزرار تحكّم، ثم قائمة نحيلة بكل مقطع وحجمه
/// وزرّ تنزيله.
class BaseAudioDetail extends StatefulWidget {
  const BaseAudioDetail({super.key, this.data});

  final dynamic data;

  @override
  State<BaseAudioDetail> createState() => _BaseAudioDetailState();
}

class _BaseAudioDetailState extends State<BaseAudioDetail> {
  final DownloadService _downloadService = DownloadService();

  @override
  void initState() {
    super.initState();
    _downloadService.init();
  }

  @override
  void dispose() {
    _downloadService.remove();
    super.dispose();
  }

  /// عنوان المقطع: وصفه إن وُجد، وإلّا ترتيبه في السلسلة.
  String _trackTitle(dynamic track, int index) {
    final description = audioFieldOf(track, 'description').trim();
    if (description.isNotEmpty) {
      return description;
    }
    final title = audioFieldOf(track, 'title').trim();
    return title.isNotEmpty ? title : context.l10n.audiosTrackNumber(index + 1);
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final title = audioFieldOf(widget.data, 'title');
    final apiUrl = audioFieldOf(widget.data, 'api_url');

    return BlocProvider(
      create: (context) => BaseAudioBloc(
        repositoryImpl: sl.get<BaseAudioRepositoryImpl>(),
      )..add(BaseAudioDetailEvent(apiUrl)),
      child: Theme(
        data: Theme.of(context).copyWith(scaffoldBackgroundColor: skin.ground),
        child: BlocBuilder<BaseAudioBloc, BaseAudioState>(
          builder: (context, state) {
            final tracks = state.baseAudioDetail;
            final player = state.audioPlayer;

            return AppScaffoldWidget(
              title: title,
              slivers: [
                if (player != null && tracks.isNotEmpty)
                  SliverToBoxAdapter(
                    child: AudioPlayerBar(
                      player: player,
                      trackTitleOf: (index) {
                        if (index < 0 || index >= tracks.length) {
                          return title;
                        }
                        return _trackTitle(tracks[index], index);
                      },
                    ),
                  ),
                SliverToBoxAdapter(child: skin.divider()),
                SliverToBoxAdapter(
                  child: HomeSectionHeader(
                    title: context.l10n.audiosTracksHeader,
                  ),
                ),
                state.famousBaseAudioState.whenSliver<dynamic>(
                  sliverList: tracks,
                  onSuccess: () => SliverList.builder(
                    itemCount: tracks.length,
                    itemBuilder: (context, index) {
                      return _TrackRow(
                        title: _trackTitle(tracks[index], index),
                        size: audioFieldOf(tracks[index], 'size'),
                        url: audioFieldOf(tracks[index], 'url'),
                        index: index,
                        isLast: index == tracks.length - 1,
                        player: player,
                        downloadService: _downloadService,
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 18.h)),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// صفّ مقطع: رقمه، عنوانه، حجمه، ثم زرّ التنزيل.
///
/// المقطع الجاري يُعرف بلون حبره ونبرة خطّه، لا بإطار حوله — الارتفاع محجوز
/// لزرّ التشغيل في المشغّل أعلى الشاشة.
class _TrackRow extends StatelessWidget {
  const _TrackRow({
    required this.title,
    required this.size,
    required this.url,
    required this.index,
    required this.isLast,
    required this.player,
    required this.downloadService,
  });

  final String title;
  final String size;
  final String url;
  final int index;
  final bool isLast;
  final AudioPlayer? player;
  final DownloadService downloadService;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return StreamBuilder<int?>(
      stream: player?.currentIndexStream ?? const Stream<int?>.empty(),
      builder: (context, snapshot) {
        final currentIndex = snapshot.data ?? player?.currentIndex;
        final isCurrent = currentIndex == index;

        return InkWell(
          onTap: player == null
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  player!
                    ..seek(Duration.zero, index: index)
                    ..play();
                },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: isLast
                ? null
                : BoxDecoration(
                    border: Border(bottom: BorderSide(color: skin.hairline)),
                  ),
            child: Row(
              children: [
                SizedBox(
                  width: 22.w,
                  child: Text(
                    '${index + 1}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isCurrent
                          ? skin.accent
                          : skin.inkSoft.withValues(alpha: 0.62),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isCurrent ? skin.accent : skin.ink,
                          fontSize: 12.5.sp,
                          fontWeight:
                              isCurrent ? FontWeight.w800 : FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                      if (size.isNotEmpty)
                        Text(
                          size,
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
                if (url.isNotEmpty)
                  InkWell(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      downloadService.download(url, title);
                    },
                    borderRadius: BorderRadius.circular(10.r),
                    child: Padding(
                      padding: EdgeInsets.all(5.w),
                      child: AppIcon(
                        AppIcons.download,
                        color: skin.accent,
                        size: 15.sp,
                      ),
                    ),
                  ),
                SizedBox(width: 4.w),
                AppIcon(
                  isCurrent ? AppIcons.pause : AppIcons.play,
                  color: isCurrent
                      ? skin.accent
                      : skin.inkSoft.withValues(alpha: 0.62),
                  size: 15.sp,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
