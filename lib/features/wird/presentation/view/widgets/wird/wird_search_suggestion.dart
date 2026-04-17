import 'package:flutter/material.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/features/wird/data/models/wird_model.dart';

class WirdSearchSuggestion extends StatelessWidget {
  const WirdSearchSuggestion({super.key, required this.item});

  final WirdModel item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(
        item.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.titleSmall,
      ),
      subtitle: Text(
        item.text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.bodySmall,
      ),
    );
  }
}
