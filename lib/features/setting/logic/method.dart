import 'package:quran_app/core/services/tasks_notification.dart';
import 'package:quran_app/core/shared/export/export-shared.dart';
import 'package:quran_app/core/util/toast_manager.dart';
// import 'package:url_launcher/url_launcher.dart';

class MethodSetting {
  static void unLockNoitification(newValue) {
    ISNOT_NOTIFY = newValue;
    if (ISNOT_NOTIFY) {
      CashHelper.setData(key: 'ISNOTIFY', value: ISNOT_NOTIFY);
      ServicesNotification.cancelAllNotification();
      ToastServes.showToast(message: "تم ايقاف تنبيه الاشعارات");

      //
      ToastServes.showToast(
          message: "ملاحضة لن يتم تنبيهك بأي اشعار من بعد الان");
    } else {
      ToastServes.showToast(
        message: "سوف يتم تنبيهك بالاشعارات من بعد الان",
      );
      ServicesNotification.showScheduledNotificationMohummed();
      CashHelper.setData(key: 'ISNOTIFY', value: ISNOT_NOTIFY);
    }
  }

  static Future<void> lunchToInstagram() async {
    // if (ISCONNECTED) {
    //   if (!await launchUrl(
    //       Uri.parse('https://instagram.com/am.vi3?igshid=YmMyMTA2M2Y='))) {
    //     throw Exception('Could not launch !');
    //   }
    // } else {
    //   ToastServes.showToast(message: "لايوجد لديك انترنت");
    // }
  }

  static void lunchToFacebook() async {
  //   if (ISCONNECTED) {
  //     if (!await launchUrl(
  //         Uri.parse('https://www.facebook.com/am.iv4?mibextid=ZbWKwL'))) {
  //       throw Exception('Could not launch !');
  //     }
  //   } else {
  //     ToastServes.showToast(message: "لايوجد لديك انترنت");
  //   }
  // }
}
}