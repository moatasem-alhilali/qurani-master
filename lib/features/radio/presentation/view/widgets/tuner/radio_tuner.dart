import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/radio/data/models/radio_station_model.dart';
import 'package:quran_app/features/radio/presentation/bloc/radio_bloc.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/radio_station_artwork.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/radio_waveform.dart';
import 'package:quran_app/features/radio/presentation/view/widgets/tuner/radio_dial_painter.dart';

/// موضع القرص الكسري، مع بديل آمن قبل أوّل تخطيط.
///
/// قراءة `controller.page` قبل أن تُعرف أبعاد الـ viewport تُلقي استثناءً،
/// وهي حال أوّل إطار في كل مرّة تُفتح فيها الصفحة.
double tunerPosition(PageController controller, int fallback) {
  if (!controller.hasClients) return fallback.toDouble();
  if (!controller.position.hasContentDimensions) return fallback.toDouble();
  return controller.page ?? fallback.toDouble();
}

/// المؤشّر: قرص راديو تُديره بإصبعك بدل قائمة تنقر فيها.
///
/// الفكرة كلّها هنا — الصفحة القديمة كانت أربعة وعشرين صفًّا متطابقًا يحمل
/// كلٌّ منها النصّ نفسه («بثّ مباشر متواصل»)، فلا إحساس بالمكان ولا بالانتقال.
/// صار التنقّل **سحبًا أفقيًّا**: الأغلفة تمرّ، والتدريج ينزلق تحت الإبرة،
/// ولكل محطة تُعبَر نقرةُ اهتزاز كمِسنَنة القرص الحقيقي.
///
/// وقاعدة الراديو الحقيقي محفوظة: القرص لا يُسمِع شيئًا والجهاز مطفأ. تدوير
/// القرص قبل التشغيل تصفّحٌ صامت؛ وبعده ينتقل البثّ مع كل استقرار.
class RadioTuner extends StatefulWidget {
  const RadioTuner({
    required this.controller,
    required this.stations,
    required this.currentIndex,
    required this.isPowered,
    required this.isPlaying,
    required this.isLoading,
    required this.leading,
    required this.trailing,
    super.key,
  });

  final PageController controller;
  final List<RadioStationModel> stations;
  final int currentIndex;
  final bool isPowered;
  final bool isPlaying;
  final bool isLoading;

  /// يجلسان على جانبي زرّ التشغيل: مؤقّت النوم والمفضّلة.
  final Widget leading;
  final Widget trailing;

  @override
  State<RadioTuner> createState() => _RadioTunerState();
}

class _RadioTunerState extends State<RadioTuner> {
  /// مهلة قبل الاتصال بالمحطة المستقرّة.
  ///
  /// بدونها يفتح مرورٌ سريع على عشر محطات عشرَ وصلات بثّ، ويسمع المستخدم
  /// قطعًا متتابعة. المهلة تجعل الاتصال يقع مرّة واحدة عند الاستقرار.
  static const _settleDelay = Duration(milliseconds: 430);

  Timer? _settle;
  int? _pendingIndex;

  @override
  void dispose() {
    _settle?.cancel();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (index < 0 || index >= widget.stations.length) return;

    HapticFeedback.selectionClick();
    _pendingIndex = index;
    _settle?.cancel();
    _settle = Timer(_settleDelay, _commit);
  }

  void _commit() {
    final index = _pendingIndex;
    _pendingIndex = null;
    if (index == null || !mounted) return;
    if (index < 0 || index >= widget.stations.length) return;

    final station = widget.stations[index];

    // الجهاز يعمل: ننقل البثّ. مطفأ: نغيّر المعروض فقط بلا شبكة.
    context.read<RadioBloc>().add(
          widget.isPowered
              ? RadioStationPlayRequested(station)
              : RadioStationPreviewed(station),
        );
  }

  void _togglePower() {
    HapticFeedback.lightImpact();
    context.read<RadioBloc>().add(const RadioTogglePlayPauseRequested());
  }

  void _stop() {
    HapticFeedback.mediumImpact();
    context.read<RadioBloc>().add(const RadioStopRequested());
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final stations = widget.stations;
    if (stations.isEmpty) return const SizedBox.shrink();

    final index = widget.currentIndex.clamp(0, stations.length - 1);
    final station = stations[index];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 128.h,
          child: PageView.builder(
            controller: widget.controller,
            itemCount: stations.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, i) => _TunerCover(
              controller: widget.controller,
              index: i,
              station: stations[i],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            station.shortName,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: skin.ink,
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
        ),
        SizedBox(height: 5.h),
        _TunerStatus(
          isPowered: widget.isPowered,
          isPlaying: widget.isPlaying,
          isLoading: widget.isLoading,
          kindLabel: station.kind.label,
        ),
        SizedBox(height: 12.h),
        _DialStrip(
          controller: widget.controller,
          fallbackIndex: index,
          count: stations.length,
        ),
        SizedBox(height: 14.h),
        Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.leading,
                  // «إيقاف» يختلف عن «إيقاف مؤقّت»: يُغلق الوصلة ويطفئ
                  // الجهاز. ولا معنى له والجهاز مطفأ أصلًا، فلا يظهر.
                  if (widget.isPowered) ...[
                    SizedBox(width: 6.w),
                    _SmallAction(
                      icon: AppIcons.stop,
                      label: 'إيقاف البثّ',
                      onTap: _stop,
                    ),
                  ],
                ],
              ),
            ),
            _PowerButton(
              isPlaying: widget.isPlaying,
              isLoading: widget.isLoading,
              onTap: _togglePower,
            ),
            Expanded(child: Align(child: widget.trailing)),
          ],
        ),
      ],
    );
  }
}

/// غلاف محطة على القرص: يكبر كلّما اقترب من الإبرة ويبهت كلّما ابتعد.
class _TunerCover extends StatelessWidget {
  const _TunerCover({
    required this.controller,
    required this.index,
    required this.station,
  });

  final PageController controller;
  final int index;
  final RadioStationModel station;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final distance = (tunerPosition(controller, index) - index).abs();
        final near = (1 - distance).clamp(0.0, 1.0);
        final scale = 0.62 + 0.38 * Curves.easeOut.transform(near);

        return Center(
          child: Opacity(
            opacity: 0.34 + 0.66 * near,
            child: Transform.scale(scale: scale, child: child),
          ),
        );
      },
      child: _CoverArt(station: station),
    );
  }
}

class _CoverArt extends StatelessWidget {
  const _CoverArt({required this.station});

  final RadioStationModel station;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: skin.raisedShadow,
      ),
      child: RadioStationArtwork(
        imageUrl: station.imageUrl,
        size: 112.w,
        borderRadius: 20.r,
        initials: station.initials,
      ),
    );
  }
}

/// سطر الحالة تحت الاسم: نوع المحطة، وحالة البثّ، وموجة تتحرّك إن كان يعمل.
class _TunerStatus extends StatelessWidget {
  const _TunerStatus({
    required this.isPowered,
    required this.isPlaying,
    required this.isLoading,
    required this.kindLabel,
  });

  final bool isPowered;
  final bool isPlaying;
  final bool isLoading;
  final String kindLabel;

  String get _label {
    if (isLoading) return 'جارٍ الالتقاط…';
    if (isPlaying) return 'بثّ مباشر';
    if (isPowered) return 'متوقّف مؤقّتًا';
    return 'اضغط للتشغيل';
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          kindLabel,
          style: TextStyle(
            color: skin.inkSoft.withValues(alpha: 0.6),
            fontSize: 9.5.sp,
            fontWeight: FontWeight.w600,
            height: 1.35,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Container(
            width: 3.w,
            height: 3.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: skin.inkSoft.withValues(alpha: 0.35),
            ),
          ),
        ),
        Text(
          _label,
          style: TextStyle(
            color:
                isPlaying ? skin.accent : skin.inkSoft.withValues(alpha: 0.78),
            fontSize: 9.5.sp,
            fontWeight: FontWeight.w700,
            height: 1.35,
          ),
        ),
        if (isPlaying) ...[
          SizedBox(width: 7.w),
          const RadioWaveform(isActive: true),
        ],
      ],
    );
  }
}

/// شريط التدريج والإبرة.
class _DialStrip extends StatelessWidget {
  const _DialStrip({
    required this.controller,
    required this.fallbackIndex,
    required this.count,
  });

  final PageController controller;
  final int fallbackIndex;
  final int count;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return SizedBox(
      height: 30.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) => CustomPaint(
                size: Size.infinite,
                painter: RadioDialPainter(
                  position: tunerPosition(controller, fallbackIndex),
                  count: count,
                  gap: 26.w,
                  isRtl: isRtl,
                  tickColor: skin.ink,
                  accent: skin.accent,
                ),
              ),
            ),
          ),
          // الإبرة ثابتة في المنتصف والعالم يمرّ تحتها.
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 2.w,
              height: 9.h,
              decoration: BoxDecoration(
                color: skin.accent,
                borderRadius: BorderRadius.circular(999.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// زرّ ثانوي بجانب زرّ التشغيل: أيقونة على الأرضية بلا تعبئة ولا حدّ، حتى
/// يبقى في المشهد عنصر بارز واحد.
class _SmallAction extends StatelessWidget {
  const _SmallAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final HugeIconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);

    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: AppIcon(
            icon,
            color: skin.inkSoft.withValues(alpha: 0.6),
            size: 18.sp,
          ),
        ),
      ),
    );
  }
}

/// زرّ التشغيل: العنصر البارز الوحيد في المشهد.
class _PowerButton extends StatelessWidget {
  const _PowerButton({
    required this.isPlaying,
    required this.isLoading,
    required this.onTap,
  });

  final bool isPlaying;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final onAccent = skin.isDark ? AppColors.brandNight : AppColors.brandIvory;

    return Semantics(
      button: true,
      label: isPlaying ? 'إيقاف مؤقّت' : 'تشغيل',
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 58.w,
          height: 58.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.gold,
            boxShadow: skin.raisedShadow,
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation(onAccent),
                    ),
                  )
                : AppIcon(
                    isPlaying ? AppIcons.pause : AppIcons.play,
                    color: onAccent,
                    size: 26.sp,
                    strokeWidth: 2.2,
                  ),
          ),
        ),
      ),
    );
  }
}
