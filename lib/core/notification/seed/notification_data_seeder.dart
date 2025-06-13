class TimeNotificationDataModel {
  final int hour;
  final int minute;
  final String title;
  final String body;
  final String sound;
  final int id;

  const TimeNotificationDataModel({
    required this.hour,
    required this.minute,
    required this.title,
    required this.body,
    required this.sound,
    required this.id,
  });
}

class RandomThikrNotification {
  final String title;
  final String body;
  final String channelId;
  final String channelName;
  final int id;

  const RandomThikrNotification({
    required this.title,
    required this.body,
    required this.channelId,
    required this.channelName,
    required this.id,
  });
}

/// ✅ Singleton + Seeder
class NotificationDataSeeder {
  static final NotificationDataSeeder _instance =
      NotificationDataSeeder._internal();
  factory NotificationDataSeeder() => _instance;
  NotificationDataSeeder._internal();

  //
  TimeNotificationDataModel get middleNight => TimeNotificationDataModel(
        id: 101,
        hour: _h('22:00'),
        minute: _m('22:00'),
        title: 'اشعارات النوافل',
        body: 'حان وقت الصلاة قيام اليل! قم وناجى الرحمن',
        sound: 'middlenight',
      );

  TimeNotificationDataModel get thikrMorning => TimeNotificationDataModel(
        id: 102,
        hour: _h('7:00'),
        minute: _m('7:00'),
        title: 'حان الوقت',
        body: 'حان موعد اذكار الصباح',
        sound: 'morning',
      );

  TimeNotificationDataModel get thikrNight => TimeNotificationDataModel(
        id: 103,
        hour: _h('18:00'),
        minute: _m('18:00'),
        title: 'حان الوقت',
        body: 'حان موعد اذكار المساء',
        sound: 'night',
      );

  TimeNotificationDataModel get readQuran => TimeNotificationDataModel(
        id: 104,
        hour: _h('7:00'),
        minute: _m('7:00'),
        title: 'الورد القرآن',
        body: 'لاتنسى قراءة القرآن',
        sound: '',
      );

  TimeNotificationDataModel get readSurahMulk => TimeNotificationDataModel(
        id: 105,
        hour: _h('7:00'),
        minute: _m('7:00'),
        title: 'قراة سورة الملك',
        body: 'لا تنسى قراءة سورة الملك',
        sound: '',
      );

  TimeNotificationDataModel get thikrSleep => TimeNotificationDataModel(
        id: 106,
        hour: _h('20:00'),
        minute: _m('20:00'),
        title: 'أذكار النوم',
        body: '',
        sound: '',
      );

  TimeNotificationDataModel get thikrGetup => TimeNotificationDataModel(
        id: 107,
        hour: _h('7:30'),
        minute: _m('7:30'),
        title: 'اذكار الاستيقاض',
        body: 'لا تنسى أذكار الاستيقاض',
        sound: '',
      );

  // 🟢 إشعارات الذكر العشوائي
  List<RandomThikrNotification> getRandomThikrNotifications() {
    return const [
      RandomThikrNotification(
        id: 108,
        channelId: 'astgfer_allh_id',
        channelName: 'astgfer allh name',
        title: "استغفر الله",
        body:
            "استغفار الله يُذهب الهم والحزن وضيق الصدر ويدخل الفرح والسرور إلى القلب الناتج عن القرب من الله",
      ),
      RandomThikrNotification(
        id: 109,
        channelId: 'hasbna_allh id',
        channelName: 'hasbna allh name',
        title: "حسبنا الله ونعم الوكيل",
        body: "أفضل الأدعية المستحبة عند الله سبحانه وتعالى وله أثر عظيم",
      ),
      RandomThikrNotification(
        id: 1010,
        channelId: 'lahawla_wlaquoah_id',
        channelName: 'lahawla wlaquoah name',
        title: "لا حول ولا قوة الا بالله العلي العظيم",
        body: "كنز من كنوز الجنة",
      ),
      RandomThikrNotification(
        id: 1011,
        channelId: 'subhan_allh_id',
        channelName: 'subhan allh name',
        title: "سبحان الله والحمدلله ولا اله الا الله والله اكبر",
        body:
            "من قال حين يصبح وحين يمسي سبحان الله وبحمده مئة مرةٍ غفرت خطاياه وإن كانت مثل زبد البحر ",
      ),
    ];
  }

  // 🧩 Helpers
  int _h(String time) => int.tryParse(time.split(":")[0]) ?? 0;
  int _m(String time) => int.tryParse(time.split(":")[1]) ?? 0;
}
