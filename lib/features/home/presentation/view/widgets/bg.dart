import 'package:flutter/material.dart';

class _HeaderBackgroundPainter extends CustomPainter {
  _HeaderBackgroundPainter({required this.start, required this.end});
  final Color start;
  final Color end;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [start, end],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    canvas.drawRect(rect, paint);

    // نقش هندسي خفيف جداً
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    const double step = 26;
    for (var x = -size.height; x < size.width + size.height; x += step) {
      final p1 = Offset(x, 0);
      final p2 = Offset(x + size.height, size.height);
      canvas.drawLine(p1, p2, gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _HeaderBackgroundPainter oldDelegate) =>
      oldDelegate.start != start || oldDelegate.end != end;
}


  // CustomPaint(
  //           size: Size.fromHeight(height),
  //           painter: _HeaderBackgroundPainter(
  //             start: cs.primary,
  //             end: const Color(0xFF0A6E63),
  //           ),
  //         ),