import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/bloc/base/base_bloc.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';

// Static current page for global access
int currentPage = 0;

class CustomBottomNavigationBarWidget extends StatelessWidget {
  const CustomBottomNavigationBarWidget({super.key});

  void _onNavItemTapped(int index, BuildContext context) {
    // Add haptic feedback
    HapticFeedback.lightImpact();

    // Update global state
    currentPage = index;

    // Update global state through BlocProvider
    context.read<BaseBloc>().add(SetStateBaseBlocEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseBloc, BaseState>(
      builder: (context, state) {
        final selectedIndex = currentPage;
        final screenWidth = MediaQuery.of(context).size.width;

        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: _getResponsiveValue(screenWidth, 8, 12, 16),
            vertical: _getResponsiveValue(screenWidth, 4, 6, 8),
          ),
          child: CardWidget(
            padding: EdgeInsets.symmetric(
              horizontal: _getResponsiveValue(screenWidth, 8, 12, 16),
              vertical: _getResponsiveValue(screenWidth, 4, 6, 8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: CupertinoIcons.home,
                  label: 'الرئيسية',
                  index: 0,
                  selectedIndex: selectedIndex,
                  context: context,
                ),
                _buildNavItem(
                  icon: CupertinoIcons.collections,
                  label: 'الاقسام',
                  index: 1,
                  selectedIndex: selectedIndex,
                  context: context,
                ),
                _buildNavItem(
                  icon: CupertinoIcons.settings_solid,
                  label: 'الإعدادات',
                  index: 2,
                  selectedIndex: selectedIndex,
                  context: context,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required int selectedIndex,
    required BuildContext context,
  }) {
    final isSelected = selectedIndex == index;

    return Expanded(
      child: BottomNavItem(
        icon: icon,
        label: label,
        selected: isSelected,
        onTap: () => _onNavItemTapped(index, context),
      ),
    );
  }

  double _getResponsiveValue(
    double screenWidth,
    double small,
    double medium,
    double large,
  ) {
    if (screenWidth < 400) return small;
    if (screenWidth < 600) return medium;
    return large;
  }
}

class BottomNavItem extends StatefulWidget {
  const BottomNavItem({
    required this.icon,
    required this.label,
    super.key,
    this.selected = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  State<BottomNavItem> createState() => _BottomNavItemState();
}

class _BottomNavItemState extends State<BottomNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _scaleAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Simple bounce animation
    _bounceAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    // Subtle scale animation
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Set initial state
    if (widget.selected) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(BottomNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selected != widget.selected) {
      if (widget.selected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (mounted) {
      setState(() {
        _isPressed = true;
      });
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (mounted) {
      setState(() {
        _isPressed = false;
      });
      widget.onTap?.call();
    }
  }

  void _onTapCancel() {
    if (mounted) {
      setState(() {
        _isPressed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(
                  horizontal:
                      _getCompactValue(screenWidth, screenHeight, 8, 12, 16),
                  vertical:
                      _getCompactValue(screenWidth, screenHeight, 6, 8, 10),
                ),
                decoration: BoxDecoration(
                  color: widget.selected
                      ? context.secondary.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    _getCompactValue(screenWidth, screenHeight, 8, 12, 16),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon with smooth bounce
                    Transform.translate(
                      offset: Offset(0, -2 * _bounceAnimation.value),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        child: Icon(
                          widget.icon,
                          size: _getCompactValue(
                              screenWidth, screenHeight, 20, 22, 26),
                          color: widget.selected
                              ? context.primaryScheme
                              : context.gray1,
                        ),
                      ),
                    ),
                    SizedBox(
                        height: _getCompactValue(
                            screenWidth, screenHeight, 2, 3, 4)),
                    // Text with smooth color transition
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      style: TextStyle(
                        color: widget.selected
                            ? context.primaryScheme
                            : context.gray1,
                        fontWeight:
                            widget.selected ? FontWeight.bold : FontWeight.w500,
                        fontSize: _getCompactValue(
                            screenWidth, screenHeight, 9, 10, 12),
                      ),
                      child: Text(
                        widget.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Bottom indicator
                    SizedBox(
                        height: _getCompactValue(
                            screenWidth, screenHeight, 2, 3, 4)),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: widget.selected
                          ? _getCompactValue(
                              screenWidth, screenHeight, 16, 20, 24)
                          : 0,
                      height:
                          _getCompactValue(screenWidth, screenHeight, 2, 2, 3),
                      decoration: BoxDecoration(
                        color: context.primaryScheme,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  double _getCompactValue(
    double screenWidth,
    double screenHeight,
    double small,
    double medium,
    double large,
  ) {
    // Consider both width and height for more accurate responsiveness
    final isSmallScreen = screenWidth < 380 || screenHeight < 650;
    final isMediumScreen = screenWidth < 600 || screenHeight < 800;

    if (isSmallScreen) return small;
    if (isMediumScreen) return medium;
    return large;
  }
}
