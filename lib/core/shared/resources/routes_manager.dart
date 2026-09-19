import 'package:flutter/material.dart';
import 'package:quran_app/l10n/l10n.dart';
import 'package:quran_app/main.dart';
import 'package:quran_app/main_view.dart';

class RoutesManager {
  static const String main = "/";
  static const String screenDetail = "/screenDetail";
}

class RouterGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesManager.main:
        return MaterialPageRoute(builder: (_) => MyApp(), settings: settings);
      // case RoutesManager.screenDetail:
      //   return MaterialPageRoute(builder: (_) => ScreenDetail());

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.cleanupRouteNotFound),
        ),
        body: Center(
          child: Text(context.l10n.cleanupRouteNotFound),
        ),
      ),
    );
  }
}
