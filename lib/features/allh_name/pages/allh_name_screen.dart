import 'package:flutter/material.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/features/allh_name/widgets/allh_name_item.dart';

class AllhNameScreen extends StatelessWidget {
  const AllhNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseHome(
      customAppBar: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          Text(
            "أسماء الله الحسنى",
            style: titleMedium(context),
          ),
        ],
      ),
      body: const ItemAllhName(),
    );
  }
}
