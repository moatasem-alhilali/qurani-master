import 'package:flutter/material.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

enum SnackbarPosition { top, center, bottom }

class SnackBarType {
  const SnackBarType({
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
  });
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;

  static const success = SnackBarType(
    backgroundColor: Color(0xFF4CB782),
    icon: Icons.check_circle_rounded,
    iconColor: Colors.white,
  );
  static const error = SnackBarType(
    backgroundColor: Color(0xFFE35D6A),
    icon: Icons.cancel_rounded,
    iconColor: Colors.white,
  );
  static const warning = SnackBarType(
    backgroundColor: Color(0xFFFFC94B),
    icon: Icons.warning_rounded,
    iconColor: Colors.brown,
  );
}
class AnimatedSnackbarWidget extends StatefulWidget {
  const AnimatedSnackbarWidget({
    required this.message,
    required this.style,
    this.actionLabel,
    this.onAction,
    this.actionTextColor,
    super.key,
  });

  final String message;
  final SnackBarType style;

  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? actionTextColor;

  @override
  State<AnimatedSnackbarWidget> createState() => _AnimatedSnackbarWidgetState();
}

class _AnimatedSnackbarWidgetState extends State<AnimatedSnackbarWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctl;
  late final Animation<double> _iconScale;
  late final Animation<double> _iconRotate;

  @override
  void initState() {
    super.initState();
    _ctl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..forward();

    _iconScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 1.25)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.25, end: 1)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
    ]).animate(_ctl);

    _iconRotate = Tween<double>(begin: -0.18, end: 0).animate(
      CurvedAnimation(parent: _ctl, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWarning = widget.style == SnackBarType.warning;
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: widget.style.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: widget.style.backgroundColor.withOpacity(.22),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _ctl,
            builder: (_, __) => _AnimatedSnackbarIcon(
              scale: _iconScale,
              rotate: _iconRotate,
              icon: widget.style.icon,
              iconColor: widget.style.iconColor,
              mainColor: widget.style.backgroundColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.message,
              style: TextStyle(
                color: isWarning ? Colors.brown.shade800 : Colors.white,
                fontSize: 14.5,
                height: 1.25,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (widget.actionLabel != null && widget.onAction != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  foregroundColor: widget.actionTextColor ??
                      (isWarning
                          ? Colors.brown.shade800
                          : Colors.white),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: widget.onAction,
                child: Text(
                  widget.actionLabel!,
                  style: context.bodyMedium?.copyWith(
                    color: isWarning ? Colors.brown.shade800 : Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AnimatedSnackbarIcon extends StatelessWidget {
  const _AnimatedSnackbarIcon({
    required this.scale,
    required this.rotate,
    required this.icon,
    required this.iconColor,
    required this.mainColor,
  });

  final Animation<double> scale;
  final Animation<double> rotate;
  final IconData icon;
  final Color iconColor;
  final Color mainColor;

  @override
  Widget build(BuildContext context) {
    final glow = scale.value.clamp(0.6, 1.0);

    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedOpacity(
          opacity: glow * 0.9,
          duration: const Duration(milliseconds: 180),
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white24,
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                mainColor.withValues(alpha: 0.23),
                mainColor.withValues(alpha: 0.16),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: mainColor.withValues(alpha: 0.29),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.17),
              width: 1.4,
            ),
          ),
        ),
        Container(
          width: 21,
          height: 21,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: mainColor,
            boxShadow: [
              BoxShadow(
                color: mainColor.withValues(alpha: 0.18),
                blurRadius: 6,
                spreadRadius: 0.5,
              ),
            ],
          ),
        ),
        Transform.rotate(
          angle: rotate.value,
          child: Transform.scale(
            scale: scale.value,
            child: Icon(icon, size: 18, color: iconColor),
          ),
        ),
      ],
    );
  }
}
