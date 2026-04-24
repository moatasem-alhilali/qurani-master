import 'package:flutter/material.dart';

Future<String?> showSmartOutreachPhonePicker(
  BuildContext context,
  List<String> phoneNumbers,
) {
  final unique = phoneNumbers
      .map((value) => value.trim())
      .where((value) => value.isNotEmpty)
      .toSet()
      .toList();

  if (unique.isEmpty) {
    return Future.value();
  }

  if (unique.length == 1) {
    return Future.value(unique.first);
  }

  return showModalBottomSheet<String>(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text('اختر الرقم'),
              subtitle: Text('هذا الاسم فيه أكثر من رقم'),
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
