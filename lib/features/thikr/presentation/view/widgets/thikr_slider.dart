import 'package:flutter/material.dart';
import 'package:quran_app/core/components/custom_container.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/core/util/my_extensions.dart';
import 'package:quran_app/features/wird/presentation/view/pages/wird_screen.dart';

class ThikrSlider extends StatelessWidget {
  const ThikrSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'الورد اليومي',
            style: titleMedium(context).copyWith(color: context.primaryColor),
          ),
        ),
        const _item(
          data:
              'يقول تعالى “ والذاكرين الله كثيرا والذاكرات أعد الله لهم مغفرة وأجرا عظيما”',
        ),
      ],
    );
  }
}

class _item extends StatelessWidget {
  const _item({
    required this.data,
    super.key,
  });

  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (DateTime.now().hour >= 17) {
          context.push(const WirdScreen(isMorning: false));
        } else {
          context.push(const WirdScreen(isMorning: true));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: CustomContainer(
          height: context.getHight(20),
          image: 'image/time.jpg',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(
                  data as String,
                  style: titleMedium(context)
                      .copyWith(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
