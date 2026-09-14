import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:quran_app/core/cash/cache_service.dart';

/// محطّات المستخدم المفضّلة.
///
/// الصفحة كانت تحفظ محطةً واحدة فقط (`radio_last_station_id`)، فمن يستمع
/// لثلاثة قرّاء بالتناوب يبحث عنهم في القائمة كل مرّة.
///
/// الحالة في [ValueNotifier] لا في الـ bloc عن قصد: تبديل المفضّلة يجب أن
/// يعيد بناء القلب وحده، لا الشاشة ولا المؤشّر ولا الأربعة والعشرين صفًّا.
class RadioFavouritesStore {
  RadioFavouritesStore(this._cache);

  static const _key = 'radio_favourite_ids';

  final CacheService _cache;

  final ValueNotifier<Set<int>> favourites = ValueNotifier(const {});

  bool _hydrated = false;

  void hydrate() {
    if (_hydrated) return;
    _hydrated = true;

    final raw = _cache.getString(_key);
    if (raw == null || raw.isEmpty) return;

    final ids = raw
        .split(',')
        .map((part) => int.tryParse(part.trim()))
        .whereType<int>()
        .toSet();
    if (ids.isNotEmpty) favourites.value = ids;
  }

  bool isFavourite(int id) => favourites.value.contains(id);

  /// تُرجع الحالة بعد التبديل، فيعرف المُنادي أيّ رسالة يعرض.
  bool toggle(int id) {
    final next = Set<int>.of(favourites.value);
    final added = next.add(id);
    if (!added) next.remove(id);

    favourites.value = next;
    // الكتابة على القرص لا تُنتظر: الواجهة تحدّثت بالفعل، وتأخير القلب
    // خلف كتابة SharedPreferences يجعل اللمسة تبدو ثقيلة.
    unawaited(_cache.setString(_key, next.join(',')));
    return added;
  }

  void dispose() => favourites.dispose();
}
