import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palette_generator_master/palette_generator_master.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/radio/data/models/radio_station_model.dart';
import 'package:quran_app/features/radio/presentation/bloc/radio_bloc.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/radio_station_artwork.dart';
import 'radio_player_ui_manager.dart';

class ExpandedRadioPlayer extends StatefulWidget {
  const ExpandedRadioPlayer({
    super.key,
    required this.station,
    required this.isPlaying,
    required this.isLoading,
  });

  final RadioStationModel station;
  final bool isPlaying;
  final bool isLoading;

  @override
  State<ExpandedRadioPlayer> createState() => _ExpandedRadioPlayerState();
}

class _ExpandedRadioPlayerState extends State<ExpandedRadioPlayer> {
  Color? _dominantColor;

  @override
  void initState() {
    super.initState();
    _updatePalette();
  }

  @override
  void didUpdateWidget(covariant ExpandedRadioPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.station.imageUrl != widget.station.imageUrl) {
      _updatePalette();
    }
  }

  Future<void> _updatePalette() async {
    try {
      final imageProvider = CachedNetworkImageProvider(widget.station.imageUrl);
      final palette = await PaletteGeneratorMaster.fromImageProvider(imageProvider);
      if (mounted) {
        setState(() {
          _dominantColor = palette.dominantColor?.color ?? palette.mutedColor?.color;
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final station = widget.station;
    final isPlaying = widget.isPlaying;
    final isLoading = widget.isLoading;

    final panelSurface = Color.alphaBlend(
      context.primaryContainer.withValues(alpha: 0.12),
      context.surfaceColor,
    );
    final primaryText = context.onSurfaceColor;
    final blurColor = (_dominantColor ?? panelSurface).withValues(alpha: 0.50);

    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(minHeight: context.getScreenHeight() * 0.90),
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: station.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
                child: Container(
                  color: blurColor,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(32.w, 32.h, 32.w, 48.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 48.w),
                      Container(
                        width: 48.w,
                        height: 5.h,
                        margin: EdgeInsets.only(top: 12.h),
                        decoration: BoxDecoration(
                          color: primaryText.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      IconButton(
                        onPressed: RadioPlayerUiManager.instance.closeBox,
                        icon: Icon(Icons.keyboard_arrow_down_rounded, size: 36.sp),
                        color: primaryText.withValues(alpha: 0.8),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 32.r,
                            offset: Offset(0, 16.h),
                          ),
                        ],
                      ),
                      child: RadioStationArtwork(
                        imageUrl: station.imageUrl,
                        heroTag: 'radio_station_${station.id}_expanded',
                        size: context.getScreenHeight() * 0.35,
                        borderRadius: 20.r,
                      ),
                    ),
                  ),
                  SizedBox(height: 48.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          station.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.headlineMedium?.copyWith(
                            color: primaryText,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          isPlaying
                              ? 'البث المباشر يعمل الآن'
                              : isLoading
                                  ? 'جارٍ الاتصال...'
                                  : 'البث متوقف',
                          style: context.titleMedium?.copyWith(
                            color: primaryText.withValues(alpha: 0.65),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 38.h),
                  Column(
                    children: [
                      Container(
                        height: 5.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999.r),
                          color: primaryText.withValues(alpha: 0.15),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerRight,
                          widthFactor: isPlaying ? 1.0 : 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999.r),
                              color: primaryText.withValues(alpha: 0.85),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'مباشر',
                            style: context.labelMedium?.copyWith(
                              color: primaryText.withValues(alpha: 0.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            isPlaying ? 'LIVE' : '- 0:00',
                            style: context.labelMedium?.copyWith(
                              color: primaryText.withValues(alpha: 0.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 42.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          context.read<RadioBloc>().add(
                                const RadioStopRequested(),
                              );
                        },
                        icon: Icon(Icons.stop_rounded, size: 36.sp),
                        color: primaryText.withValues(alpha: 0.8),
                      ),
                      Container(
                        width: 82.w,
                        height: 82.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryText,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 16.r,
                              offset: Offset(0, 8.h),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {
                            context.read<RadioBloc>().add(
                                  const RadioTogglePlayPauseRequested(),
                                );
                          },
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: context.surfaceColor,
                            size: 40.sp,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: RadioPlayerUiManager.instance.closeBox,
                        icon: Icon(Icons.more_horiz_rounded, size: 32.sp),
                        color: primaryText.withValues(alpha: 0.8),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
