import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BaseShimmer extends StatelessWidget {
  const BaseShimmer({super.key,required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.8,
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).primaryColor,
        highlightColor: Color.fromARGB(211, 255, 255, 255),
        child: child,
      ),
    );
  }
}
