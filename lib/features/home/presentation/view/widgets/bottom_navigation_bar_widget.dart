import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

/// Custom bottom navigation bar with smooth animations and modern design
class CustomBottomNavigationBarWidget extends StatefulWidget {
  const CustomBottomNavigationBarWidget({
    super.key,
    this.initialIndex = 0,
    this.onIndexChanged,
  });

  final int initialIndex;
  final ValueChanged<int>? onIndexChanged;

  @override
  State<CustomBottomNavigationBarWidget> createState() =>
      _CustomBottomNavigationBarWidgetState();
}

class _CustomBottomNavigationBarWidgetState
    extends State<CustomBottomNavigationBarWidget> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onNavItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() => _selectedIndex = index);
    widget.onIndexChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
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
            ),
            _buildNavItem(
              icon: CupertinoIcons.collections,
              label: 'الاقسام',
              index: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: BottomNavItem(
        icon: icon,
        label: label,
        selected: isSelected,
        onTap: () => _onNavItemTapped(index),
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

/// Individual navigation item with smooth animations
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

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.selected) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(BottomNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selected != widget.selected) {
      widget.selected ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isCompact = size.width < 380 || size.height < 650;
    final isMedium = size.width < 600 || size.height < 800;

    return StyleButtonWrap(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 8 : (isMedium ? 12 : 16),
                vertical: isCompact ? 6 : (isMedium ? 8 : 10),
              ),
              decoration: BoxDecoration(
                color: widget.selected
                    ? context.secondaryColor.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(
                  isCompact ? 8 : (isMedium ? 12 : 16),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated icon with bounce effect
                  Transform.translate(
                    offset: Offset(0, -2 * _bounceAnimation.value),
                    child: Icon(
                      widget.icon,
                      size: isCompact ? 20 : (isMedium ? 22 : 26),
                      color: widget.selected
                          ? context.primaryColor
                          : context.gray1,
                    ),
                  ),
                  SizedBox(height: isCompact ? 2 : (isMedium ? 3 : 4)),

                  // Animated label
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    style: TextStyle(
                      color: widget.selected
                          ? context.primaryColor
                          : context.gray1,
                      fontWeight:
                          widget.selected ? FontWeight.bold : FontWeight.w500,
                      fontSize: isCompact ? 9 : (isMedium ? 10 : 12),
                    ),
                    child: Text(
                      widget.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: isCompact ? 2 : (isMedium ? 3 : 4)),

                  // Bottom indicator line
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: widget.selected
                        ? (isCompact ? 16 : (isMedium ? 20 : 24))
                        : 0,
                    height: isCompact ? 2 : (isMedium ? 2 : 3),
                    decoration: BoxDecoration(
                      color: context.primaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
