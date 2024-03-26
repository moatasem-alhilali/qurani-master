import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/Home/cubit.dart';
import 'package:quran_app/core/Home/state.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:quran_app/core/widgets/auto_text.dart';
import 'package:quran_app/features/sabih/cubit/subih_cubit.dart';
import 'package:quran_app/features/sabih/widgets/page_view_subih.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SabihScreen extends StatelessWidget {
  SabihScreen({super.key});
  PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return BlocProvider(
          create: (context) => SubihCubit(),
          child: BaseHome(
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
            leading: IconButton(
              onPressed: () {
                masbahSize = 0;
                CashHelper.setData(key: 'subih', value: masbahSize);
                HomeCubit.get(context).mySetState();
              },
              icon: const Icon(
                Icons.restart_alt_outlined,
                size: 30,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //cursolu slider of text subih
                  PageViewSubih(controller: controller),
                  const SizedBox(
                    height: 15,
                  ),
                  //Smooth Page Indicator
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

                  //
                  SizedBox(
                    height: SizeConfig.blockSizeVertical! * 25,
                  ),
                  //
                  InkWell(
                    onTap: () {
                      CashHelper.setData(key: 'subih', value: masbahSize);
                      HomeCubit.get(context).ChangedMasbahState();
                    },
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: const Color.fromRGBO(253, 49, 34, 1),
                      child: Text(
                        "$masbahSize",
                        style: titleSmall(context).copyWith(fontSize: 60),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
