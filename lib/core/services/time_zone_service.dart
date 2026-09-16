import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimeZoneService {
  factory TimeZoneService() {
    return _instance;
  }

  TimeZoneService._internal();
  static final TimeZoneService _instance = TimeZoneService._internal();

  /// يضبط `tz.local` على منطقة الجهاز الزمنية.
  ///
  /// كل الإشعارات اليومية تُبنى بـ `TZDateTime(tz.local, …, hour, minute)`،
  /// فمنطقة خاطئة هنا تُزيح **كل** أذان وتذكير بفرق التوقيت على المنصّتين.
  Future<void> setupTimezone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(await resolveDeviceLocation());
  }

  /// منطقة الجهاز الزمنية، دون السقوط الصامت إلى UTC.
  ///
  /// كان المسار عند الفشل يترك `tz.local` على UTC — صراحةً في
  /// `configureLocalTimeZone`، وضمنيًا هنا لأن `main` يبتلع الخطأ فتبقى القيمة
  /// الافتراضية للحزمة وهي UTC. والنتيجة في الرياض: أذان العشاء المجدول 19:38
  /// يُفهم 19:38 UTC فيصل 22:38.
  ///
  /// والفشل وارد: بعض الأجهزة تُرجع اسمًا لا تعرفه قاعدة `timezone` (اسم
  /// مهجور أو صيغة مثل «GMT+03:00»)، فيرمي `getLocation`.
  ///
  /// الترتيب:
  /// 1. الاسم الذي يُرجعه الجهاز، إن عرفته القاعدة.
  /// 2. أيّ منطقة فرقها **الآن** يساوي فرق ساعة الجهاز — والإشعارات تحتاج
  ///    الفرق لا الاسم، فهذا يعطي الأوقات الصحيحة.
  /// 3. UTC، فقط إن لم تُحمَّل القاعدة أصلًا.
  Future<tz.Location> resolveDeviceLocation() async {
    try {
      final name = await FlutterTimezone.getLocalTimezone();
      return tz.getLocation(name);
    } catch (error) {
      debugPrint(
        'TimeZoneService: device zone lookup failed ($error); '
        'matching by UTC offset instead',
      );
    }

    final now = DateTime.now();
    final deviceOffsetMillis = now.timeZoneOffset.inMilliseconds;
    final nowMillis = now.millisecondsSinceEpoch;

    for (final location in tz.timeZoneDatabase.locations.values) {
      if (location.timeZone(nowMillis).offset == deviceOffsetMillis) {
        return location;
      }
    }

    debugPrint(
      'TimeZoneService: no zone matches offset ${now.timeZoneOffset}; '
      'falling back to UTC',
    );
    return tz.UTC;
  }
}
