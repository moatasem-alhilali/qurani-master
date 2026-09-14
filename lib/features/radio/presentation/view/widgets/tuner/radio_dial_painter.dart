import 'package:flutter/material.dart';

/// شريط تدريج الراديو: علامات تنزلق تحت إبرة ثابتة في المنتصف.
///
/// الشريط ليس زينة — هو **مسطرة الموضع**: يخبرك كم محطة وراءك وكم أمامك،
/// وهذا ما كانت تفتقده القائمة العمودية (أربعة وعشرون صفًّا بلا إحساس بالمكان).
///
/// القيم كلّها مشتقّة من موضع الـ `PageView` الكسري، فالعلامات تنزلق مع
/// الإصبع لحظةً بلحظة لا بعد أن تستقرّ.
class RadioDialPainter extends CustomPainter {
  const RadioDialPainter({
    required this.position,
    required this.count,
    required this.gap,
    required this.isRtl,
    required this.tickColor,
    required this.accent,
  });

  /// موضع القرص الكسري: ٣٫٤ يعني بين المحطة الرابعة والخامسة.
  final double position;
  final int count;

  /// المسافة بين علامتي محطتين.
  final double gap;

  /// في العربية يتقدّم المؤشّر يسارًا، فتُعكس إشارة الإزاحة.
  final bool isRtl;

  final Color tickColor;
  final Color accent;

  /// ثلاث علامات صغيرة بين كل محطتين — تعطي الإحساس بالانزلاق المستمرّ بدل
  /// القفز من محطة إلى محطة.
  static const _minorPerGap = 3;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final direction = isRtl ? -1.0 : 1.0;
    final paint = Paint()..strokeCap = StrokeCap.round;

    double xFor(double index) => centerX + direction * (index - position) * gap;

    // كم علامة تُرى على الجانبين؟ ما خرج عن العرض لا يُرسم أصلًا.
    final reach = (size.width / gap / 2).ceil() + 1;
    final first = (position.floor() - reach).clamp(0, count);
    final last = (position.ceil() + reach).clamp(0, count);

    for (var i = first; i < last; i++) {
      final x = xFor(i.toDouble());
      // الأطراف تبهت: يوحي بأن الشريط يمتدّ خلف الحافّة لا ينقطع عندها.
      final fade = _fadeAt(x, size.width);
      if (fade <= 0.01) continue;

      final distance = (i - position).abs();
      final isTuned = distance < 0.5;
      final height = size.height * (isTuned ? 0.92 : 0.6);

      canvas
        ..drawLine(
          Offset(x, size.height),
          Offset(x, size.height - height),
          paint
            ..strokeWidth = isTuned ? 2.4 : 1.6
            ..color = (isTuned ? accent : tickColor).withValues(
              alpha: fade * (isTuned ? 1 : 0.55),
            ),
        );

      if (i >= count - 1) continue;

      for (var m = 1; m <= _minorPerGap; m++) {
        final minorX = xFor(i + m / (_minorPerGap + 1));
        final minorFade = _fadeAt(minorX, size.width);
        if (minorFade <= 0.01) continue;

        canvas.drawLine(
          Offset(minorX, size.height),
          Offset(minorX, size.height - size.height * 0.28),
          paint
            ..strokeWidth = 1
            ..color = tickColor.withValues(alpha: minorFade * 0.3),
        );
      }
    }
  }

  /// شفافية العلامة حسب بعدها عن المنتصف: كاملة في الوسط، صفر عند الحافّة.
  double _fadeAt(double x, double width) {
    if (x < 0 || x > width) return 0;
    final normalized = (x - width / 2).abs() / (width / 2);
    return (1 - normalized * normalized).clamp(0.0, 1.0);
  }

  @override
  bool shouldRepaint(covariant RadioDialPainter oldDelegate) =>
      oldDelegate.position != position ||
      oldDelegate.count != count ||
      oldDelegate.gap != gap ||
      oldDelegate.isRtl != isRtl ||
      oldDelegate.tickColor != tickColor ||
      oldDelegate.accent != accent;
}
