import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextFormField extends StatefulWidget {
  MyTextFormField({
    super.key,
    this.hintText,
    this.labelText,
    this.textAlign = TextAlign.start,
    this.keyboardType,
    this.suffixIcon,
    this.height,
    this.onChanged,
    this.readOnly,
    this.controller,
    this.messageValidate,
    this.validator,
    this.prefixIcon,
    this.maxLines,
    this.focusNode,
    this.obscureText = false,
    this.errorText,
    this.successText,
    this.statusText = false,
    this.onTap,
    this.onEditingComplete,
    this.outlineFocusedBorderColor,
    this.inputFormatters,
    this.hintStyle,
    //formatter
    this.numberFormatter = false,
    this.noSpaceFormatter = false,
    this.oneWordArabicFormatter = false,
    this.arabicFormatter = false,
    this.threeWordArabicFormatter = false,
    this.denyArabicFormatter = false,
    this.englishFormatter = false,
    this.oneLengthNumberFormatter = false,
    this.emailFormatter = false,
    this.phoneFormatter = false,
    this.numberWithEnglishFormatter = false,
    this.numberCountFormatter = false,
    this.numberCountIntFormatter = 1,
    this.onFieldSubmitted,
    this.style,
  });
  String? hintText;
  String? Function(String?)? validator;
  String? labelText;
  String? messageValidate;
  double? height;
  TextEditingController? controller;
  TextAlign? textAlign;
  Widget? suffixIcon;
  Widget? prefixIcon;
  bool? readOnly;
  int? maxLines;
  bool obscureText;
  TextInputType? keyboardType;
  FocusNode? focusNode;
  Color? outlineFocusedBorderColor;
  final Function(String text)? onChanged;
  String? errorText;
  String? successText;
  final bool statusText;
  List<TextInputFormatter>? inputFormatters;
  final bool noSpaceFormatter;
  final bool numberFormatter;
  final bool denyArabicFormatter;
  final bool oneWordArabicFormatter;
  final bool arabicFormatter;
  final bool threeWordArabicFormatter;
  final bool englishFormatter;
  final bool oneLengthNumberFormatter;
  final bool phoneFormatter;
  final bool emailFormatter;
  final bool numberWithEnglishFormatter;
  final bool numberCountFormatter;
  final int numberCountIntFormatter;
  Function()? onEditingComplete;
  final void Function()? onTap;
  final TextStyle? hintStyle;
  TextStyle? style;
  void Function(String)? onFieldSubmitted;
  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  @override
  void initState() {
    try {
      widget.controller?.selection = TextSelection.fromPosition(
          TextPosition(offset: widget.controller!.text.length));
    } catch (e) {
      // logger.e('error selection controller $e  ');
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
      child: TextFormField(
        inputFormatters: [
          if (widget.numberFormatter)
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          if (widget.oneLengthNumberFormatter)
            LengthLimitingTextInputFormatter(1),
          if (widget.numberCountFormatter)
            LengthLimitingTextInputFormatter(widget.numberCountIntFormatter),
          if (widget.noSpaceFormatter) NoSpaceFormatter(),
          if (widget.arabicFormatter)
            FilteringTextInputFormatter.allow(RegExp(r'[\u0600-\u06FF\s]')),
          if (widget.englishFormatter)
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
          if (widget.phoneFormatter)
            FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
          if (widget.numberWithEnglishFormatter)
            FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z]')),
          if (widget.emailFormatter)
            FilteringTextInputFormatter.allow(
                RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')),
          if (widget.threeWordArabicFormatter) _ThreeWordsInputFormatter(),
          if (widget.oneWordArabicFormatter) _OneWordsInputFormatter(),
          if (widget.denyArabicFormatter)
            FilteringTextInputFormatter.deny(RegExp(r'[\u0600-\u06FF]+')),
        ],
        // style: titleMedium(context)
        //     .copyWith(fontSize: 16, color: Colors.black),
        readOnly: widget.readOnly ?? false,
        validator: widget.validator ??
            (value) {
              if (value!.isEmpty) {
                return widget.messageValidate ?? 'هذا الحقل مطلوب';
              }
              return null;
            },

        onFieldSubmitted: widget.onFieldSubmitted,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        textAlign: widget.textAlign!,
        maxLines: widget.maxLines,

        obscureText: widget.obscureText,
        onEditingComplete: widget.onEditingComplete,
        onSaved: (newValue) {
          FocusScope.of(context).unfocus();
        },
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
          if (widget.onEditingComplete != null) {
            widget.onEditingComplete!();
          }
        },
        onTap: widget.onTap,
        style: widget.style,
        decoration: InputDecoration(
          errorText: widget.statusText ? widget.successText : widget.errorText,
          suffixIconColor: Theme.of(context).primaryColorLight,
          prefixIconColor: Theme.of(context).primaryColorLight,
          labelText: widget.labelText ?? widget.hintText,
          labelStyle: widget.hintStyle,
          hintText: widget.hintText,
          helperStyle: Theme.of(context).textTheme.headlineSmall,
          suffixIcon: widget.suffixIcon,
          prefixIcon: widget.prefixIcon,
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: widget.statusText ? Colors.green : Colors.red,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: widget.statusText ? Colors.green : Colors.red,
            ),
          ),
          errorStyle: TextStyle(
            color: widget.statusText ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            // fontFamily: AssetsArFonts.medium,
          ),
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}

class NoSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.replaceAll(' ', ''),
      selection: newValue.selection,
    );
  }
}

class _ThreeWordsInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String trimmedText = newValue.text.replaceAll(RegExp(r'\s+'), ' ');
    List<String> words = trimmedText.split(' ');

    if (words.length > 3) {
      // Remove extra words
      words = words.sublist(0, 3);
      trimmedText = words.join(' ');
    }

    // Keep the selection at the end of the text
    int selectionIndex = newValue.selection.end;
    int newSelectionIndex =
        selectionIndex - (newValue.text.length - trimmedText.length);

    return TextEditingValue(
      text: trimmedText,
      selection: TextSelection.collapsed(offset: newSelectionIndex),
    );
  }
}

class _OneWordsInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String trimmedText = newValue.text.replaceAll(RegExp(r'\s+'), ' ');
    List<String> words = trimmedText.split(' ');

    if (words.length > 1) {
      // Remove extra words
      words = words.sublist(0, 1);
      trimmedText = words.join(' ');
    }

    // Keep the selection at the end of the text
    int selectionIndex = newValue.selection.end;
    int newSelectionIndex =
        selectionIndex - (newValue.text.length - trimmedText.length);

    return TextEditingValue(
      text: trimmedText,
      selection: TextSelection.collapsed(offset: newSelectionIndex),
    );
  }
}

//------------------------------------------------phone number------------------------------

// class IntlPhoneFieldCustom extends StatelessWidget {
//   const IntlPhoneFieldCustom({
//     super.key,
//     this.controller,
//     this.onChanged,
//     this.onSubmitted,
//     this.errorText,
//   });
//   final TextEditingController? controller;
//   final void Function(PhoneNumber phone)? onChanged;
//   final void Function(String)? onSubmitted;
//   final String? errorText;
//   @override
//   Widget build(BuildContext context) {
//     return IntlPhoneField(
//       keyboardType: TextInputType.phone,
//       showCountryFlag: true,
//       controller: controller,
//       inputFormatters: [
//         FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
//         NoSpaceFormatter(),
//       ],
//       dropdownDecoration: const BoxDecoration(
//         color: Colors.transparent,
//       ),
//       textAlign: TextAlign.right,
//       pickerDialogStyle: PickerDialogStyle(
//         backgroundColor: Colors.white,
//       ),
//       decoration: InputDecoration(
//         errorText: errorText,
//         labelText: 'Phone'.tr(context),
//         border: const OutlineInputBorder(
//           borderSide: BorderSide(width: 1),
//         ),
//       ),
//       initialCountryCode: 'YE',
//       onTap: () {
//         print('object');
//       },
//       onChanged: onChanged,
//       onSubmitted: onSubmitted,
//     );
//   }
// }
