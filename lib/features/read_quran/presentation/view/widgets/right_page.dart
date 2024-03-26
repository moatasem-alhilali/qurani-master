import 'package:flutter/material.dart';

class RightPage extends StatelessWidget {
  final Widget child;
  const RightPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Quran Page',
      
      child: child,
    );
  }
}
