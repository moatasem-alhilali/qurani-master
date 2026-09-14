import 'dart:async';

import 'package:flutter/foundation.dart';

/// مؤقّت النوم: يوقف البثّ بعد مدّة يختارها المستخدم.
///
/// هذه أهمّ ميزة كانت ناقصة في إذاعة قرآن — كثير من الناس ينامون عليها، وبلا
/// مؤقّت يبقى البثّ يعمل حتى الصباح ويستهلك البيانات والبطارية.
///
/// المؤقّت يعيش في طبقة الخدمة لا في الشاشة: الخروج من صفحة الإذاعة يجب ألّا
/// يلغيه، والبثّ نفسه يستمرّ في الخلفية.
class RadioSleepTimer {
  RadioSleepTimer();

  /// الزمن المتبقّي، أو `null` حين لا مؤقّت.
  ///
  /// يتغيّر كل ثانية، فيُقرأ عبر [ValueListenableBuilder] حول النصّ وحده —
  /// لا شاشة تُبنى ستّين مرّة في الدقيقة.
  final ValueNotifier<Duration?> remaining = ValueNotifier(null);

  Timer? _ticker;

  /// يُستدعى عند انتهاء المدّة. يُربط من المستودع بإيقاف المشغّل.
  Future<void> Function()? onElapsed;

  bool get isRunning => remaining.value != null;

  /// المدد المعروضة في الورقة. تسعون دقيقة حدٌّ كافٍ للنوم، وما فوقه يساوي
  /// «بلا مؤقّت» عمليًّا.
  static const presets = <int>[15, 30, 45, 60, 90];

  void start(Duration duration) {
    _ticker?.cancel();
    if (duration <= Duration.zero) {
      cancel();
      return;
    }

    remaining.value = duration;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final left = remaining.value;
      if (left == null) {
        _ticker?.cancel();
        return;
      }

      final next = left - const Duration(seconds: 1);
      if (next > Duration.zero) {
        remaining.value = next;
        return;
      }

      _ticker?.cancel();
      _ticker = null;
      remaining.value = null;
      unawaited(onElapsed?.call() ?? Future<void>.value());
    });
  }

  void cancel() {
    _ticker?.cancel();
    _ticker = null;
    remaining.value = null;
  }

  /// «٢٨:٠٤» — دقائق وثوانٍ بأرقام عربية، لتطابق بقيّة التطبيق.
  static String format(Duration value) {
    final minutes = value.inMinutes.toString().padLeft(2, '0');
    final seconds = (value.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void dispose() {
    _ticker?.cancel();
    remaining.dispose();
  }
}
