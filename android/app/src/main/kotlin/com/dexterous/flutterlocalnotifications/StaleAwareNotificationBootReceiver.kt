// هذا الملف في حزمة flutter_local_notifications عمدًا لا في حزمة التطبيق:
// الدوالّ التي يحتاجها (rescheduleNotifications و scheduleNextNotification
// و buildGson) مرئية على مستوى الحزمة فقط. إن غيّرتها الإضافة في ترقية قادمة
// فسيفشل البناء صراحةً بدل أن يعود السلوك القديم بصمت.
package com.dexterous.flutterlocalnotifications

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import com.dexterous.flutterlocalnotifications.models.NotificationDetails
import com.google.gson.reflect.TypeToken
import java.time.LocalDateTime
import java.time.ZoneId
import java.time.ZonedDateTime

/**
 * بديل [ScheduledNotificationBootReceiver] يتخطّى المواعيد الفائتة بدل إطلاقها.
 *
 * ## المشكلة
 *
 * أندرويد يمسح كل المنبّهات عند إطفاء الجهاز. فتعيدها الإضافة عند الإقلاع من
 * نسختها المحفوظة، في `rescheduleNotifications` ← `zonedScheduleNotification`،
 * بالموعد المحفوظ **كما هو**: لا تتحقّق أهو في الماضي، ولا تنقله للموعد التالي.
 * و`AlarmManager` يُطلق فورًا أيّ منبّه موعده مضى.
 *
 * فمن أطفأ جواله وقت الفجر وشغّله الثامنة صباحًا يستقبل «حان وقت الفجر» الآن،
 * ومعه كل أذان وتذكير يومي فات أثناء الإطفاء — دفعةً واحدة. والشيء نفسه بعد
 * كل تحديث للتطبيق (`MY_PACKAGE_REPLACED`) إن كانت منبّهاته قد مُسحت.
 *
 * ## الحل
 *
 * قبل إعادة الجدولة، لكل إشعار موعده المحفوظ أقدم من [GRACE_MILLIS]:
 * نناديه بـ `scheduleNextNotification` — الدالّة نفسها التي تناديها الإضافة
 * *بعد* عرض الإشعار. فينتقل المتكرّر (الأذان اليومي) إلى موعده القادم، ويُحذف
 * غير المتكرّر، **دون عرض شيء**. ثم تُعاد جدولة الباقي كالمعتاد.
 *
 * الإشعارات المتكرّرة بفاصل زمني (كل دقيقة/ساعة) تُترك: الإضافة تنقلها أصلًا
 * إلى المستقبل في `calculateNextNotificationTrigger`.
 */
// لا حاجة لـ @Keep: المستقبِل مُعلَن في المانيفست، و R8 يُبقي ما يُشار إليه منه.
class StaleAwareNotificationBootReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        if (action !in HANDLED_ACTIONS) return

        // أيّ خطأ في التخطّي لا يمنع إعادة الجدولة: الأسوأ أن يعود السلوك القديم،
        // لا أن تضيع الإشعارات القادمة كلّها.
        try {
            skipMissedOccurrences(context)
        } catch (error: Exception) {
            Log.w(TAG, "Could not skip missed notifications; rescheduling as-is", error)
        }

        FlutterLocalNotificationsPlugin.rescheduleNotifications(context)
    }

    private fun skipMissedOccurrences(context: Context) {
        val preferences = context.getSharedPreferences(CACHE_NAME, Context.MODE_PRIVATE)
        val json = preferences.getString(CACHE_NAME, null) ?: return

        val type = object : TypeToken<ArrayList<NotificationDetails>>() {}.type
        val scheduled: List<NotificationDetails> =
            FlutterLocalNotificationsPlugin.buildGson().fromJson(json, type) ?: return

        val cutoff = System.currentTimeMillis() - GRACE_MILLIS
        var skipped = 0

        for (details in scheduled) {
            if (details.repeatInterval != null || details.repeatIntervalMilliseconds != null) {
                continue
            }
            val zone = details.timeZoneName ?: continue
            val dateTime = details.scheduledDateTime ?: continue

            val dueAt = ZonedDateTime.of(LocalDateTime.parse(dateTime), ZoneId.of(zone))
                .toInstant()
                .toEpochMilli()

            if (dueAt < cutoff) {
                // يعيد القراءة من التخزين ويكتب إليه في كل نداء، فتتراكم التعديلات
                // على بعضها رغم أنّنا نمشي على لقطة قديمة من القائمة.
                FlutterLocalNotificationsPlugin.scheduleNextNotification(context, details)
                skipped++
            }
        }

        if (skipped > 0) {
            Log.i(TAG, "Skipped $skipped notification(s) missed while the device was off")
        }
    }

    private companion object {
        const val TAG = "StaleAwareBootReceiver"

        /** اسم ملف التخزين ومفتاحه معًا في الإضافة (FlutterLocalNotificationsPlugin:138). */
        const val CACHE_NAME = "scheduled_notifications"

        /**
         * مهلة التأخّر المقبولة. أذان تأخّر دقيقتين لأن الجهاز أُعيد تشغيله
         * لحظة الصلاة ما زال مفيدًا؛ أمّا ما تأخّر أكثر فتذكير منتهٍ.
         */
        const val GRACE_MILLIS = 5L * 60L * 1000L

        val HANDLED_ACTIONS = setOf(
            Intent.ACTION_BOOT_COMPLETED,
            Intent.ACTION_MY_PACKAGE_REPLACED,
            "android.intent.action.QUICKBOOT_POWERON",
            "com.htc.intent.action.QUICKBOOT_POWERON",
        )
    }
}
