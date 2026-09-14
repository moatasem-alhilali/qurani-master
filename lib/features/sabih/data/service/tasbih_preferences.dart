import 'package:flutter/foundation.dart';
import 'package:quran_app/core/cash/cache_service.dart';
import 'package:quran_app/features/sabih/data/model/tasbih_bead_material.dart';

/// تفضيلات المسبحة: خامة السبحة، حجم الخط، الصوت، وهدف كل ذكر.
///
/// محفوظة في `SharedPreferences` عمدًا لا في قاعدة البيانات: جداول المسبحة
/// تُنشأ في `_onCreate` فقط ولا تُشملها `_onUpgrade`، فإضافة عمود «هدف»
/// كانت ستكسر التحديث على الأجهزة القائمة. وهذه تفضيلات عرض لا محتوى.
///
/// كل قيمة [ValueNotifier] فيُعاد بناء ما يعتمد عليها وحده عند تغيّرها.
class TasbihPreferences {
  TasbihPreferences._();

  static final TasbihPreferences instance = TasbihPreferences._();

  static const _materialKey = 'tasbih_bead_material';
  static const _fontScaleKey = 'tasbih_font_scale';
  static const _hapticsKey = 'tasbih_haptics_enabled';
  static const _targetPrefix = 'tasbih_target_';

  /// حدود حجم الخط — خارجها يخرج النصّ عن الشاشة أو يصير غير مقروء.
  static const minFontScale = 0.8;
  static const maxFontScale = 1.8;

  final ValueNotifier<TasbihBeadMaterial> material =
      ValueNotifier(TasbihBeadMaterial.walnut);

  final ValueNotifier<double> fontScale = ValueNotifier(1);

  final ValueNotifier<bool> hapticsEnabled = ValueNotifier(true);

  /// يتغيّر رقمه كلما تبدّل هدف أيّ ذكر، فتُعاد قراءة الأهداف.
  final ValueNotifier<int> targetsRevision = ValueNotifier(0);

  bool _loaded = false;

  void load() {
    if (_loaded) return;
    _loaded = true;

    final cache = CacheService();

    final storedMaterial = cache.getString(_materialKey);
    if (storedMaterial != null) {
      material.value = TasbihBeadMaterial.values.firstWhere(
        (value) => value.name == storedMaterial,
        orElse: () => TasbihBeadMaterial.walnut,
      );
    }

    final storedScale = cache.getDouble(_fontScaleKey);
    if (storedScale != null) {
      fontScale.value = storedScale.clamp(minFontScale, maxFontScale);
    }

    hapticsEnabled.value = cache.getBool(_hapticsKey) ?? true;
  }

  void setMaterial(TasbihBeadMaterial value) {
    if (material.value == value) return;
    material.value = value;
    CacheService().setString(_materialKey, value.name);
  }

  void setFontScale(double value) {
    final clamped = value.clamp(minFontScale, maxFontScale);
    if (fontScale.value == clamped) return;
    fontScale.value = clamped;
    CacheService().setDouble(_fontScaleKey, clamped);
  }

  void setHapticsEnabled({required bool value}) {
    if (hapticsEnabled.value == value) return;
    hapticsEnabled.value = value;
    CacheService().setBool(_hapticsKey, value);
  }

  /// هدف ذكر بعينه. غير المضبوط يرجع `null` فيتولّاه الهدف التلقائي
  /// المشتقّ من العدّ (٣٣ ← ٩٩ ← مضاعفات ١٠٠).
  int? customTargetFor(int subihId) {
    final value = CacheService().getInt('$_targetPrefix$subihId');
    return (value == null || value <= 0) ? null : value;
  }

  void setTargetFor(int subihId, int? target) {
    final key = '$_targetPrefix$subihId';
    if (target == null || target <= 0) {
      CacheService().remove(key);
    } else {
      CacheService().setInt(key, target);
    }
    targetsRevision.value++;
  }
}
