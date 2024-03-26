import 'package:flutter/material.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BaseSmoothPageIndicator extends StatelessWidget {
  const BaseSmoothPageIndicator({
    super.key,
    required this.controller,
    required this.count,
  });
  final PageController controller;
  final int count;
  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      count: count,
      controller: controller,
      effect: ExpandingDotsEffect(
        dotWidth: 10.0,
        dotHeight: 10.0,
        dotColor: Colors.grey,
        activeDotColor: FxColors.primarySecondary,
      ),
    );
  }
}
