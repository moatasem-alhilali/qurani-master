import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/services/copy_service.dart';
import 'package:quran_app/core/widgets/app_icon.dart';

class CopyIconWidget extends StatefulWidget {
  const CopyIconWidget({required this.text, super.key});
  final String text;

  @override
  State<CopyIconWidget> createState() => _CopyIconWidgetState();
}

class _CopyIconWidgetState extends State<CopyIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  bool _isCopied = false;
  Timer? _resetTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _resetTimer?.cancel();
    super.dispose();
  }

  Future<void> _handleCopy() async {
    if (_isCopied) return; // Prevent multiple clicks during animation

    // Start animation
    setState(() {
      _isCopied = true;
    });

    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    // Copy to clipboard
    await CopyService.copyToClipboard(widget.text);

    // Reset after 1 second
    _resetTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                );
              },
              child: AppIcon(
                _isCopied ? AppIcons.copyDone : AppIcons.copy,
                key: ValueKey(_isCopied),
                color: _isCopied ? Colors.green : context.primaryColor,
                size: 20.sp,
              ),
            ),
            onPressed: _handleCopy,
          ),
        );
      },
    );
  }
}
