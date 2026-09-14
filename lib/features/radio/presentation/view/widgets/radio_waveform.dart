import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/theme/app_skin.dart';

/// موجة صوت تتحرّك ما دام البثّ يعمل.
///
/// ما كان هنا قبلُ ثلاثة أعمدة **ساكنة** اسمها `MiniEqualizer` — مؤشّر يدّعي
/// الحياة ولا يتحرّك، وهو أسوأ من غيابه لأنه يجعل البثّ العامل يبدو معلّقًا.
///
/// المؤقّت واحد لكل موجة ومغلّف بـ [RepaintBoundary]، والرسم في [CustomPainter]
/// لا في ودجات، فأربعة أعمدة لا تكلّف أربع إعادات بناء.
class RadioWaveform extends StatefulWidget {
  const RadioWaveform({
    required this.isActive,
    this.barCount = 4,
    this.height,
    this.barWidth,
    this.color,
    super.key,
  });

  final bool isActive;
  final int barCount;
  final double? height;
  final double? barWidth;
  final Color? color;

  @override
  State<RadioWaveform> createState() => _RadioWaveformState();
}

class _RadioWaveformState extends State<RadioWaveform>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clock = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  /// يهدأ إلى صفر عند التوقّف بدل أن يتجمّد فجأةً في منتصف الموجة.
  late final AnimationController _energy = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
    value: widget.isActive ? 1 : 0,
  );

  @override
  void initState() {
    super.initState();
    if (widget.isActive) _clock.repeat();
  }

  @override
  void didUpdateWidget(covariant RadioWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive == oldWidget.isActive) return;

    if (widget.isActive) {
      _clock.repeat();
      _energy.forward();
    } else {
      // العقرب يبقى دائرًا حتى تهبط الطاقة، وإلا توقّفت الأعمدة دفعةً واحدة.
      _energy.reverse().whenComplete(() {
        if (mounted && !widget.isActive) _clock.stop();
      });
    }
  }

  @override
  void dispose() {
    _clock.dispose();
    _energy.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final skin = AppSkin.of(context);
    final height = widget.height ?? 13.h;
    final barWidth = widget.barWidth ?? 2.2.w;
    final gap = barWidth * 0.85;

    return RepaintBoundary(
      child: SizedBox(
        width: widget.barCount * barWidth + (widget.barCount - 1) * gap,
        height: height,
        child: AnimatedBuilder(
          animation: Listenable.merge([_clock, _energy]),
          builder: (context, _) => CustomPaint(
            painter: _WaveformPainter(
              phase: _clock.value,
              energy: Curves.easeOut.transform(_energy.value),
              barCount: widget.barCount,
              barWidth: barWidth,
              gap: gap,
              color: widget.color ?? skin.accent,
            ),
          ),
        ),
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  const _WaveformPainter({
    required this.phase,
    required this.energy,
    required this.barCount,
    required this.barWidth,
    required this.gap,
    required this.color,
  });

  final double phase;
  final double energy;
  final int barCount;
  final double barWidth;
  final double gap;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    for (var i = 0; i < barCount; i++) {
      // لكل عمود سرعة وطور مختلفان، وإلا نبضت الأعمدة معًا فبدت شريطًا
      // واحدًا يرتفع وينزل لا موجة صوت.
      final rate = 1 + (i % 3) * 0.45;
      final wave = math.sin((phase * rate + i * 0.62) * math.pi * 2);
      final factor = 0.24 + 0.76 * ((wave + 1) / 2);
      final barHeight = size.height * (0.24 + (factor - 0.24) * energy);

      final left = i * (barWidth + gap);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, size.height - barHeight, barWidth, barHeight),
          Radius.circular(barWidth),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) =>
      oldDelegate.phase != phase ||
      oldDelegate.energy != energy ||
      oldDelegate.color != color;
}
