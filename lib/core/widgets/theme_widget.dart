import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/theme/theme_manager.dart';

class ThemeWidget extends StatefulWidget {
  const ThemeWidget({super.key, this.onTap});
  final VoidCallback? onTap;
  @override
  State<ThemeWidget> createState() => _ThemeWidgetState();
}

class _ThemeWidgetState extends State<ThemeWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _selectionController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _selectionAnimation;

  final List<Map<String, String>> titles = [
    {'name': 'أزرق', 'value': ThemeManager.blue},
    {'name': 'بني', 'value': ThemeManager.brown},
    {'name': 'أخضر', 'value': ThemeManager.green},
    {'name': 'الداكن', 'value': ThemeManager.dark},
  ];

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _selectionController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeInOut,
      ),
    );

    _selectionAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _selectionController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _selectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ThemeBloc, ThemeState>(
      listener: (context, state) {
        _selectionController.forward().then((_) {
          _selectionController.reset();
        });
      },
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                titles.length,
                (i) {
                  final isSelected =
                      titles[i]['value'] == state.currentThemeType;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: GestureDetector(
                              onTapDown: (_) => _scaleController.forward(),
                              onTapUp: (_) => _scaleController.reverse(),
                              onTapCancel: () => _scaleController.reverse(),
                              onTap: () {
                                _onTap(i, context);
                                  widget.onTap?.call();
                              },
                              child: Container(
                                padding: EdgeInsets.all(2.sp),
                                decoration: BoxDecoration(
                                  border: isSelected
                                      ? Border.all(
                                          color: _getThemeColor(
                                            titles[i]['value']!,
                                          ),
                                          width: 1.sp,
                                        )
                                      : null,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: CardWidget(
                                  padding: EdgeInsets.only(
                                    top: 10.sp,
                                    bottom: 5.sp,
                                  ),

                                  // padding: EdgeInsets.zero,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Mobile phone widget
                                      MobileThemeItem(
                                        isSelected: isSelected,
                                        themeType: titles[i]['value']!,
                                        selectionAnimation: _selectionAnimation,
                                      ),
                                      const SizedBox(height: 8),
                                      // Selection check icon (only for selected theme)
                                      AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        transitionBuilder: (child, animation) {
                                          return ScaleTransition(
                                            scale: animation,
                                            child: child,
                                          );
                                        },
                                        child: isSelected
                                            ? Icon(
                                                Icons.check_circle,
                                                key: ValueKey('selected_$i'),
                                                color: _getThemeColor(
                                                  titles[i]['value']!,
                                                ),
                                                size: 20,
                                              )
                                            : SizedBox(
                                                key: ValueKey('unselected_$i'),
                                                height: 20,
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getThemeColor(String themeType) {
    switch (themeType) {
      case ThemeManager.blue:
        return const Color(0xff404C6E);
      case ThemeManager.brown:
        return const Color(0xff8B4B3C);
      case ThemeManager.green:
        return const Color(0xff2D5016);
      case ThemeManager.dark:
        return const Color(0xff2A2A2A);
      default:
        return const Color(0xff404C6E);
    }
  }

  void _onTap(int i, BuildContext context) {
    final currentThemeType = titles[i]['value']!;
    context.read<ThemeBloc>().add(ChangeThemeEvent(theme: currentThemeType));
  }
}

class MobileThemeItem extends StatelessWidget {
  const MobileThemeItem({
    required this.isSelected,
    required this.themeType,
    required this.selectionAnimation,
    super.key,
  });
  final bool isSelected;
  final String themeType;
  final Animation<double> selectionAnimation;

  Color _getThemeColor() {
    switch (themeType) {
      case ThemeManager.blue:
        return const Color(0xff404C6E);
      case ThemeManager.brown:
        return const Color(0xff8B4B3C);
      case ThemeManager.green:
        return const Color(0xff2D5016);
      case ThemeManager.dark:
        return const Color(0xff2A2A2A);
      default:
        return const Color(0xff404C6E);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOutCubic,
      width: 55,
      height: 80,
      child: CustomPaint(
        painter: OptimizedMobilePainter(
          isSelected: isSelected,
          themeColor: _getThemeColor(),
          selectionProgress: selectionAnimation.value,
        ),
      ),
    );
  }
}

class OptimizedMobilePainter extends CustomPainter {
  OptimizedMobilePainter({
    required this.isSelected,
    required this.themeColor,
    required this.selectionProgress,
  });
  final bool isSelected;
  final Color themeColor;
  final double selectionProgress;

  @override
  void paint(Canvas canvas, Size size) {
    // Pre-calculate dimensions for better performance
    final phoneRadius = size.width * 0.18;
    final screenMargin = size.width * 0.12;
    final screenTop = size.height * 0.15;
    final screenBottom = size.height * 0.82;
    final screenRadius = phoneRadius * 0.7;

    // Phone body
    final phoneBody = RRect.fromLTRBR(
      2,
      2,
      size.width - 2,
      size.height - 2,
      Radius.circular(phoneRadius),
    );

    // Phone colors - always show theme color for body
    final bodyColor = themeColor.withOpacity(isSelected ? 1.0 : 0.8);
    final borderColor = themeColor;

    // Draw phone body with optimized paint objects
    final bodyPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = bodyColor;

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = borderColor
      ..strokeWidth = isSelected ? 2.0 : 1.5;

    canvas.drawRRect(phoneBody, bodyPaint);
    canvas.drawRRect(phoneBody, borderPaint);

    // Screen area
    final screenRect = RRect.fromLTRBR(
      screenMargin,
      screenTop,
      size.width - screenMargin,
      screenBottom,
      Radius.circular(screenRadius),
    );

    final screenColor = isSelected ? const Color(0xFF1A1A1A) : Colors.white;
    final screenPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = screenColor;

    canvas.drawRRect(screenRect, screenPaint);

    // Screen border
    final screenBorderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color =
          isSelected ? Colors.white.withOpacity(0.1) : const Color(0xFFE8E8E8)
      ..strokeWidth = 0.8;

    canvas.drawRRect(screenRect, screenBorderPaint);

    // Speaker (more realistic)
    final speakerWidth = size.width * 0.25;
    final speakerHeight = size.height * 0.025;
    final speakerRect = RRect.fromLTRBR(
      (size.width - speakerWidth) / 2,
      size.height * 0.08,
      (size.width + speakerWidth) / 2,
      size.height * 0.08 + speakerHeight,
      Radius.circular(speakerHeight / 2),
    );

    final speakerPaint = Paint()
      ..style = PaintingStyle.fill
      ..color =
          isSelected ? Colors.white.withOpacity(0.25) : const Color(0xFFD0D0D0);

    canvas.drawRRect(speakerRect, speakerPaint);

    // Home indicator (modern style)
    final homeIndicatorWidth = size.width * 0.2;
    final homeIndicatorHeight = size.height * 0.015;
    final homeIndicatorRect = RRect.fromLTRBR(
      (size.width - homeIndicatorWidth) / 2,
      size.height * 0.88,
      (size.width + homeIndicatorWidth) / 2,
      size.height * 0.88 + homeIndicatorHeight,
      Radius.circular(homeIndicatorHeight / 2),
    );

    final homePaint = Paint()
      ..style = PaintingStyle.fill
      ..color =
          isSelected ? Colors.white.withOpacity(0.3) : const Color(0xFFB0B0B0);

    canvas.drawRRect(homeIndicatorRect, homePaint);

    // Screen content lines (optimized)
    _drawScreenContent(canvas, size, screenMargin, screenTop, screenBottom);

    // Selection glow effect (only when animating)
    if (selectionProgress > 0) {
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..color = themeColor.withOpacity(0.3 * selectionProgress)
        ..strokeWidth = 2.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 2);

      canvas.drawRRect(phoneBody, glowPaint);
    }
  }

  void _drawScreenContent(
    Canvas canvas,
    Size size,
    double screenMargin,
    double screenTop,
    double screenBottom,
  ) {
    final lineColor =
        isSelected ? Colors.white.withOpacity(0.7) : const Color(0xFF888888);

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = lineColor
      ..strokeWidth = 1.0;

    final contentHeight = screenBottom - screenTop;
    final lineSpacing = contentHeight * 0.12;
    final startY = screenTop + contentHeight * 0.2;
    final lineLeft = screenMargin + (size.width - 2 * screenMargin) * 0.15;
    final lineRight =
        size.width - screenMargin - (size.width - 2 * screenMargin) * 0.15;

    // Draw exactly 4 lines for consistent appearance
    for (var i = 0; i < 4; i++) {
      final y = startY + (i * lineSpacing);
      final lineWidth =
          (lineRight - lineLeft) * (i == 3 ? 0.6 : 1.0); // Last line shorter

      canvas.drawLine(
        Offset(lineLeft, y),
        Offset(lineLeft + lineWidth, y),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant OptimizedMobilePainter oldDelegate) {
    return oldDelegate.isSelected != isSelected ||
        oldDelegate.selectionProgress != selectionProgress;
  }
}
