import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quran_app/core/components/base_component_show.dart';
import 'package:quran_app/core/components/my_dialogs.dart';
import 'package:quran_app/core/util/my_loading.dart';
import 'package:quran_app/core/util/navigator_manager.dart';

//=================================Navigator===============================
extension MyNavigator on BuildContext {
  dynamic customOrientation(var n1, var n2) {
    Orientation orientation = MediaQuery.of(this).orientation;
    return orientation == Orientation.portrait ? n1 : n2;
  }

//show loading Dialog
  showLoading() {
    showMyDialogFunction(context: this, child: myLoading(), back: false);
  }

//show  Dialog
  showDialog({
    required Widget child,
    bool animate = true,
    bool back = false,
    double? height,
    double? width,
  }) {
    showMyDialogStyleFunction(
      context: this,
      child: child,
      back: back,
      animate: animate,
      height: height,
      width: width,
    );
  }

//show bottomsheet
  showBottomSheet({
    required Widget child,
    FutureOr<void> Function()? whenCompleted,
    bool isScroll = true,
    Color? backgroundColor,
  }) {
    showMyBottomSheetFunction(
      context: this,
      child: child,
      isScroll: isScroll,
      backgroundColor: backgroundColor,
      whenCompleted: whenCompleted,
    );
  }

//--------------------------Navigation---------------------------------
  void push(Widget page) {
    fadeNavigation(page: page, context: this);
  }

  void pop() => Navigator.pop(this);
  void hideDialog() => Navigator.of(this, rootNavigator: true).pop('dialog');
  void pushAndRemoveUntil(Widget page) {
    fadeNavigationWithRemove(page: page, context: this);
  }
  //--------------------------Navigation---------------------------------
}

//================================= double Helper===============================
extension SizeHelper on BuildContext {
  double getHight(int value) => (MediaQuery.of(this).size.height / 100) * value;
  double getWidth(int value) => (MediaQuery.of(this).size.width / 100) * value;
  double getScreenWidth() => MediaQuery.of(this).size.width;
  double getScreenHeight() => MediaQuery.of(this).size.height;
}

String convertNumbers(String inputStr) {
  Map<String, Map<String, String>> numberSets = {
    'العربية': {
      '0': '٠',
      '1': '١',
      '2': '٢',
      '3': '٣',
      '4': '٤',
      '5': '٥',
      '6': '٦',
      '7': '٧',
      '8': '٨',
      '9': '٩',
    },
    'English': {
      '0': '0',
      '1': '1',
      '2': '2',
      '3': '3',
      '4': '4',
      '5': '5',
      '6': '6',
      '7': '7',
      '8': '8',
      '9': '9',
    },
    'বাংলা': {
      '0': '০',
      '1': '১',
      '2': '২',
      '3': '৩',
      '4': '৪',
      '5': '৫',
      '6': '৬',
      '7': '৭',
      '8': '৮',
      '9': '৯',
    },
    'اردو': {
      '0': '۰',
      '1': '۱',
      '2': '۲',
      '3': '۳',
      '4': '۴',
      '5': '۵',
      '6': '۶',
      '7': '۷',
      '8': '۸',
      '9': '۹',
    },
  };

  return inputStr;
}
