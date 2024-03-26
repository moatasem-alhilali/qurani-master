import 'package:flutter/material.dart';
import 'package:quran_app/core/components/custom_container.dart';
import 'package:quran_app/core/constant.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:quran_app/core/theme/themeData.dart';
import 'package:quran_app/features/thikr/pages/wird_screen.dart';

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
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "الورد اليومي",
            style: titleMedium(context).copyWith(color: FxColors.primary),
          ),
        ),
        _item(
          data:
              "يقول تعالى “ والذاكرين الله كثيرا والذاكرات أعد الله لهم مغفرة وأجرا عظيما”",
        ),
      ],
    );
  }
}

class _item extends StatelessWidget {
  _item({
    super.key,
    required this.data,
  });

  dynamic data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (DateTime.now().hour >= 17) {
          navigateTo(WirdScreen(), context);
        } else {
          navigateTo(WirdScreen(), context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: CustomContainer(
          height: SizeConfig.blockSizeVertical! * 20,
          image: "image/time.jpg",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: Text(
                  data,
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
