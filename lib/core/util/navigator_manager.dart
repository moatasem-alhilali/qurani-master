import 'package:flutter/material.dart';

/// اسم الشاشة كما يظهر في Firebase Analytics.
///
/// `FirebaseAnalyticsObserver` لا يسجّل إلا المسارات التي تحمل اسمًا، ومسارات
/// التطبيق كانت كلّها بلا أسماء — فلم تكن أيّ شاشة ستُسجَّل. نسمّيها باسم صنف
/// الشاشة («PrayerTimeScreen»).
///
/// تنبيه: أسماء الأصناف تبقى مقروءة في بناء release **ما لم** يُستعمل
/// `--obfuscate`؛ إن استُعمل صارت الأسماء مشفّرة في لوحة التحليلات.
///
/// [name] يُمرَّر حين تكون [page] غلافًا لا الشاشة نفسها — مثل
/// `BlocProvider.value(child: …)`، فاسم صنفه «BlocProvider<…>» لا يدلّ على شيء،
/// والغلاف يحفظ ابنه في حقل خاص لا يمكن قراءته.
RouteSettings screenRouteSettings(Widget page, {String? name}) =>
    RouteSettings(name: name ?? page.runtimeType.toString());

//navigate To With Animation

void fadeNavigation({
  required BuildContext context,
  required Widget page,
  String? screenName,
}) {
  Navigator.push(
    context,
    PageRouteBuilder(
      settings: screenRouteSettings(page, name: screenName),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: child,
        );
      },
    ),
  );
}

void fadeNavigationWithRemove({
  required BuildContext context,
  required Widget page,
  String? screenName,
}) {
  Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      settings: screenRouteSettings(page, name: screenName),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: child,
        );
      },
    ),
    (route) => false,
  );
}

void navigateToWithAnimation3({
  required BuildContext context,
  required Widget page,
  String? screenName,
}) {
  Navigator.push(
    context,
    PageRouteBuilder(
      settings: screenRouteSettings(page, name: screenName),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            ),
          ),
          child: child,
        );
      },
    ),
  );
}
