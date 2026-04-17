import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/failure/request_state.dart';
import 'package:quran_app/core/widgets/app_scaffold/app_scaffold_widget.dart';
import 'package:quran_app/features/radio/data/models/radio_station_model.dart';
import 'package:quran_app/features/radio/presentation/bloc/radio_bloc.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/radio_mini_player_widget.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/radio_station_artwork.dart';

class RadioScreen extends StatelessWidget {
  const RadioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<RadioBloc>(),
      child: Stack(
        children: [
          AppScaffoldWidget(
            title: 'الإذاعة',
            initialOffset: 0,
            body: BlocConsumer<RadioBloc, RadioState>(
              listenWhen: (previous, current) =>
                  previous.errorMessage != current.errorMessage &&
                  current.errorMessage != null,
              listener: (context, state) {
                final message = state.errorMessage;
                if (message == null) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              },
              builder: (context, state) {
                if (state.loadState == RequestState.loading &&
                    state.stations.isEmpty) {
                  return const _RadioStationsLoadingView();
                }

                return Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 120.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _RadioHeroCard(
                        station: state.currentStation,
                        isPlaying: state.isPlaying,
                        onOpenNowPlaying: state.currentStation == null
                            ? null
                            : openRadioPlayerBox,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'المحطات المتاحة',
                        style: context.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      ...state.stations.map(
                        (station) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: _RadioStationTile(
                            station: station,
                            isCurrent: state.currentStation?.id == station.id,
                            isPlayingCurrent:
                                state.currentStation?.id == station.id &&
                                    state.isPlaying,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: RadioMiniPlayerWidget(),
          ),
        ],
      ),
    );
  }
}

class _RadioHeroCard extends StatelessWidget {
  const _RadioHeroCard({
    required this.station,
    required this.isPlaying,
    required this.onOpenNowPlaying,
  });

  final RadioStationModel? station;
  final bool isPlaying;
  final VoidCallback? onOpenNowPlaying;

  @override
  Widget build(BuildContext context) {
    final accent = context.primaryColor;
    final secondaryAccent = context.secondaryColor;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.surfaceColor,
            Color.lerp(
                  context.surfaceVariant,
                  accent,
                  0.10,
                ) ??
                context.surfaceVariant,
          ],
        ),
        border: Border.all(
          color: context.outline.withValues(alpha: 0.12),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -26.h,
            left: -20.w,
            child: Container(
              width: 82.w,
              height: 82.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: secondaryAccent.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -18.h,
            right: -12.w,
            child: Container(
              width: 94.w,
              height: 94.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withValues(alpha: 0.07),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  station == null ? 'إذاعات مباشرة' : 'المحطة الحالية',
                  style: context.labelMedium?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  if (station != null)
                    RadioStationArtwork(
                      imageUrl: station!.imageUrl,
                      heroTag: 'radio_station_${station!.id}',
                      size: 72.w,
                      borderRadius: 24.r,
                    )
                  else
                    Container(
                      width: 72.w,
                      height: 72.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                        color: accent.withValues(alpha: 0.08),
                      ),
                      child: Icon(
                        Icons.graphic_eq_rounded,
                        color: accent,
                        size: 28.sp,
                      ),
                    ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          station?.name ?? 'اختر محطة وابدأ البث المباشر',
                          style: context.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          station == null
                              ? 'استمع إلى إذاعات قرآنية وإسلامية مع '
                                  'استمرار التشغيل في الخلفية.'
                              : (isPlaying
                                  ? 'يتم الآن تشغيل الإذاعة مع دعم الخلفية '
                                      'وإشعار النظام.'
                                  : 'المحطة محددة ويمكنك متابعة التشغيل من '
                                      'المشغل السفلي.'),
                          style: context.bodyMedium?.copyWith(
                            color: context.onSurfaceVariant
                                .withValues(alpha: 0.88),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (station != null) ...[
                SizedBox(height: 16.h),
                FilledButton(
                  onPressed: onOpenNowPlaying,
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: context.onPrimaryColor,
                    minimumSize: Size(double.infinity, 48.h),
                  ),
                  child: Text(isPlaying ? 'فتح المشغل' : 'إكمال من المشغل'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _RadioStationTile extends StatelessWidget {
  const _RadioStationTile({
    required this.station,
    required this.isCurrent,
    required this.isPlayingCurrent,
  });

  final RadioStationModel station;
  final bool isCurrent;
  final bool isPlayingCurrent;

  @override
  Widget build(BuildContext context) {
    final accent = isCurrent ? context.primaryColor : context.secondaryColor;
    return InkWell(
      onTap: () {
        context.read<RadioBloc>().add(RadioStationPlayRequested(station));
        openRadioPlayerBox();
      },
      borderRadius: BorderRadius.circular(22.r),
      child: Ink(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.r),
          color: context.surfaceColor,
          border: Border.all(
            color: isCurrent
                ? accent.withValues(alpha: 0.26)
                : context.outline.withValues(alpha: 0.10),
          ),
          boxShadow: [
            BoxShadow(
              color: context.shadow.withValues(alpha: 0.06),
              blurRadius: 12.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: Row(
          children: [
            RadioStationArtwork(
              imageUrl: station.imageUrl,
              heroTag: 'radio_station_${station.id}',
              size: 62.w,
              borderRadius: 20.r,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          station.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (isCurrent)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Text(
                            isPlayingCurrent ? 'مباشر' : 'آخر محطة',
                            style: context.labelSmall?.copyWith(
                              color: accent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'بث مباشر مستمر مع دعم التشغيل في الخلفية',
                    style: context.bodySmall?.copyWith(
                      color: context.onSurfaceVariant.withValues(alpha: 0.86),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                color: accent.withValues(alpha: 0.10),
              ),
              child: Icon(
                isPlayingCurrent
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioStationsLoadingView extends StatelessWidget {
  const _RadioStationsLoadingView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 152.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28.r),
            color: context.surfaceVariant.withValues(alpha: 0.46),
          ),
        ),
        SizedBox(height: 16.h),
        ...List.generate(
          5,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Container(
              height: 90.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.r),
                color: context.surfaceVariant.withValues(alpha: 0.38),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
