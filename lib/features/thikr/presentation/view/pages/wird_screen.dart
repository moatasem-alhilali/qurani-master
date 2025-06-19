import 'package:flutter/material.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/components/doa_item.dart';
import 'package:quran_app/core/components/shimmer_widget.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/jsons/wird.dart';
import 'package:quran_app/core/services/copy_service.dart';
import 'package:quran_app/core/theme/theme_data.dart';
import 'package:quran_app/core/util/my_extensions.dart';
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
          '“يقول تعالى \n والذاكرين الله كثيرا والذاكرات \n أعد الله لهم مغفرة وأجرا عظيما”'
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
            height: context.getHight(70),
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
                final datathikr = wird[index];

                return BaseAnimateFlipList(
                  index: index,
                  child: Column(
                    children: [
                      DoaItem(
                        childPageNumber: Text(
                          '${wird.length - 1}/$current',
                          style: titleSmall(context).copyWith(
                            color: context.primaryScheme,
                          ),
                        ),
                        fontFamily: 'ios-1',
                        color: context.primaryScheme,
                        content: datathikr['content'] as String?,
                        text: datathikr['text'] as String,
                        number: 'التكرار :  ${datathikr['counter']} ',
                        onLongPress: () async {
                          await CopyService.copyToClipboard(
                            datathikr['text'] as String,
                          );
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
            effect: ExpandingDotsEffect(
              spacing: 15,
              radius: 10,
              activeDotColor: context.primaryScheme,
              dotHeight: 15,
              dotWidth: 15,
            ),
          ),
        ],
      ),
    );
  }
}
