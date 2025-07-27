import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

class ExpandingFabWidget extends StatefulWidget {
  const ExpandingFabWidget({
    required this.children,
    this.primaryColor,
    this.fabSize,
    this.childrenSize,
    this.expandedRadius,
    this.animationDuration,
    this.closedIcon,
    this.openIcon,
    this.backgroundOverlay,
    this.overlayColor,
    this.initialOpen,
    super.key,
  });

  final List<FabAction> children;
  final Color? primaryColor;
  final double? fabSize;
  final double? childrenSize;
  final double? expandedRadius;
  final Duration? animationDuration;
  final IconData? closedIcon;
  final IconData? openIcon;
  final bool? backgroundOverlay;
  final Color? overlayColor;
  final bool? initialOpen;

  @override
  State<ExpandingFabWidget> createState() => _ExpandingFabWidgetState();
}

class _ExpandingFabWidgetState extends State<ExpandingFabWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _rotationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;

  bool _isOpen = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 400),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 0.6, curve: Curves.easeOut),
      ),
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.75,
    ).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.initialOpen == true) {
      _isOpen = true;
      _animationController.value = 1.0;
      _rotationController.value = 1.0;
    }
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
    });

    if (_isOpen) {
      _animationController.forward();
      _rotationController.forward();
    } else {
      _animationController.reverse();
      _rotationController.reverse();
    }
  }

  void _closeMenu() {
    if (_isOpen) {
      setState(() {
        _isOpen = false;
      });
      _animationController.reverse();
      _rotationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background overlay
        if (widget.backgroundOverlay ?? true)
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return _fadeAnimation.value > 0
                  ? GestureDetector(
                      onTap: _closeMenu,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: (widget.overlayColor ?? Colors.black)
                            .withOpacity(_fadeAnimation.value * 0.5),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),

        // Expanded action buttons
        ...widget.children.asMap().entries.map((entry) {
          final index = entry.key;
          final action = entry.value;
          return _buildExpandedChild(action, index);
        }),

        // Main FAB
        AnimatedBuilder(
          animation: Listenable.merge([_rotationAnimation, _expandAnimation]),
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value * math.pi,
              child: Transform.scale(
                scale: 1.0 + (_expandAnimation.value * 0.1),
                child: FloatingActionButton(
                  heroTag: 'expanding_fab_main',
                  backgroundColor: widget.primaryColor ?? context.primaryColor,
                  onPressed: _toggle,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      _isOpen
                          ? (widget.openIcon ?? Icons.close)
                          : (widget.closedIcon ?? Icons.add),
                      key: ValueKey(_isOpen),
                      color: Colors.white,
                      size: (widget.fabSize ?? 56.w) * 0.4,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildExpandedChild(FabAction action, int index) {
    final angle = (math.pi * 2 / widget.children.length) * index - math.pi / 2;
    final radius = widget.expandedRadius ?? 120.w;

    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        final expandValue = _expandAnimation.value;
        final x = math.cos(angle) * radius * expandValue;
        final y = math.sin(angle) * radius * expandValue;

        return Transform.translate(
          offset: Offset(x, y),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Transform.scale(
              scale: expandValue,
              child: GestureDetector(
                onTap: () {
                  action.onPressed();
                  _closeMenu();
                },
                child: Container(
                  width: widget.childrenSize ?? 50.w,
                  height: widget.childrenSize ?? 50.w,
                  decoration: BoxDecoration(
                    color: action.backgroundColor ??
                        context.primaryColor.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Ripple effect
                      Positioned.fill(
                        child: CustomPaint(
                          painter: RippleEffectPainter(
                            animation: _expandAnimation,
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ),
                      // Icon
                      Center(
                        child: Icon(
                          action.icon,
                          color: action.iconColor ?? Colors.white,
                          size: (widget.childrenSize ?? 50.w) * 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FabAction {
  FabAction({
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.tooltip,
  });
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final String? tooltip;
}

class RippleEffectPainter extends CustomPainter {
  RippleEffectPainter({required this.animation, required this.color});
  final Animation<double> animation;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Multiple ripple rings
    for (var i = 0; i < 3; i++) {
      final rippleRadius = radius * animation.value * (1 + i * 0.3);
      final opacity = (1 - animation.value) * (1 - i * 0.3);

      if (opacity > 0) {
        final paint = Paint()
          ..color = color.withOpacity(opacity.clamp(0.0, 1.0))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        canvas.drawCircle(center, rippleRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Predefined action sets for common use cases
class QuranAppFabActions {
  static List<FabAction> get defaultActions => [
        FabAction(
          icon: Icons.menu_book,
          onPressed: () {},
          tooltip: 'القرآن الكريم',
        ),
        FabAction(
          icon: Icons.favorite,
          onPressed: () {},
          tooltip: 'الأذكار',
        ),
        FabAction(
          icon: Icons.access_time,
          onPressed: () {},
          tooltip: 'مواقيت الصلاة',
        ),
        FabAction(
          icon: Icons.bookmark,
          onPressed: () {},
          tooltip: 'المفضلة',
        ),
      ];

  static List<FabAction> get mediaActions => [
        FabAction(
          icon: Icons.play_arrow,
          onPressed: () {},
          backgroundColor: Colors.green,
          tooltip: 'تشغيل',
        ),
        FabAction(
          icon: Icons.pause,
          onPressed: () {},
          backgroundColor: Colors.orange,
          tooltip: 'إيقاف',
        ),
        FabAction(
          icon: Icons.stop,
          onPressed: () {},
          backgroundColor: Colors.red,
          tooltip: 'توقف',
        ),
        FabAction(
          icon: Icons.shuffle,
          onPressed: () {},
          backgroundColor: Colors.purple,
          tooltip: 'عشوائي',
        ),
      ];

  static List<FabAction> get settingsActions => [
        FabAction(
          icon: Icons.settings,
          onPressed: () {},
          tooltip: 'الإعدادات',
        ),
        FabAction(
          icon: Icons.notifications,
          onPressed: () {},
          tooltip: 'التنبيهات',
        ),
        FabAction(
          icon: Icons.share,
          onPressed: () {},
          tooltip: 'مشاركة',
        ),
        FabAction(
          icon: Icons.info,
          onPressed: () {},
          tooltip: 'حول التطبيق',
        ),
      ];
}
