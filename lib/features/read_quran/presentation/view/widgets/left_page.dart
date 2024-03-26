import 'package:flutter/material.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/my_extensions.dart';

class LeftPage extends StatelessWidget {
  final Widget child;
  const LeftPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Quran Page',
      child: Container(
        height: context.getScreenHeight(),
        margin: const EdgeInsets.only(left: 4.0),
        decoration: BoxDecoration(
            color: FxColors.primary.withOpacity(.5),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12), bottomLeft: Radius.circular(12))),
        child: Container(
          margin: const EdgeInsets.only(left: 4.0),
          decoration: BoxDecoration(
              color: FxColors.primary.withOpacity(.7),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12))),
          child: Container(
            margin: const EdgeInsets.only(left: 4.0),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12))),
            child: child,
          ),
        ),
      ),
    );
  }
}
