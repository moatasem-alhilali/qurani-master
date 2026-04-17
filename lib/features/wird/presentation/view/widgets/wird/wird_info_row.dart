import 'package:flutter/material.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';

class WirdInfoRow extends StatelessWidget {
  const WirdInfoRow({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: context.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 3),
        SelectableText(
          content,
          textDirection: TextDirection.rtl,
          style: context.bodyMedium?.copyWith(height: 1.6),
        ),
      ],
    );
  }
}
