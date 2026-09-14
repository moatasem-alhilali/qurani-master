import 'package:flutter/material.dart';

/// خامات السبحة. تُرسم برمجيًا بتدرّجات وعروق لا بصور، فلا تزيد حجم
/// التطبيق ولا تحتاج نسخة لكل كثافة شاشة، وتبقى حادّة على أي مقاس.
enum TasbihBeadMaterial {
  walnut('جوز'),
  oak('بلّوط'),
  emerald('زمرّد'),
  onyx('عقيق أسود'),
  amber('كهرمان'),
  mahogany('ماهوجني'),
  sage('زيتوني'),
  garnet('عقيق أحمر');

  const TasbihBeadMaterial(this.label);

  final String label;

  TasbihBeadPalette get palette => switch (this) {
        TasbihBeadMaterial.walnut => const TasbihBeadPalette(
            base: Color(0xFF6B4228),
            highlight: Color(0xFFA9714A),
            shadow: Color(0xFF2B1509),
            finish: TasbihBeadFinish.wood,
            gloss: 0.32,
            grainStrength: 0.9,
          ),
        TasbihBeadMaterial.oak => const TasbihBeadPalette(
            base: Color(0xFFD9B072),
            highlight: Color(0xFFF7E2B4),
            shadow: Color(0xFF9A7334),
            finish: TasbihBeadFinish.wood,
            gloss: 0.26,
            grainStrength: 1,
          ),
        TasbihBeadMaterial.emerald => const TasbihBeadPalette(
            base: Color(0xFF0E8A5F),
            highlight: Color(0xFF8CF0C8),
            shadow: Color(0xFF03301E),
            finish: TasbihBeadFinish.polished,
            gloss: 1,
            grainStrength: 0,
          ),
        TasbihBeadMaterial.onyx => const TasbihBeadPalette(
            base: Color(0xFF2A2C2F),
            highlight: Color(0xFFA6ADB5),
            shadow: Color(0xFF050607),
            finish: TasbihBeadFinish.polished,
            gloss: 1,
            grainStrength: 0,
          ),
        TasbihBeadMaterial.amber => const TasbihBeadPalette(
            base: Color(0xFFC98B45),
            highlight: Color(0xFFF3C88C),
            shadow: Color(0xFF7E4C1A),
            finish: TasbihBeadFinish.wood,
            gloss: 0.34,
            grainStrength: 0.85,
          ),
        TasbihBeadMaterial.mahogany => const TasbihBeadPalette(
            base: Color(0xFF7A4A2A),
            highlight: Color(0xFFBE8659),
            shadow: Color(0xFF31170A),
            finish: TasbihBeadFinish.wood,
            gloss: 0.4,
            grainStrength: 1,
          ),
        TasbihBeadMaterial.sage => const TasbihBeadPalette(
            base: Color(0xFF7C8A70),
            highlight: Color(0xFFBDC8B1),
            shadow: Color(0xFF3B4434),
            finish: TasbihBeadFinish.stone,
            gloss: 0.42,
            grainStrength: 0.5,
          ),
        TasbihBeadMaterial.garnet => const TasbihBeadPalette(
            base: Color(0xFF8E3B2C),
            highlight: Color(0xFFCF8271),
            shadow: Color(0xFF43140D),
            finish: TasbihBeadFinish.stone,
            gloss: 0.72,
            grainStrength: 0.45,
          ),
      };
}

/// كيف يعالج السطحُ الضوءَ والملمس.
///
/// الخشب عروق طولية مطفية، والحجر عروق سائلة نصف لامعة، والمصقول سطح
/// أملس ببريق حادّ وانعكاس بيئي — وهذا الفرق هو ما يجعل الخامات تُقرأ
/// مختلفة لا ملوّنة فقط.
enum TasbihBeadFinish { wood, stone, polished }

@immutable
class TasbihBeadPalette {
  const TasbihBeadPalette({
    required this.base,
    required this.highlight,
    required this.shadow,
    required this.finish,
    required this.gloss,
    required this.grainStrength,
  });

  final Color base;
  final Color highlight;
  final Color shadow;
  final TasbihBeadFinish finish;

  /// من ٠ (مطفي) إلى ١ (مصقول) — يتحكّم بحدّة البريق وقوّة الانعكاس.
  final double gloss;

  /// من ٠ (بلا عروق) إلى ١ (عروق واضحة).
  final double grainStrength;
}
