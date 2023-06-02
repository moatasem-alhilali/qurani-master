import 'package:flutter/material.dart';
import 'package:quran_app/core/theme/themeData.dart';

class TaskNotification extends StatelessWidget {
  const TaskNotification(
      {super.key,
      required this.time,
      required this.title,
      required this.onTap});
  final String title;
  final String time;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).primaryColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: titleMedium(context),
                ),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const Icon(
              Icons.notifications_active,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
