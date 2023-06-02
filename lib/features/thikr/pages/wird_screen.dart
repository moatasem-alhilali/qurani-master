import 'package:flutter/material.dart';
import 'package:quran_app/core/components/animation_list.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/components/doa_item.dart';
import 'package:quran_app/core/jsons/wird.dart';
import 'package:quran_app/core/services/clip_board_services.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:quran_app/core/util/toast_manager.dart';
import 'package:quran_app/core/theme/themeData.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WirdScreen extends StatefulWidget {
  WirdScreen({super.key});

  @override
  State<WirdScreen> createState() => _WirdScreenState();
}

class _WirdScreenState extends State<WirdScreen> {
  PageController controller = PageController();

  int current = 0;

  @override
  Widget build(BuildContext context) {
    return BaseHome(
      customAppBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "المأثورات",
              style: titleMedium(context),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
          ],
        ),
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

                return BaseAnimationListView(
                  duration: 100,
                  index: index,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      DoaItem(
                        childPageNumber: Text(
                          "${wird.length - 1}/$current",
                          style: titleSmall(context).copyWith(
                            color: ColorsManager.customPrimary,
                          ),
                        ),
                        fontFamily: 'ios-1',
                        color: Theme.of(context).primaryColor,
                        content: datathikr['content'],
                        text: datathikr['text'],
                        number: 'التكرار :  ${datathikr['counter']} ',
                        onTap: () async {
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
              activeDotColor: ColorsManager.customPrimary,
              dotHeight: 15,
              dotWidth: 15,
            ),
          ),
        ],
      ),
    );
  }
}
