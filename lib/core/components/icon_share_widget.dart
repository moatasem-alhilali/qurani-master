import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/services/share_service.dart';

class IconShareWidget extends StatefulWidget {
  const IconShareWidget({
    required this.text,
    this.subject,
    super.key,
  });

  final String text;
  final String? subject;

  @override
  State<IconShareWidget> createState() => _IconShareWidgetState();
}

class _IconShareWidgetState extends State<IconShareWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  bool _isShared = false;
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

  Future<void> _handleShare() async {
    if (_isShared) return; // Prevent multiple clicks during animation

    // Start animation
    setState(() {
      _isShared = true;
    });

    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    try {
      HapticFeedback.mediumImpact();
      // Share content
      await ShareService.shareText(
        text: widget.text,
        subject: widget.subject,
      );
    } catch (e) {
      // Handle share error silently or show a snackbar if needed
      debugPrint('Share error: $e');
    }

    // Reset after 1 second
    _resetTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isShared = false;
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
              child: Icon(
                _isShared ? CupertinoIcons.check_mark : CupertinoIcons.share,
                key: ValueKey(_isShared),
                color: _isShared ? Colors.green : context.primaryScheme,
                size: 20.sp,
              ),
            ),
            onPressed: _handleShare,
          ),
        );
      },
    );
  }
}
