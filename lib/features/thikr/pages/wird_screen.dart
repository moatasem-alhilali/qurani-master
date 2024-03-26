import 'package:flutter/material.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/components/doa_item.dart';
import 'package:quran_app/core/components/shimmer_base.dart';
import 'package:quran_app/core/jsons/wird.dart';
import 'package:quran_app/core/services/clip_board_services.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:quran_app/core/util/toast_manager.dart';
import 'package:quran_app/core/theme/themeData.dart';
import 'package:quran_app/core/widgets/auto_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WirdScreen extends StatefulWidget {
  const WirdScreen({super.key});

  @override
  State<WirdScreen> createState() => _WirdScreenState();
}

class _WirdScreenState extends State<WirdScreen> {
  PageController controller = PageController();

  int current = 0;

  @override
  Widget build(BuildContext context) {
    return BaseHome(
      titleWidget:
          "“يقول تعالى \n والذاكرين الله كثيرا والذاكرات \n أعد الله لهم مغفرة وأجرا عظيما”"
              .autoSize(
        context,
        fontSize: 12,
        minFontSize: 8,
        maxLines: 3,
        color: Colors.grey,
        textAlign: TextAlign.center,
      ),
      body: Column(
        children: [
          SizedBox(
            height: SizeConfig.blockSizeVertical! * 70,
            child: PageView.builder(
              controller: controller,
              physics: const BouncingScrollPhysics(),
              itemCount: wird.length,
              onPageChanged: (index) {
                setState(() {
                  current = index;
                });
              },
              itemBuilder: (context, index) {
                var datathikr = wird[index];

                return BaseAnimateFlipList(
                  index: index,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      DoaItem(
                        childPageNumber: Text(
                          "${wird.length - 1}/$current",
                          style: titleSmall(context).copyWith(
                            color: FxColors.primary,
                          ),
                        ),
                        fontFamily: 'ios-1',
                        color: Theme.of(context).primaryColor,
                        content: datathikr['content'],
                        text: datathikr['text'],
                        number: 'التكرار :  ${datathikr['counter']} ',
                        onLongPress: () async {
                          await ClipBoardServices.copyText(
                              text: datathikr['text']);
                          ToastServes.showToast(message: 'تم النسخ بنجاح');
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SmoothPageIndicator(
            controller: controller,
            count: 6,
            axisDirection: Axis.horizontal,
            effect: ExpandingDotsEffect(
              spacing: 15.0,
              radius: 10.0,
              activeDotColor: FxColors.primary,
              dotHeight: 15,
              dotWidth: 15,
            ),
          ),
        ],
      ),
    );
  }
}
