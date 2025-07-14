import 'package:flutter/material.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/prayer_time/data/model/time_prayer_model.dart';
import 'package:quran_app/features/prayer_time/presentation/view/pages/prayer_time_screen.dart';
import 'package:quran_app/features/prayer_time/presentation/view/widgets/prayer_time_animations.dart';

class ItemPrayerWidget extends StatefulWidget {
  const ItemPrayerWidget({
    required this.currentPrayer,
    this.nextPray,
    this.isNavigate = false,
    super.key,
  });

  final TimePrayerModel currentPrayer;
  final TimePrayerModel? nextPray;
  final bool isNavigate;

  @override
  State<ItemPrayerWidget> createState() => _ItemPrayerWidgetState();
}

class _ItemPrayerWidgetState extends State<ItemPrayerWidget> {
  bool isMaxLine = false;

  @override
  Widget build(BuildContext context) {
    final isNext = widget.nextPray?.id == widget.currentPrayer.id;

    return StyleButtonWrap(
      onTap: () {
        if (widget.isNavigate) {
          context.push(
            const PrayerTimeScreen(),
          );
        } else {
          setState(() {
            isMaxLine = !isMaxLine;
          });
        }
      },
      child: CardWidget(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
        border: isNext ? Border.all(color: Colors.white, width: 1.5) : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    PrayerTimeAnimationWidget(
                      prayerType: widget.currentPrayer.type,
                      size: context.getHight(4),
                      isActive: isNext,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.currentPrayer.title,
                      style: titleMedium(context),
                    ),
                  ],
                ),
                Text(
                  widget.currentPrayer.time,
                  style: titleMedium(context).copyWith(
                    color: Colors.grey,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.currentPrayer.content,
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
