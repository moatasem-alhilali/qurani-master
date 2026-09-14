import 'dart:math' as math;

/// المسافة والاتجاه من موضع المسافر إلى الكعبة.
///
/// حسابٌ خالص بلا شبكة ولا حسّاسات: الإحداثيات موجودة أصلًا في
/// `PrayerLocationSelection`، فالبطاقة تظهر كاملةً في أوّل إطار.
///
/// وهذا يختلف عن بوصلة القبلة في التطبيق: تلك تقرأ مغناطيس الجهاز لتدلّك
/// على الاتجاه **وأنت واقف**، وهذه تخبرك كم بينك وبين مكّة وأين هي منك على
/// الخريطة — وهو ما يهمّ المسافر لا المصلّي.
class MakkahGeo {
  const MakkahGeo._({
    required this.distanceKm,
    required this.bearingDegrees,
  });

  /// إحداثيات الكعبة المشرّفة.
  static const double kaabaLatitude = 21.4225;
  static const double kaabaLongitude = 39.8262;

  /// نصف قطر الأرض المتوسّط بالكيلومترات.
  static const double _earthRadiusKm = 6371.0088;

  factory MakkahGeo.from({
    required double latitude,
    required double longitude,
  }) {
    final lat1 = _toRadians(latitude);
    final lat2 = _toRadians(kaabaLatitude);
    final dLat = lat2 - lat1;
    final dLon = _toRadians(kaabaLongitude - longitude);

    // هافرساين: الأرض كرة لا مستوٍ، والفرق على آلاف الكيلومترات كبير.
    final a = math.pow(math.sin(dLat / 2), 2) +
        math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(dLon / 2), 2);
    final distance = 2 * _earthRadiusKm * math.asin(math.sqrt(a.clamp(0, 1)));

    // الاتجاه الابتدائي للدائرة العظمى — وهو اتجاه القبلة نفسه.
    final y = math.sin(dLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
    final bearing = (_toDegrees(math.atan2(y, x)) + 360) % 360;

    return MakkahGeo._(distanceKm: distance, bearingDegrees: bearing);
  }

  final double distanceKm;

  /// من الشمال باتجاه عقارب الساعة، من ٠ إلى ٣٦٠.
  final double bearingDegrees;

  /// أنت في مكّة أو حولها مباشرة.
  bool get isAtDestination => distanceKm < 5;

  /// «٢٬٣١٤ كم» — بفاصل الآلاف العربي.
  String get distanceLabel {
    final rounded = distanceKm.round();
    final digits = rounded.toString();
    final buffer = StringBuffer();

    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('٬');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  /// جهة الاتجاه بالعربية — أوضح للقارئ من رقم الدرجات وحده.
  String get directionLabel {
    const names = [
      'شمالًا',
      'شمال شرق',
      'شرقًا',
      'جنوب شرق',
      'جنوبًا',
      'جنوب غرب',
      'غربًا',
      'شمال غرب',
    ];
    // ثماني جهات، فكل جهة تغطّي ٤٥°، والإزاحة نصفها حتى تتمركز على اسمها.
    final index = (((bearingDegrees + 22.5) % 360) ~/ 45).clamp(0, 7);
    return names[index];
  }

  static double _toRadians(double degrees) => degrees * math.pi / 180;
  static double _toDegrees(double radians) => radians * 180 / math.pi;
}
