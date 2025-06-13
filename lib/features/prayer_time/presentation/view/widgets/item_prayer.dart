import 'package:flutter/material.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/prayer_time/data/model/time_prayer_model.dart';

class ItemPrayerWidget extends StatefulWidget {
  const ItemPrayerWidget({
    super.key,
    required this.data,
    this.nextPray,
    required this.index,
    required this.nextCurrent,
  });

  final TimePrayerModel data;
  final TimePrayerModel? nextPray;
  final int index;
  final int nextCurrent;

  @override
  State<ItemPrayerWidget> createState() => _ItemPrayerWidgetState();
}

class _ItemPrayerWidgetState extends State<ItemPrayerWidget> {
  bool isMaxLine = false;

  @override
  Widget build(BuildContext context) {
    final isNext = widget.nextPray?.id == widget.data.id;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).primaryColor,
        border: isNext ? Border.all(color: Colors.white, width: 1.5) : null,
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            isMaxLine = !isMaxLine;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        widget.data.image,
                        height: context.getHight(4),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.data.title,
                      style: titleMedium(context),
                    ),
                  ],
                ),
                Text(
                  widget.data.time,
                  style: titleMedium(context).copyWith(
                    color: Colors.grey,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.data.content,
              maxLines: isMaxLine ? null : 1,
              overflow: isMaxLine ? null : TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
