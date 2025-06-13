import 'package:flutter/material.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';

class MyInputField extends StatelessWidget {
  MyInputField({
    Key? key,
    this.hint,
    this.title,
    this.controller,
    this.height,
    this.textAlign,
    this.textStyle,
    required this.isTitle,
    this.width,
  }) : super(key: key);
  final String? hint;
  double? height;
  final String? title;
  TextEditingController? controller;
  bool isTitle = true;
  TextAlign? textAlign;
  TextStyle? textStyle;
  double? width;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      alignment: Alignment.center,
      // color: ColorsManager.gray,
      width: width ?? double.infinity,
      margin: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          isTitle
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title!,
                    style: titleSmall(context),
                  ),
                )
              : Container(),
          Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color.fromARGB(138, 158, 158, 158)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: titleMedium(context).copyWith(),
                      maxLines: null,
                      cursorWidth: 2,
                      textAlign: textAlign ?? TextAlign.end,
                      cursorHeight: 2,
                      cursorRadius: Radius.circular(1),
                      controller: controller,
                      cursorColor: Colors.black,
                      autofocus: false,
                      decoration: InputDecoration(
                        fillColor: Theme.of(context).primaryColor,
                        filled: false,
                        hintStyle: textStyle ??
                            titleSmall(context).copyWith(
                              color: Color.fromARGB(191, 158, 158, 158),
                            ),
                        hintText: hint,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).backgroundColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
