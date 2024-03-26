import 'package:flutter/material.dart';
import 'package:quran_app/features/qiblah/qiblah_main.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class FunctionNavigate {
  static final ItemScrollController scrollSurahController =
      ItemScrollController();
  static final ItemPositionsListener positionsSurahListener =
      ItemPositionsListener.create();
  //!
  static void goToQiplah({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QiblahMain(),
      ),
    );
  }

//!
 
}
