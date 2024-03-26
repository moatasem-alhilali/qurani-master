import 'package:flutter/material.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/features/allh_name/widgets/allh_name_item.dart';

class AllhNameScreen extends StatelessWidget {
  const AllhNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseHome(
      title: "أسماء الله الحسنى",
      body: ItemAllhName(),
    );
  }
}
