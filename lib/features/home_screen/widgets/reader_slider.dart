import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran_app/core/jsons/moast_reader_text.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';
import 'package:quran_app/features/quran_audio/ui/pages/audio_home.dart';

class ReaderSlider extends StatelessWidget {
  const ReaderSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
          child: Text(
            "قراء مشهورين",
            style: titleMedium(context)
                .copyWith(color: ColorsManager.customPrimary),
          ),
        ),
        CarouselSlider.builder(
          itemCount: mostReaderData.length,
          itemBuilder:
              (BuildContext context, int itemIndex, int pageViewIndex) {
            var data = mostReaderData[itemIndex];
            return _svgSlider(
              svg: data['image'],
              name: data['name'],
            );
          },
          options: CarouselOptions(
            height: SizeConfig.blockSizeVertical! * 25,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeFactor: 0.3,
            scrollDirection: Axis.horizontal,
          ),
        ).animate(
          effects: [
            FadeEffect(duration: 1000.ms),
          ],
          autoPlay: true,
        ),
      ],
    );
  }
}

class _svgSlider extends StatelessWidget {
  const _svgSlider({super.key, required this.svg, required this.name});
  final String svg;
  final String name;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateTo(AudioHome(), context);
      },
      child: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SvgPicture.asset(
              svg,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.grey.withOpacity(0.0),
                  Colors.black,
                ],
                stops: [0.0, 1.0],
              ),
            ),
            child: Text(
              "القارئ  : $name",
              style: titleSmall(context),
            ),
          ),
        ],
      ),
    );
  }
}
