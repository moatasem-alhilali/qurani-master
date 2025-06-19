import 'package:quran_app/core/notification/channel/notification_channel.dart';
import 'package:quran_app/features/setting/data/constant/notification_keys.dart';

class NotificationConfig {
  const NotificationConfig({
    required this.key,
    required this.channel,
    required this.title,
    required this.body,
  });
  final String key;
  final NotificationChannel channel;
  final String title;
  final String body;
}

class NotificationConfigs {
  static const List<NotificationConfig> _all = [
    NotificationConfig(
      key: NotificationKeys.isNotificationAllAthan,
      channel: NotificationChannel.athan,
      title: 'إشعارات جميع الأذان',
      body: 'سيتكرر تنبيه جميع الأذان في أوقاتها المحددة.',
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationAthanFagr,
      channel: NotificationChannel.athan,
      title: 'أذان الفجر',
      body: 'حان الآن وقت أذان الفجر، بادر بالصلاة.',
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationAthanDuhr,
      channel: NotificationChannel.athan,
      title: 'أذان الظهر',
      body: 'حان الآن وقت أذان الظهر.',
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationAthanAsr,
      channel: NotificationChannel.athan,
      title: 'أذان العصر',
      body: 'حان الآن وقت أذان العصر.',
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationAthanMagrib,
      channel: NotificationChannel.athan,
      title: 'أذان المغرب',
      body: 'حان الآن وقت أذان المغرب.',
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationAthanIsha,
      channel: NotificationChannel.athan,
      title: 'أذان العشاء',
      body: 'حان الآن وقت أذان العشاء.',
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationMiddleNight,
      channel: NotificationChannel.middleNight,
      title: 'قيام الليل',
      body: 'حان وقت قيام الليل! قم وناجِ الرحمن.',
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationThikrMorning,
      channel: NotificationChannel.morning,
      title: 'أذكار الصباح',
      body: 'لا تنسَ أذكار الصباح!',
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationThikrNight,
      channel: NotificationChannel.night,
      title: 'أذكار المساء',
      body: 'لا تنسَ أذكار المساء!',
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationMohammed,
      channel: NotificationChannel.mohammed,
      title: 'الصلاة على محمد ﷺ',
      body: 'صَلِّ على النبي الكريم ﷺ، تُكتب لك عشرُ حسنات.',
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationRandomThikr,
      channel: NotificationChannel.randomThikr,
      title: 'مخصصة من أذكار عشوائية',
      body: 'اذكر الله يذكرك!',
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationReadQuran,
      channel: NotificationChannel.defaultChannel,
      title: 'الورد القرآني اليومي',
      body: 'لا تنسَ وردك من القرآن اليوم.',
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationReadSurahMulk,
      channel: NotificationChannel.defaultChannel,
      title: 'قراءة سورة الملك',
      body: 'اقرأ سورة الملك قبل النوم.',
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationWridSleep,
      channel: NotificationChannel.sleep,
      title: 'أذكار النوم',
      body: 'اقرأ أذكار النوم قبل أن تنام.',
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationWridGetup,
      channel: NotificationChannel.getUp,
      title: 'أذكار الاستيقاظ',
      body: 'ابدأ يومك بأذكار الاستيقاظ.',
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationReadSurah,
      channel: NotificationChannel.defaultChannel,
      title: 'قراءة سورة محددة',
      body: 'لا تنسَ قراءة السورة المحددة لهذا اليوم.',
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationReadSurahAlkahf,
      channel: NotificationChannel.defaultChannel,
      title: 'قراءة سورة الكهف',
      body: 'اقرأ سورة الكهف يوم الجمعة.',
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationFasting,
      channel: NotificationChannel.defaultChannel,
      title: 'تذكير بالصيام',
      body: 'صيام النوافل له أجر عظيم، لا تفوت الفرصة.',
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationFastingMonday,
      channel: NotificationChannel.defaultChannel,
      title: 'صيام الاثنين',
      body: 'تذكير بصيام يوم الاثنين.',
    ),
    NotificationConfig(
      key: NotificationKeys.isNotificationFastingThursday,
      channel: NotificationChannel.defaultChannel,
      title: 'صيام الخميس',
      body: 'تذكير بصيام يوم الخميس.',
    ),
    // يمكن إضافة المزيد هنا...
  ];

  static NotificationConfig of(String key) => _all.firstWhere(
        (c) => c.key == key,
        orElse: () => throw Exception('NotificationConfig not found for $key'),
      );

  // إذا احتجت كل الكونفيجات دفعة واحدة
  static List<NotificationConfig> get all => _all;
}
