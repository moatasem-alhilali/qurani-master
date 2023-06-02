import 'package:flutter/material.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/shared/resources/size_config.dart';

class MyTextFormField extends StatelessWidget {
  MyTextFormField({
    super.key,
    required this.hintText,
    this.labelText,
    this.textAlign = TextAlign.start,
    this.keyboardType,
    this.suffixIcon,
    this.height,
    required this.obscureText,
    this.onHasFocus,
    this.width,
    this.onObscureText,
    this.onChanged,
    this.bottomMargin,
    required this.controller,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
  });
  String? hintText;
  double? height;
  double? width;
  String? labelText;
  TextAlign? textAlign;
  Widget? suffixIcon;
  TextInputType? keyboardType;
  final bool obscureText;
  double? bottomMargin;
  final TextEditingController controller;

  final Function(bool isObscure)? onHasFocus;

  final Function(bool isObscure)? onObscureText;

  final Function(String text)? onChanged;
  void Function(String)? onFieldSubmitted;
  void Function(String?)? onSaved;
  void Function()? onEditingComplete;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.only(
        bottom: SizeConfig.blockSizeVertical! * bottomMargin!,
      ),
      height: SizeConfig.blockSizeVertical! * height!,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ColorsManager.customMainThird,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        maxLines: null,
        controller: controller,
        style: const TextStyle(color: Colors.white),
        textInputAction: TextInputAction.next,
        keyboardType: keyboardType,
        onFieldSubmitted: onFieldSubmitted,
        onSaved: onSaved,
        onEditingComplete: onEditingComplete,
        textDirection: TextDirection.rtl,
        textAlign: textAlign!,
        decoration: InputDecoration(
          hintText: hintText!,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontFamily: "ios-1",
            fontSize: 16,
          ),
          helperStyle: Theme.of(context).textTheme.headlineSmall,
          suffixIcon: IconButton(
            icon: suffixIcon!,
            onPressed: () {},
          ),
          filled: true,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          labelStyle: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: Colors.grey),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
