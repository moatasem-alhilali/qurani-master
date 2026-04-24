import 'package:flutter/material.dart';
import 'package:quran_app/features/smart_outreach/data/model/smart_outreach_bundle_models.dart';

class SmartOutreachScheduleItemCard extends StatelessWidget {
  const SmartOutreachScheduleItemCard({
    required this.bundle,
    required this.onTap,
    required this.onStart,
    required this.onDelete,
    required this.onToggle,
    super.key,
  });

  final SmartOutreachScheduleBundle bundle;
  final VoidCallback onTap;
  final VoidCallback onStart;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final schedule = bundle.schedule;
    final timeLabel = TimeOfDay(
      hour: schedule.hour,
      minute: schedule.minute,
    ).format(context);

    final daysLabel = schedule.isDaily
        ? 'كل يوم'
        : schedule.scheduleDays.map(_weekdayLabel).join('، ');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        schedule.title,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$timeLabel • $daysLabel',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: schedule.isEnabled,
                  onChanged: onToggle,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                _MetaChip(
                  icon: Icons.group_outlined,
                  label: '${bundle.contacts.length} رقم',
                ),
                _MetaChip(
                  icon: Icons.ring_volume_outlined,
                  label: 'انتظار الرد ${schedule.ringTimeout}ث',
                ),
                _MetaChip(
                  icon: Icons.call_end_outlined,
                  label: 'بعد الرد ${schedule.hangupDelay}ث',
                ),
                _MetaChip(
                  icon: Icons.timelapse_outlined,
                  label: 'بين الأرقام ${schedule.delayBetweenCalls}ث',
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: <Widget>[
                FilledButton.icon(
                  onPressed: onStart,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('ابدأ الآن'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('تعديل'),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'حذف القائمة',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _weekdayLabel(int day) {
    switch (day) {
      case 1:
        return 'الإثنين';
      case 2:
        return 'الثلاثاء';
      case 3:
        return 'الأربعاء';
      case 4:
        return 'الخميس';
      case 5:
        return 'الجمعة';
      case 6:
        return 'السبت';
      case 7:
        return 'الأحد';
      default:
        return '$day';
    }
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}
