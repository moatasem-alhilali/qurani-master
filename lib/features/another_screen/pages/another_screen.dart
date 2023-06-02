import 'package:flutter/material.dart';
import 'package:quran_app/core/components/base_home.dart';
import 'package:quran_app/features/another_screen/widgets/another_featuers.dart';

import 'package:quran_app/core/shared/export/export-shared.dart';

class AnotherScreen extends StatelessWidget {
  const AnotherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BaseHome(
        customAppBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "متفرقات",
                      style: titleMedium(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: const [
            //another feather
            AnotherFeatures(),
          ],
        ),
      ),
    );
  }
}
