import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/bloc/base/base_bloc.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';

// Static current page for global access
int currentPage = 0;

class CustomBottomNavigationBarWidget extends StatefulWidget {
  const CustomBottomNavigationBarWidget({super.key});

  @override
  State<CustomBottomNavigationBarWidget> createState() =>
      _CustomBottomNavigationBarWidgetState();
}

class _CustomBottomNavigationBarWidgetState
    extends State<CustomBottomNavigationBarWidget>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late AnimationController _rippleController;
  late List<AnimationController> _itemControllers;
  late List<Animation<double>> _itemAnimations;
  late Animation<double> _indicatorAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Main animation controller for indicator
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Ripple effect controller
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Individual controllers for each item
    _itemControllers = List.generate(
      _navigationItems.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    // Animations for each item
    _itemAnimations = _itemControllers.map((controller) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      );
    }).toList();

    // Indicator slide animation
    _indicatorAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    // Ripple animation
    _rippleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );

    // Start initial animation
    _itemControllers[0].forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _rippleController.dispose();
    for (final controller in _itemControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_currentIndex == index) return;

    HapticFeedback.lightImpact();
    setState(() {
      _currentIndex = index;
      currentPage = index; // Update global state
    });

    // Trigger ripple effect
    _rippleController.forward().then((_) {
      _rippleController.reset();
    });

    // Animate indicator
    _animationController.forward().then((_) {
      _animationController.reset();
    });

    // Animate items
    for (var i = 0; i < _itemControllers.length; i++) {
      if (i == index) {
        _itemControllers[i].forward();
      } else {
        _itemControllers[i].reverse();
      }
    }

    // Update global state through BlocProvider
    context.read<BaseBloc>().add(SetStateBaseBlocEvent());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

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
        child: IntrinsicHeight(
          child: Stack(
            children: [
              // Animated indicator background
              AnimatedBuilder(
                animation: _indicatorAnimation,
                builder: (context, child) {
                  return Positioned(
                    left: _calculateIndicatorPosition(screenWidth),
                    top: 2,
                    bottom: 2,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOutCubic,
                      width: _getItemWidth(screenWidth),
                      decoration: BoxDecoration(
                        color: context.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          _getResponsiveValue(screenWidth, 8, 12, 16),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Navigation items
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  _navigationItems.length,
                  (index) => _buildNavigationItem(
                    context,
                    index,
                    screenWidth,
                    screenHeight,
                    isTablet,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem(
    BuildContext context,
    int index,
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    final item = _navigationItems[index];
    final isSelected = _currentIndex == index;

    return Expanded(
      child: AnimatedBuilder(
        animation: _itemAnimations[index],
        builder: (context, child) {
          return GestureDetector(
            onTap: () => _onItemTapped(index),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: _getCompactValue(screenWidth, screenHeight, 8, 10, 8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon with scale animation
                  AnimatedScale(
                    scale: isSelected ? 1.05 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: AnimatedBuilder(
                      animation: _rippleAnimation,
                      builder: (context, child) {
                        return Container(
                          padding: EdgeInsets.all(
                            _getCompactValue(
                              screenWidth,
                              screenHeight,
                              3,
                              4,
                              6,
                            ),
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected && index == _currentIndex
                                ? context.secondary.withOpacity(
                                    0.15 * _rippleAnimation.value,
                                  )
                                : Colors.transparent,
                          ),
                          child: Icon(
                            item.icon,
                            size: _getCompactValue(
                              screenWidth,
                              screenHeight,
                              20,
                              22,
                              26,
                            ),
                            color: isSelected
                                ? context.primaryScheme
                                : context.gray1,
                          ),
                        );
                      },
                    ),
                  ),

                  // Spacing
                  SizedBox(
                    height:
                        _getCompactValue(screenWidth, screenHeight, 1, 2, 3),
                  ),

                  // Label with fade animation
                  AnimatedOpacity(
                    opacity: isSelected ? 1.0 : 0.7,
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      item.title,
                      style: TextStyle(
                        color:
                            isSelected ? context.primaryScheme : context.gray1,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: _getCompactValue(
                          screenWidth,
                          screenHeight,
                          9,
                          10,
                          12,
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Bottom indicator
                  SizedBox(
                    height:
                        _getCompactValue(screenWidth, screenHeight, 2, 3, 4),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: isSelected
                        ? _getCompactValue(
                            screenWidth,
                            screenHeight,
                            16,
                            20,
                            24,
                          )
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
    );
  }

  double _calculateIndicatorPosition(double screenWidth) {
    final itemWidth = _getItemWidth(screenWidth);
    final spacing = (screenWidth - (itemWidth * _navigationItems.length)) /
        (_navigationItems.length + 1);
    return spacing +
        (_currentIndex * (itemWidth + spacing / _navigationItems.length));
  }

  double _getItemWidth(double screenWidth) {
    return (screenWidth - 60) / _navigationItems.length;
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

// Navigation item model for better organization
class NavigationItem {
  const NavigationItem({
    required this.icon,
    required this.title,
  });
  final IconData icon;
  final String title;
}

// Navigation items list
final List<NavigationItem> _navigationItems = [
  const NavigationItem(
    icon: CupertinoIcons.home,
    title: 'الرئيسية',
  ),
  const NavigationItem(
    icon: CupertinoIcons.collections,
    title: 'الاقسام',
  ),
  const NavigationItem(
    icon: CupertinoIcons.settings_solid,
    title: 'الإعدادات',
  ),
];
