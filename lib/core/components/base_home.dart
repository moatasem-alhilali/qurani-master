import 'dart:math';

import 'package:al_quran/al_quran.dart';
import 'package:flutter/material.dart';
import 'package:quran_app/core/services/services_notification.dart';

import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';

class BaseHome extends StatelessWidget {
  BaseHome(
      {super.key,
      required this.body,
      required this.customAppBar,
      this.customAppBarHight,
      this.drawer,
      this.color});
  final Widget body;
  final Widget customAppBar;
  double? customAppBarHight;
  Widget? drawer;
  Color? color;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        // ),
        drawer: drawer,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: customAppBarHight ?? SizeConfig.blockSizeVertical! * 10,
                child: customAppBar,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: color ?? Theme.of(context).splashColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: body,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
