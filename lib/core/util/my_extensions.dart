import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/components/base_component_show.dart';
import 'package:quran_app/core/extensions/theme_context_extension.dart';
import 'package:quran_app/core/util/navigator_manager.dart';

//=================================Navigator===============================
extension MyNavigator on BuildContext {
  dynamic customOrientation(var n1, var n2) {
    final orientation = MediaQuery.of(this).orientation;
    return orientation == Orientation.portrait ? n1 : n2;
  }

//show bottomsheet
  Future<void> showBottomSheet({
    required Widget child,
    FutureOr<void> Function()? whenCompleted,
    bool isScroll = true,
    Color? backgroundColor,
  }) async {
    await showMyBottomSheetFunction(
      context: this,
      child: child,
      isScroll: isScroll,
      backgroundColor: backgroundColor ?? background,
      whenCompleted: whenCompleted,
    );
  }

  Future<void> showBottomSheetUIHeader({
    required Widget child,
    FutureOr<void> Function()? whenCompleted,
    Color? backgroundColor,
    String? title,
    String? subtitle,
    IconData? iconHeader,
  }) async {
    await showModalBottomSheet<void>(
      context: this,
      backgroundColor: scaffoldBackgroundColor,
      isScrollControlled: true,
      elevation: 0,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      builder: (context) {
        return AnimatedPadding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        context.primaryScheme,
                        context.primaryScheme.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          iconHeader ?? Icons.add,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title ?? 'اضافه جديد',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              subtitle ?? 'قم بت خصيص المحتوي',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                child,
              ],
            ),
          ),
        );
      },
    ).whenComplete(whenCompleted ?? () {});
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

  // get full width
  double get fullWidth => MediaQuery.of(this).size.width;
  double get fullHeight => MediaQuery.of(this).size.height;
}

String convertNumbers(String inputStr) {
  final numberSets = <String, Map<String, String>>{
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
