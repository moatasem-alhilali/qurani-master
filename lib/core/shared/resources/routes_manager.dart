import 'package:flutter/material.dart';
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
        return MaterialPageRoute(builder: (_) => MyApp());
      // case RoutesManager.screenDetail:
      //   return MaterialPageRoute(builder: (_) => ScreenDetail());

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text('Not Found Route'),
        ),
        body: const Center(
          child: Text('Not Found Route'),
        ),
      ),
    );
  }
}
