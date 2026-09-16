import 'dart:async';

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:quran_app/core/services/navigation_service.dart';
import 'package:quran_app/features/home_widgets/data/home_widget_ids.dart';
import 'package:quran_app/features/prayer_time/presentation/view/pages/prayer_time_screen.dart';

/// يفتح الشاشة المناسبة عند الضغط على ودجت.
///
/// روابط الودجات: `tamaneena://widget/<name>?homeWidget`
/// - `next-prayer` و`prayer-times` ← شاشة المواقيت.
/// - `daily-ayah` ← الرئيسية نفسها، وفيها آية اليوم؛ لا انتقال.
abstract final class HomeWidgetClickRouter {
  static StreamSubscription<Uri?>? _subscription;

  /// يُنادى مرّة بعد أوّل إطار، حين يكون الملاح جاهزًا.
  static void attach() {
    if (_subscription != null) return;

    // الإقلاع من ضغطة ودجت والتطبيق مغلق.
    unawaited(
      HomeWidget.initiallyLaunchedFromHomeWidget()
          .then(_open)
          .catchError((Object _) {}),
    );
    // الضغط والتطبيق يعمل في الخلفية.
    _subscription = HomeWidget.widgetClicked.listen(
      _open,
      onError: (Object _) {},
    );
  }

  static void _open(Uri? uri) {
    if (uri == null ||
        uri.scheme != HomeWidgetIds.linkScheme ||
        uri.host != HomeWidgetIds.linkHost) {
      return;
    }

    final navigator = NavigationService.navigatorKey.currentState;
    if (navigator == null) return;

    switch (uri.pathSegments.firstOrNull) {
      case 'next-prayer':
      case 'prayer-times':
        unawaited(
          navigator.push(
            MaterialPageRoute<void>(
              settings: const RouteSettings(name: 'PrayerTimeScreen'),
              builder: (_) => const PrayerTimeScreen(),
            ),
          ),
        );
    }
  }
}
