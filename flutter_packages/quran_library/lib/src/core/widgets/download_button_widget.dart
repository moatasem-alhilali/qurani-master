import 'package:flutter/material.dart';

class DownloadButtonWidget extends StatelessWidget {
  final bool preparing;
  final bool downloading;
  final double progress;
  final bool isSelected;
  final bool downloaded;
  final bool isVisible;
  final Color background;
  final Color valueColor;
  final void Function() onTap;
  final List<Widget> children;
  final Color borderColor;
  const DownloadButtonWidget({
    super.key,
    required this.preparing,
    required this.downloading,
    required this.progress,
    required this.isSelected,
    required this.downloaded,
    required this.isVisible,
    required this.background,
    required this.valueColor,
    required this.onTap,
    required this.children,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: AnimatedContainer(
        height: isSelected ? 65 : 55,
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        decoration: BoxDecoration(
          color: isSelected
              ? background.withValues(alpha: .05)
              : Colors.transparent,
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            _DownloadProgressBackground(
              isVisible: isVisible,
              progress: progress,
              downloading: downloading,
              background: background,
              valueColor: valueColor,
            ),
            InkWell(
              onTap: onTap,
              child: SizedBox(
                height: isSelected ? 65 : 55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DownloadProgressBackground extends StatelessWidget {
  final bool isVisible;
  final double progress;
  final bool downloading;
  final Color background;
  final Color valueColor;

  const _DownloadProgressBackground({
    required this.isVisible,
    required this.progress,
    required this.downloading,
    required this.background,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    const double buttonHeight = 55;
    const double radius = 8;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: double.infinity,
        height: buttonHeight,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: progress),
          duration: const Duration(milliseconds: 1000),
          curve: Curves.fastEaseInToSlowEaseOut,
          builder: (context, value, child) => LinearProgressIndicator(
            minHeight: buttonHeight,
            value: downloading ? (value / 100).clamp(0.0, 1.0) : null,
            backgroundColor: background,
            valueColor: AlwaysStoppedAnimation<Color>(
              valueColor.withValues(alpha: .25),
            ),
          ),
        ),
      ),
    );
  }
}
