import 'package:flutter/material.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';

class BaseNoData extends StatelessWidget {
  const BaseNoData({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text.toUpperCase(),
        textAlign: TextAlign.center,
        // style: titleMedium(context).copyWith(fontSize: 22),
      ),
    );
  }
}

class BaseErrorRobot extends StatelessWidget {
  const BaseErrorRobot({
    super.key,
    this.onPressed,
    this.message = 'المعذره حث خطأ ما',
  });
  final void Function()? onPressed;
  final String message;
  @override
  Widget build(BuildContext context) {
    return Align(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: onPressed,
            icon: const Icon(
              Icons.refresh,
              size: 40,
              color: Colors.red,
            ),
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: titleMedium(context)
                .copyWith(fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
