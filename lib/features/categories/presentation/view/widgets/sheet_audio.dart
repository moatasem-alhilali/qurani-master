import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/services/download_service.dart';
import 'package:quran_app/core/services/service_locator.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/audios/data/remote/base_audio_repository_imp.dart';
import 'package:quran_app/features/audios/presentation/bloc/base_audio_bloc.dart';
import 'package:quran_app/features/categories/data/model/category_video_model.dart';
import 'package:quran_app/features/categories/presentation/view/widgets/category_skin_widgets.dart';

/// يفتح ورقة المواد الصوتية بلغة الشاشة نفسها: أرضية واحدة وصفوف نحيلة.
Future<void> showCategoryAudiosSheet(
  BuildContext context, {
  required CategoryDetailModel baseData,
}) async {
  final skin = AppSkin.of(context);

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: skin.ground,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
    ),
    builder: (sheetContext) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        minChildSize: 0.45,
        builder: (context, scrollController) {
          return SheetAudios(
            baseData: baseData,
            scrollController: scrollController,
          );
        },
      );
    },
  );
}

class SheetAudios extends StatelessWidget {
  const SheetAudios({
    required this.baseData,
    super.key,
    this.scrollController,
  });

  final CategoryDetailModel baseData;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return BlocProvider(
      create: (context) => BaseAudioBloc(
        repositoryImpl: sl.get<BaseAudioRepositoryImpl>(),
      )..add(BaseAudioDetailEvent(baseData.apiUrl ?? '')),
      child: ColoredBox(
        color: skin.ground,
        child: BlocBuilder<BaseAudioBloc, BaseAudioState>(
          builder: (context, state) {
            final body = switch (state.famousBaseAudioState) {
              RequestState.initial ||
              RequestState.loading =>
                const [CategoryThinLoader()],
              RequestState.error => const [
                  CategoryNotice(message: 'تعذر تحميل المواد الصوتية.'),
                ],
              RequestState.success => [
                  for (var i = 0; i < state.baseAudioDetail.length; i++)
                    _AudioRow(
                      data: state.baseAudioDetail[i],
                      index: i,
                      audioPlayer: state.audioPlayer,
                      isLast: i == state.baseAudioDetail.length - 1,
                    ),
                ],
            };

            return ListView(
              controller: scrollController,
              padding: EdgeInsets.only(bottom: 24.h),
              children: [
                SizedBox(height: 10.h),
                Center(
                  child: Container(
                    width: 34.w,
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: skin.hairline,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        baseData.title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: skin.ink,
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      if ((baseData.description ?? '').trim().isNotEmpty)
                        Text(
                          baseData.description!,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: skin.inkSoft.withValues(alpha: 0.78),
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                    ],
                  ),
                ),
                skin.divider(),
                ...body,
              ],
            );
          },
        ),
      ),
    );
  }
}

/// صفّ مادة صوتية: زرّ تشغيل صغير، ثم وصفها، ثم حجمها وزرّ التحميل.
class _AudioRow extends StatefulWidget {
  const _AudioRow({
    required this.data,
    required this.index,
    required this.audioPlayer,
    required this.isLast,
  });

  final dynamic data;
  final int index;
  final AudioPlayer? audioPlayer;
  final bool isLast;

  @override
  State<_AudioRow> createState() => _AudioRowState();
}

class _AudioRowState extends State<_AudioRow> {
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

  String? get _url => widget.data['url'] as String?;

  String get _description =>
      (widget.data['description'] as String?)?.trim() ?? '';

  String get _size => (widget.data['size'] as String?)?.trim() ?? '';

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final player = widget.audioPlayer;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: widget.isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          if (player != null)
            _PlayControl(audioPlayer: player, itemIndex: widget.index),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _description.isEmpty ? 'مقطع ${widget.index + 1}' : _description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: skin.ink,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                if (_size.isNotEmpty)
                  Text(
                    _size,
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
          SizedBox(width: 8.w),
          CategoryActionButton(
            label: 'تحميل',
            icon: AppIcons.download,
            isPrimary: false,
            onTap: () {
              final url = _url;
              if (url == null || url.isEmpty) return;
              HapticFeedback.selectionClick();
              _downloadService.download(
                url,
                _description.isEmpty ? 'مقطع صوتي' : _description,
              );
            },
          ),
        ],
      ),
    );
  }
}

/// زرّ تشغيل/إيقاف واحد يتابع حالة المشغّل مباشرة.
class _PlayControl extends StatelessWidget {
  const _PlayControl({
    required this.audioPlayer,
    required this.itemIndex,
  });

  final AudioPlayer audioPlayer;
  final int itemIndex;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return StreamBuilder<int?>(
      stream: audioPlayer.currentIndexStream,
      builder: (context, indexSnapshot) {
        return StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final playing = playerState?.playing ?? false;
            final isCurrent = indexSnapshot.data == itemIndex;
            final isPlaying = playing &&
                isCurrent &&
                playerState?.processingState != ProcessingState.completed;

            return InkWell(
              borderRadius: BorderRadius.circular(10.r),
              onTap: () {
                HapticFeedback.selectionClick();
                if (isPlaying) {
                  audioPlayer.pause();
                  return;
                }
                audioPlayer
                  ..seek(Duration.zero, index: itemIndex)
                  ..play();
              },
              child: Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: skin.iconChip,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: AppIcon(
                    isPlaying ? AppIcons.pause : AppIcons.play,
                    color: skin.accent,
                    size: 15.sp,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
