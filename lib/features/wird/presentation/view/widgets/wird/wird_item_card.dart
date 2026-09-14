import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/core/services/copy_service.dart';
import 'package:quran_app/core/services/url_launcher_service.dart';
import 'package:quran_app/core/theme/app_skin.dart';
import 'package:quran_app/core/util/theme_colors.dart';
import 'package:quran_app/core/widgets/app_icon.dart';
import 'package:quran_app/features/wird/data/models/wird_model.dart';
import 'package:quran_app/features/wird/presentation/view/widgets/wird/wird_info_row.dart';
import 'package:quran_app/gen/fonts.gen.dart';

/// ذكر واحد من الورد.
///
/// لا بطاقة حول كل ذكر: النصّ يجلس على أرضية الصفحة ويفصله خطّ شعرة عمّا
/// بعده. الذكر الذي يُتلى صوتًا الآن وحده هو الذي يرتفع.
class WirdItemCard extends StatefulWidget {
  const WirdItemCard({
    required this.item,
    required this.index,
    required this.remaining,
    required this.onDecrement,
    required this.onReset,
    required this.hasAudio,
    required this.isAudioInitializing,
    required this.isCurrentAudio,
    required this.isAudioPlaying,
    required this.audioProcessingState,
    required this.onAudioPressed,
    super.key,
    this.isLast = false,
  });

  final WirdModel item;
  final int index;
  final int remaining;
  final VoidCallback onDecrement;
  final VoidCallback onReset;
  final bool hasAudio;
  final bool isAudioInitializing;
  final bool isCurrentAudio;
  final bool isAudioPlaying;
  final ProcessingState audioProcessingState;
  final VoidCallback onAudioPressed;
  final bool isLast;

  @override
  State<WirdItemCard> createState() => _WirdItemCardState();
}

class _WirdItemCardState extends State<WirdItemCard> {
  bool showDetails = false;

  Future<void> _openLink(String url) async {
    if (url.trim().isEmpty) return;
    await UrlLauncher.fLaunch(url);
  }

  String _typeLabel(int type) {
    switch (type) {
      case 1:
        return 'صباح فقط';
      case 2:
        return 'مساء فقط';
      default:
        return 'صباح ومساء';
    }
  }

  ({HugeIconData icon, String tooltip, bool busy, bool enabled}) _audioLook() {
    if (!widget.hasAudio) {
      return (
        icon: AppIcons.mute,
        tooltip: 'لا يوجد ملف صوتي',
        busy: false,
        enabled: false,
      );
    }

    final isBuffering = widget.isAudioInitializing ||
        (widget.isCurrentAudio &&
            (widget.audioProcessingState == ProcessingState.loading ||
                widget.audioProcessingState == ProcessingState.buffering));

    if (isBuffering) {
      return (
        icon: AppIcons.sound,
        tooltip: 'جاري التحميل',
        busy: true,
        enabled: false,
      );
    }

    if (widget.isCurrentAudio && widget.isAudioPlaying) {
      return (
        icon: AppIcons.pause,
        tooltip: 'إيقاف مؤقت',
        busy: false,
        enabled: true,
      );
    }

    if (widget.isCurrentAudio &&
        widget.audioProcessingState == ProcessingState.completed) {
      return (
        icon: AppIcons.replay,
        tooltip: 'إعادة التشغيل',
        busy: false,
        enabled: true,
      );
    }

    return (
      icon: AppIcons.play,
      tooltip: 'تشغيل الصوت',
      busy: false,
      enabled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final item = widget.item;
    final audio = _audioLook();
    final isActive = widget.isCurrentAudio && widget.isAudioPlaying;
    final done = widget.remaining == 0;
    final total = item.counter <= 0 ? 1 : item.counter;
    final progress = ((total - widget.remaining) / total).clamp(0.0, 1.0);

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
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
            ),
            SizedBox(width: 8.w),
            Text(
              _typeLabel(item.type),
              style: TextStyle(
                color: skin.inkSoft.withValues(alpha: 0.7),
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        SelectableText(
          item.text,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            color: skin.ink,
            fontFamily: FontFamily.scheherazade,
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
            height: 1.9,
          ),
        ),
        SizedBox(height: 9.h),
        Row(
          children: [
            Expanded(
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 420),
                curve: Curves.easeOutCubic,
                tween: Tween<double>(begin: 0, end: progress),
                builder: (context, value, _) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(999.r),
                    child: LinearProgressIndicator(
                      value: value,
                      minHeight: 3.h,
                      backgroundColor: skin.hairline,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.gold,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              done ? 'أتممتها' : 'بقي ${widget.remaining} من ${item.counter}',
              style: TextStyle(
                color:
                    done ? skin.accent : skin.inkSoft.withValues(alpha: 0.78),
                fontSize: 9.5.sp,
                fontWeight: done ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 9.h),
        Row(
          children: [
            Expanded(
              child: WirdCountButton(
                done: done,
                onTap: widget.onDecrement,
                lastOne: widget.remaining == 1,
              ),
            ),
            SizedBox(width: 6.w),
            _MiniAction(
              icon: AppIcons.refresh,
              tooltip: 'إعادة العدّ',
              onTap: widget.onReset,
            ),
            SizedBox(width: 6.w),
            _MiniAction(
              icon: AppIcons.copy,
              tooltip: 'نسخ الذكر',
              onTap: () async {
                await HapticFeedback.selectionClick();
                await CopyService.copyToClipboard(item.text);
              },
            ),
            SizedBox(width: 6.w),
            _MiniAction(
              icon: audio.icon,
              tooltip: audio.tooltip,
              busy: audio.busy,
              onTap: audio.enabled ? widget.onAudioPressed : null,
            ),
            SizedBox(width: 6.w),
            _MiniAction(
              icon: AppIcons.link,
              tooltip: 'المصدر',
              onTap: item.sourceUrl.trim().isEmpty
                  ? null
                  : () => _openLink(item.sourceUrl),
            ),
            SizedBox(width: 6.w),
            _MiniAction(
              icon: showDetails ? AppIcons.up : AppIcons.down,
              tooltip: showDetails ? 'إخفاء التفاصيل' : 'عرض التفاصيل',
              onTap: () {
                setState(() {
                  showDetails = !showDetails;
                });
              },
            ),
          ],
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 220),
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Divider(height: 1, thickness: 1, color: skin.hairline),
                SizedBox(height: 9.h),
                WirdInfoRow(title: 'الفضل', content: item.virtue),
                SizedBox(height: 8.h),
                WirdInfoRow(title: 'المصدر', content: item.source),
                SizedBox(height: 8.h),
                WirdInfoRow(title: 'نص الحديث', content: item.hadithText),
                if (item.wordExplanations.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Text(
                    'شرح مفردات مختارة',
                    style: TextStyle(
                      color: skin.inkSoft.withValues(alpha: 0.8),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  ...item.wordExplanations.map(
                    (word) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: Text(
                        '• ${word.word}: ${word.meaning}',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: skin.inkSoft,
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          crossFadeState: showDetails
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ),
      ],
    );

    // الذكر الجاري تلاوته صوتًا هو العنصر المرتفع الوحيد في القائمة.
    if (isActive) {
      return Padding(
        padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 6.h),
        child: Container(
          decoration: BoxDecoration(
            color: skin.raised,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: skin.raisedBorder),
            boxShadow: skin.raisedShadow,
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
          child: content,
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: widget.isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: skin.hairline)),
            ),
      padding: EdgeInsets.symmetric(vertical: 11.h),
      child: content,
    );
  }
}

/// زرّ «قرأت مرة»: يهتزّ مع كل عدّة، ويهتزّ أوضح عند إتمام الذكر،
/// وعلامة الصحّ فيه تُرسم ولا تظهر جاهزة.
class WirdCountButton extends StatefulWidget {
  const WirdCountButton({
    required this.done,
    required this.onTap,
    required this.lastOne,
    super.key,
  });

  final bool done;
  final bool lastOne;
  final VoidCallback onTap;

  @override
  State<WirdCountButton> createState() => _WirdCountButtonState();
}

class _WirdCountButtonState extends State<WirdCountButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 460),
    value: widget.done ? 1 : 0,
  );

  late final Animation<double> _fill = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );

  late final Animation<double> _pop = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1, end: 1.07), weight: 35),
    TweenSequenceItem(tween: Tween(begin: 1.07, end: 1), weight: 65),
  ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  @override
  void didUpdateWidget(covariant WirdCountButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.done != oldWidget.done) {
      widget.done ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.lastOne) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.selectionClick();
    }
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final radius = BorderRadius.circular(10.r);

    return Semantics(
      button: true,
      selected: widget.done,
      child: InkWell(
        onTap: widget.done ? null : _handleTap,
        borderRadius: radius,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = _fill.value;
            final textColor =
                Color.lerp(skin.ink, AppColors.brandIvory, t) ?? skin.ink;

            return Transform.scale(
              scale: widget.done || _controller.isAnimating ? _pop.value : 1.0,
              child: Container(
                height: 30.h,
                decoration: BoxDecoration(
                  color: skin.raised,
                  borderRadius: radius,
                  border: Border.all(
                    color: Color.lerp(
                          AppColors.gold.withValues(alpha: 0.42),
                          AppColors.gold,
                          t,
                        ) ??
                        AppColors.gold,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: radius,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: t,
                          child: const ColoredBox(color: AppColors.gold),
                        ),
                      ),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (t > 0.02)
                              SizedBox(
                                width: 12.w * t,
                                height: 11.sp,
                                child: CustomPaint(
                                  painter: WirdCheckPainter(
                                    progress:
                                        ((t - 0.35) / 0.65).clamp(0.0, 1.0),
                                    color: AppColors.brandIvory,
                                  ),
                                ),
                              ),
                            Flexible(
                              child: Text(
                                widget.done ? 'تم' : 'قرأت مرة',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  height: 1.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// يرسم علامة الصحّ سكتةً بعد سكتة بدل إظهارها جاهزة.
class WirdCheckPainter extends CustomPainter {
  const WirdCheckPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final path = Path()
      ..moveTo(size.width * 0.12, size.height * 0.52)
      ..lineTo(size.width * 0.4, size.height * 0.78)
      ..lineTo(size.width * 0.88, size.height * 0.24);

    final metric = path.computeMetrics().first;
    canvas.drawPath(
      metric.extractPath(0, metric.length * progress),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant WirdCheckPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

/// زرّ أيقونة صغير: مربّع بخلفية `iconChip`، هو بديل الزرّ المملوء.
class _MiniAction extends StatelessWidget {
  const _MiniAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.busy = false,
  });

  final HugeIconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final enabled = onTap != null;
    final color = enabled ? skin.accent : skin.inkSoft.withValues(alpha: 0.38);

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          width: 30.w,
          height: 30.h,
          decoration: BoxDecoration(
            color: enabled ? skin.iconChip : skin.raised,
            borderRadius: BorderRadius.circular(10.r),
            border: enabled ? null : Border.all(color: skin.hairline),
          ),
          child: Center(
            child: busy
                ? SizedBox(
                    width: 13.sp,
                    height: 13.sp,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.6,
                      valueColor: AlwaysStoppedAnimation<Color>(skin.accent),
                    ),
                  )
                : AppIcon(icon, color: color, size: 15.sp),
          ),
        ),
      ),
    );
  }
}
