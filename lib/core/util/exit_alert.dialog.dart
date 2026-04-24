import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_app/core/theme/theme_data.dart';

void showMyAlert({
  required BuildContext context,
}) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(
        'تنبيه',
        style: titleMedium(context).copyWith(fontSize: 20, color: Colors.red),
      ),
      content: Text(
        'هل أنت متأكد من الخروج من التطبيق',
        style: titleMedium(context).copyWith(fontSize: 14),
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          onPressed: () async {
            Navigator.pop(context);
            await SystemNavigator.pop();
          },
          child: Text(
            'نعم',
            style: titleMedium(context),
          ),
        ),
        CupertinoDialogAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'لا',
            style: titleMedium(context),
          ),
        ),
      ],
    ),
  );
}
