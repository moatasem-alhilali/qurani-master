import 'package:flutter/material.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:quran_app/features/prayer_time/model/time_prayer_model.dart';

class ItemPrayer extends StatefulWidget {
  const ItemPrayer({
    super.key,
    required this.data,
    required this.nextCurrent,
    required this.index,
    required this.nextPray,
  });
  final TimePrayerModel data;
  final TimePrayerModel nextPray;
  final int index;
  final int nextCurrent;

  @override
  State<ItemPrayer> createState() => _ItemPrayerState();
}

class _ItemPrayerState extends State<ItemPrayer> {
  bool isMaxLine = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).primaryColor,
        border: widget.nextCurrent == widget.index
            ? Border.all(color: Colors.white)
            : null,
      ),
      child: InkWell(
        onTap: () {
          isMaxLine = !isMaxLine;
          setState(() {});
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
                        height: SizeConfig.blockSizeVertical! * 4,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
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
