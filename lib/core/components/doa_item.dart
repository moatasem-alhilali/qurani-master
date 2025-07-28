import 'package:flutter/material.dart';
import 'package:quran_app/core/components/button_progress_state.dart';
import 'package:quran_app/core/components/card_widget.dart';
import 'package:quran_app/core/extensions/theme_extensions.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';

class DoaItem extends StatelessWidget {
  DoaItem({
    required this.color,
    required this.childPageNumber,
    super.key,
    this.title,
    this.content,
    this.number,
    this.onLongPress,
    this.onTap,
    this.fontFamily,
    this.text,
  });
  String? title;
  Widget? titleWidget;
  String? content;
  String? text;
  String? number;
  String? fontFamily;
  Color color = defaultColor;
  bool isBottom = true;
  void Function()? onLongPress;
  void Function()? onTap;
  final Widget childPageNumber;
  @override
  Widget build(BuildContext context) {
    return StyleButtonWrap(
      onTap: onTap,
      onLongPress: onLongPress,
      child: CardWidget(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                text!,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.start,
                style: context.bodyMedium?.copyWith(
                    // wordSpacing: 3,
                    // fontFamily: fontFamily ?? 'ios-1',
                    // color: context.gray2,
                    // fontSize: 13.sp,
                    ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      number!,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: fontFamily ?? 'ios-1',
                        color: context.primaryColor,
                        fontSize: fontSizeAthkar,
                      ),
                    ),
                  ),
                  childPageNumber,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
