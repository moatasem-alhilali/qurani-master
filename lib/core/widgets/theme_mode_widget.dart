import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/bloc/theme/theme_bloc.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/theme/theme_manager.dart';

class ThemeModeWidget extends StatefulWidget {
  const ThemeModeWidget({super.key, this.onTap});
  final VoidCallback? onTap;
  @override
  State<ThemeModeWidget> createState() => _ThemeModeWidgetState();
}

class _ThemeModeWidgetState extends State<ThemeModeWidget>
    with TickerProviderStateMixin {
  late AnimationController _toggleController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _glowController;

  late Animation<double> _toggleAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _glowAnimation;

  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    // Toggle animation controller
    _toggleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Scale animation controller
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Rotation animation controller
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Glow animation controller
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Toggle animation (moves the thumb)
    _toggleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _toggleController,
        curve: Curves.elasticOut,
      ),
    );

    // Scale animation (for tap feedback)
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeInOut,
      ),
    );

    // Rotation animation (for icon rotation)
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.easeInOutBack,
      ),
    );

    // Glow animation (for visual feedback)
    _glowAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );

    // Start glow animation
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _toggleController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _onTogglePressed(BuildContext context, bool isDark) async {
    if (_isAnimating) return;

    _isAnimating = true;

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Start scale animation
    await _scaleController.forward();
    await _scaleController.reverse();

    // Start rotation animation
    _rotationController.forward().then((_) {
      _rotationController.reset();
    });

    // Start toggle animation
    if (isDark) {
      await _toggleController.forward();
    } else {
      await _toggleController.reverse();
    }

    // Change theme
    context.read<ThemeBloc>().add(
          ChangeThemeModeEvent(
            mode: isDark ? ThemeModeManager.light : ThemeModeManager.dark,
          ),
        );

    _isAnimating = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ThemeBloc, ThemeState>(
      listener: (context, state) {},
      builder: (context, state) {
        final isDark = state.currentThemeMode == ThemeMode.dark;

        // Update animation state based on current theme
        if (isDark && _toggleController.value == 0.0) {
          _toggleController.value = 1.0;
        } else if (!isDark && _toggleController.value == 1.0) {
          _toggleController.value = 0.0;
        }

        return CardWidget(
          padding: EdgeInsets.all(16.w),
          margin: EdgeInsets.symmetric(horizontal: 10.sp),
          child: Row(
            children: [
              // Theme mode text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'النمط الداكن',
                      style: context.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      isDark ? 'مفعل' : 'معطل',
                      style: context.bodySmall?.copyWith(
                        color: context.colors.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 16.w),

              // Animated toggle
              AnimatedBuilder(
                animation: Listenable.merge([
                  _toggleAnimation,
                  _scaleAnimation,
                  _glowAnimation,
                ]),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: GestureDetector(
                      onTap: () => _onTogglePressed(context, isDark),
                      child: Container(
                        width: 60.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDark
                                ? [
                                    context.colors.primary.withOpacity(0.8),
                                    context.colors.primary,
                                  ]
                                : [
                                    context.colors.outline,
                                    context.colors.outline.withOpacity(0.7),
                                  ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? context.colors.primary
                                      .withOpacity(0.3 * _glowAnimation.value)
                                  : context.colors.outline.withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Background icons
                            Positioned(
                              left: 6.w,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: AnimatedOpacity(
                                  opacity: isDark ? 0.0 : 0.3,
                                  duration: const Duration(milliseconds: 300),
                                  child: Icon(
                                    Icons.wb_sunny_rounded,
                                    size: 16.sp,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 6.w,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: AnimatedOpacity(
                                  opacity: isDark ? 0.3 : 0.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Icon(
                                    Icons.nightlight_round,
                                    size: 16.sp,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                            ),

                            // Animated thumb
                            Positioned(
                              left: _toggleAnimation.value * (60.w - 28.w),
                              top: 2.h,
                              child: Container(
                                width: 28.w,
                                height: 28.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: AnimatedBuilder(
                                    animation: _rotationAnimation,
                                    builder: (context, child) {
                                      return Transform.rotate(
                                        angle: _rotationAnimation.value *
                                            2 *
                                            3.14159,
                                        child: Icon(
                                          isDark
                                              ? Icons.nightlight_round
                                              : Icons.wb_sunny_rounded,
                                          size: 16.sp,
                                          color: isDark
                                              ? Colors.indigo
                                              : Colors.orange,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
