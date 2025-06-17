import 'package:flutter/material.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/widgets/auto_text.dart';

class ItemDetailOfflineWidget extends StatelessWidget {
  ItemDetailOfflineWidget({
    required this.current,
    super.key,
    this.onTap,
    this.data,
  });
  dynamic data;
  int current;
  void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: context.primaryScheme,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  'العنوان : ${data['title'] as String}'.autoSize(
                    context,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "التاريخ:  ${data['time'].toString().split(' ').first}",
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 15,
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: data['type'].toString().autoSize(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
