import 'package:flutter/material.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BaseSmoothPageIndicator extends StatelessWidget {
  const BaseSmoothPageIndicator({
    required this.controller,
    required this.count,
    super.key,
  });
  final PageController controller;
  final int count;
  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      count: count,
      controller: controller,
      effect: ExpandingDotsEffect(
        dotWidth: 10,
        dotHeight: 10,
        activeDotColor: context.primarySecondary,
      ),
    );
  }
}
