import 'package:flutter/material.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/features/sabih/data/model/subih_model.dart';

class DhikrStatsCard extends StatelessWidget {
  const DhikrStatsCard({
    required this.subih,
    required this.count,
    super.key,
  });
  final SubihModel subih;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.secondary,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          subih.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (subih.isCustom)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: context.primaryScheme.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Custom',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subih.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            _buildCountDisplay(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCountDisplay(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: count > 0 ? theme.primaryColor : Colors.grey[300],
      ),
      alignment: Alignment.center,
      child: Text(
        count.toString(),
        style: TextStyle(
          color: count > 0 ? Colors.white : Colors.grey[600],
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}
