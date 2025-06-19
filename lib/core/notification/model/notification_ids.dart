// This class provides centralized static notification IDs for all types of app notifications.
// It prevents accidental duplication and makes it easy to manage notification identifiers from a single place.

class NotificationIds {
  // Midnight prayer notification ID
  static const int middleNight = 101;

  // Morning Azkar notification ID
  static const int thikrMorning = 102;

  // Night Azkar notification ID
  static const int thikrNight = 103;

  // Daily Quran reading notification ID
  static const int readQuran = 104;

  // Surah Mulk reading notification ID
  static const int readSurahMulk = 105;

  // Sleep Azkar notification ID
  static const int thikrSleep = 106;

  // Wake-up Azkar notification ID
  static const int thikrGetup = 107;

  // Prayer Athan notification IDs (these match the order in your PrayerInfoModel list)
  static const int athanFajr = 200; // Fajr Athan
  static const int athanSunrise = 201; // Sunrise Athan
  static const int athanDhuhr = 202; // Dhuhr Athan
  static const int athanAsr = 203; // Asr Athan
  static const int athanMaghrib = 204; // Maghrib Athan
  static const int athanIsha = 205; // Isha Athan

  // "Send Salawat on the Prophet" notification ID (recurring every hour in the day)
  // Usage: NotificationIds.mohammedPrayer(hour) -> 3001 = 1AM, 3023 = 11PM
  static int mohammedPrayer(int hour) => 3000 + hour;

  // Random Thikr notifications (used for repeated or user-scheduled Thikr)
  // Each scheduled random Thikr can use an index to avoid conflicts
  static int randomThikr(int index) => 4000 + index;

  // User-scheduled Thikr notifications, each gets its unique ID based on a user-controlled scheduleId
  static int userScheduledThikr(int scheduleId) => 5000 + scheduleId;

  // You can add more generators here for custom notifications as needed
}
