import 'package:flutter/material.dart';
import 'package:quran_app/core/extensions/text_styles_extension.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

class ErrorRetryWidget extends StatelessWidget {
  const ErrorRetryWidget({
    required this.message,
    super.key,
    this.statusCode,
    this.onRetry,
    this.icon,
    this.color,
    this.title,
  });

  /// Main error message to show
  final String message;

  /// Status code from Failure (int)
  final int? statusCode;

  /// Retry callback (optional)
  final VoidCallback? onRetry;

  /// Custom error icon (optional)
  final Widget? icon;

  /// Main color (optional)
  final Color? color;

  /// Optional title above the message
  final String? title;

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? Theme.of(context).colorScheme.error;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon ?? Icon(Icons.error, color: iconColor),
            if (title != null) ...[
              const SizedBox(height: 8),
              Text(
                title!,
                style: context.titleMedium?.copyWith(
                    color: iconColor, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 8),
            Text(
              message,
              style: context.bodyMedium?.copyWith(
                  color: iconColor, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            if (statusCode != null) ...[
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (statusCode != null)
                    Text(
                      'الحالة: $statusCode',
                      style: context.titleMedium?.copyWith(
                          color: iconColor.withValues(alpha: 0.7)),
                    ),
                ],
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 18),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, color: Colors.black),
                label: const Text(
                  'إعادة المحاولة',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
