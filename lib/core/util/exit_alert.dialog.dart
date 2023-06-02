import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:quran_app/core/theme/themeData.dart';

class MyAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      backgroundColor: Colors.grey.shade800,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorsManager.customMainThird,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Lottie.asset('assets/lottie/walking.json'),
          ),
          Text(
            'هل تريد حقا الخروج',
            style: titleMedium(context),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text(
                  'نعم',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'لا',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
