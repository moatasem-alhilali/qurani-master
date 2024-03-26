import 'package:flutter/material.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';

class DoaItem extends StatelessWidget {
  DoaItem(
      {super.key,
      this.title,
      this.content,
      this.number,
      this.onLongPress,
      this.onTap,
      required this.color,
      this.fontFamily,
      required this.childPageNumber,
      this.text});
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
    return InkWell(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.only(bottom: 8, left: 12, top: 12, right: 5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: color,
        ),
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
                style: TextStyle(
                  wordSpacing: 3,
                  fontFamily: fontFamily ?? 'ios-1',
                  color: const Color.fromARGB(255, 218, 217, 217),
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      number!,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: fontFamily ?? 'ios-1',
                        color: FxColors.primary,
                        fontSize: fontSizeAthkar,
                      ),
                    ),
                  ),
                  childPageNumber
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
