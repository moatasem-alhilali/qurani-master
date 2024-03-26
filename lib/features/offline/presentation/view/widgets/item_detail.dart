import 'package:flutter/material.dart';
import 'package:quran_app/core/widgets/auto_text.dart';

class ItemDetailOffline extends StatelessWidget {
  ItemDetailOffline({
    Key? key,
    required this.current,
    this.onTap,
    this.data,
  }) : super(key: key);
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
          color: Theme.of(context).primaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ("العنوان : " + data['title'])
                      .toString()
                      .autoSize(context, maxLines: 1, minFontSize: 12),
                  const SizedBox(height: 5),
                  Text(
                    "التاريخ:  ${data['time'].toString().split(" ").first}",
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
                    padding: const EdgeInsets.all(8.0),
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
