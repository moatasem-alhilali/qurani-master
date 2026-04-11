import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
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

    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: CardWidget(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    schedule.title,
                    style: context.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Switch(
                  value: schedule.isEnabled,
                  onChanged: onToggle,
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              '$timeLabel • ${bundle.contacts.length} جهات اتصال',
              style: context.bodySmall,
            ),
            if ((schedule.note ?? '').trim().isNotEmpty) ...[
              SizedBox(height: 6.h),
              Text(
                schedule.note!,
                style: context.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            SizedBox(height: 10.h),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: onStart,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('ابدأ'),
                ),
                SizedBox(width: 8.w),
                OutlinedButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('تعديل'),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
