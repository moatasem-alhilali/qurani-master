import 'package:flutter/material.dart';

Future<String?> showSmartOutreachPhonePicker(
  BuildContext context,
  List<String> phoneNumbers,
) {
  final unique = phoneNumbers
      .map((value) => value.trim())
      .where((value) => value.isNotEmpty)
      .toSet()
      .toList(growable: false);

  if (unique.isEmpty) {
    return Future<String?>.value(null);
  }

  if (unique.length == 1) {
    return Future<String?>.value(unique.first);
  }

  return showModalBottomSheet<String>(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text('اختر رقم الهاتف'),
              subtitle: Text('هذه الجهة تحتوي على أكثر من رقم'),
            ),
            ...unique.map(
              (phone) => ListTile(
                leading: const Icon(Icons.phone_outlined),
                title: Text(phone),
                onTap: () => Navigator.of(context).pop(phone),
              ),
            ),
          ],
        ),
      );
    },
  );
}
