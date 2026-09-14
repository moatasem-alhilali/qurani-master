import 'package:flutter/material.dart';

/// خامات السبحة. تُرسم برمجيًا بتدرّجات لا بصور، فلا تزيد حجم التطبيق
/// ولا تحتاج نسخة لكل كثافة شاشة، وتبقى حادّة على أي مقاس.
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
            base: Color(0xFF6B4226),
            highlight: Color(0xFFB07A4E),
            shadow: Color(0xFF32190C),
            grain: TasbihBeadGrain.wood,
          ),
        TasbihBeadMaterial.oak => const TasbihBeadPalette(
            base: Color(0xFFC79A5B),
            highlight: Color(0xFFF0D9A8),
            shadow: Color(0xFF8A6329),
            grain: TasbihBeadGrain.wood,
          ),
        TasbihBeadMaterial.emerald => const TasbihBeadPalette(
            base: Color(0xFF1B7A55),
            highlight: Color(0xFF63D3A4),
            shadow: Color(0xFF0A3A27),
            grain: TasbihBeadGrain.stone,
          ),
        TasbihBeadMaterial.onyx => const TasbihBeadPalette(
            base: Color(0xFF2E3033),
            highlight: Color(0xFF787D83),
            shadow: Color(0xFF0B0C0D),
            grain: TasbihBeadGrain.stone,
          ),
        TasbihBeadMaterial.amber => const TasbihBeadPalette(
            base: Color(0xFFB9722A),
            highlight: Color(0xFFF2BE7A),
            shadow: Color(0xFF6E3D0E),
            grain: TasbihBeadGrain.wood,
          ),
        TasbihBeadMaterial.mahogany => const TasbihBeadPalette(
            base: Color(0xFF4E2A1E),
            highlight: Color(0xFF8E5540),
            shadow: Color(0xFF23110A),
            grain: TasbihBeadGrain.wood,
          ),
        TasbihBeadMaterial.sage => const TasbihBeadPalette(
            base: Color(0xFF6E7C63),
            highlight: Color(0xFFAFBCA2),
            shadow: Color(0xFF3B4436),
            grain: TasbihBeadGrain.stone,
          ),
        TasbihBeadMaterial.garnet => const TasbihBeadPalette(
            base: Color(0xFF8E2F2A),
            highlight: Color(0xFFD1706A),
            shadow: Color(0xFF4A1210),
            grain: TasbihBeadGrain.stone,
          ),
      };
}

/// نوع العروق داخل الخرزة: خشب بخطوط طولية، أو حجر بدوّامة ناعمة.
enum TasbihBeadGrain { wood, stone }

@immutable
class TasbihBeadPalette {
  const TasbihBeadPalette({
    required this.base,
    required this.highlight,
    required this.shadow,
    required this.grain,
  });

  final Color base;
  final Color highlight;
  final Color shadow;
  final TasbihBeadGrain grain;
}
