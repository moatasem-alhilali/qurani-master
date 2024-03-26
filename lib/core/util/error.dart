import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';

import '../components/shimmer_base.dart';

class BaseNoData extends StatelessWidget {
  const BaseNoData({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BaseShimmer(
        child: Text(
          text.toUpperCase(),
          textAlign: TextAlign.center,
          // style: titleMedium(context).copyWith(fontSize: 22),
        ),
      ),
    ).animate().fade();
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
          )
        ],
      ),
    ).animate().fade();
  }
}
