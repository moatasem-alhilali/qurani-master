package com.tamaneena.tamaneena_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Build
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray

/**
 * ودجات الصلاة والذكر والآية والورد.
 *
 * **لا ألوان هنا.** كان كل ربط يقرأ `widget_on_surface_hex` و`widget_muted_hex`
 * من تفضيلات الويدجت ويكتبهما فوق كل نصّ — وDart يحفظ فيهما قيمتين داكنتين
 * ثابتتين مهما كان الثيم. النتيجة أن الودجات ظلّت بنّية داكنة أبدًا، وملفّات
 * `values-night` لا تُسأل أصلًا.
 *
 * الآن اللون مسؤولية الموارد وحدها: `values/widget_tokens.xml` للفاتح
 * و`values-night/` للداكن، ويحلّه أندرويد لكل ودجت بلا وسيط. ما يبقى للكوتلن
 * هو الحالة لا المظهر: أيّ صلاة هي القادمة، وكم خرزة امتلأت.
 */
private object TamaneenaWidgetBinder {

    fun bindPrayer(context: Context, widgetData: SharedPreferences): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_prayer_large)
        val nextPrayer = resolveNextPrayer(widgetData)

        views.setTextViewText(R.id.widget_title, read(widgetData, "prayer_label", "الصلاة القادمة"))
        views.setTextViewText(R.id.widget_primary, nextPrayer?.name ?: read(widgetData, "prayer_name", "الفجر"))
        views.setTextViewText(R.id.widget_time, nextPrayer?.time ?: read(widgetData, "prayer_time", "04:18 ص"))
        views.setTextViewText(R.id.widget_caption, nextPrayer?.remaining ?: read(widgetData, "prayer_remaining", "قريبًا"))
        views.setTextViewText(R.id.widget_footer, read(widgetData, "widget_updated_at", "طمأنينة"))
        views.setOnClickPendingIntent(R.id.widget_root, launchIntent(context, "tamaneena://widgets/prayer"))
        return views
    }

    fun bindPrayerTimes(context: Context, widgetData: SharedPreferences): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_prayer_times_large)

        views.setTextViewText(R.id.widget_title, "مواقيت الصلاة")
        views.setTextViewText(R.id.widget_city, read(widgetData, "prayer_city", "طمأنينة"))
        views.setTextViewText(R.id.widget_fajr_time, read(widgetData, "prayer_fajr_time", "--:--"))
        views.setTextViewText(R.id.widget_sunrise_time, read(widgetData, "prayer_sunrise_time", "--:--"))
        views.setTextViewText(R.id.widget_dhuhr_time, read(widgetData, "prayer_dhuhr_time", "--:--"))
        views.setTextViewText(R.id.widget_asr_time, read(widgetData, "prayer_asr_time", "--:--"))
        views.setTextViewText(R.id.widget_maghrib_time, read(widgetData, "prayer_maghrib_time", "--:--"))
        views.setTextViewText(R.id.widget_isha_time, read(widgetData, "prayer_isha_time", "--:--"))
        views.setTextViewText(R.id.widget_footer, read(widgetData, "widget_updated_at", "طمأنينة"))

        highlightNextCell(context, views, resolveNextPrayer(widgetData)?.name)

        views.setOnClickPendingIntent(R.id.widget_root, launchIntent(context, "tamaneena://widgets/prayer"))
        return views
    }

    /**
     * يُلبس خليّة الصلاة القادمة الذهبيَّ.
     *
     * ستّ خلايا متطابقة كانت تترك السؤال الوحيد الذي يُفتح الودجت لأجله بلا
     * جواب: أيّها التالي؟ الإبراز حالة لا ثيم، فلذلك يُضبط هنا لا في الموارد.
     */
    private fun highlightNextCell(context: Context, views: RemoteViews, prayerName: String?) {
        val cell = when (prayerName?.trim()) {
            "الفجر" -> Triple(R.id.widget_cell_fajr, R.id.widget_fajr_label, R.id.widget_fajr_time)
            "الشروق" -> Triple(R.id.widget_cell_sunrise, R.id.widget_sunrise_label, R.id.widget_sunrise_time)
            "الظهر" -> Triple(R.id.widget_cell_dhuhr, R.id.widget_dhuhr_label, R.id.widget_dhuhr_time)
            "العصر" -> Triple(R.id.widget_cell_asr, R.id.widget_asr_label, R.id.widget_asr_time)
            "المغرب" -> Triple(R.id.widget_cell_maghrib, R.id.widget_maghrib_label, R.id.widget_maghrib_time)
            "العشاء" -> Triple(R.id.widget_cell_isha, R.id.widget_isha_label, R.id.widget_isha_time)
            else -> return
        }

        val onAccent = context.getColor(R.color.widget_on_accent)
        views.setInt(cell.first, "setBackgroundResource", R.drawable.widget_cell_next)
        views.setTextColor(cell.second, onAccent)
        views.setTextColor(cell.third, onAccent)
    }

    fun bindDhikr(context: Context, widgetData: SharedPreferences): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_text_large)
        views.setTextViewText(R.id.widget_title, read(widgetData, "dhikr_title", "ذكر اليوم"))
        views.setTextViewText(R.id.widget_body, compact(read(widgetData, "dhikr_text", "لا إله إلا الله وحده لا شريك له")))
        views.setTextViewText(R.id.widget_footer, read(widgetData, "dhikr_source", "أذكار طمأنينة"))
        views.setOnClickPendingIntent(R.id.widget_root, launchIntent(context, "tamaneena://widgets/dhikr"))
        return views
    }

    fun bindAyah(context: Context, widgetData: SharedPreferences): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_text_large)
        views.setTextViewText(R.id.widget_title, read(widgetData, "ayah_title", "آية عشوائية"))
        views.setTextViewText(R.id.widget_body, compact(read(widgetData, "ayah_text", "﴿أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ﴾")))
        views.setTextViewText(R.id.widget_footer, read(widgetData, "ayah_source", "الرعد: 28"))
        views.setOnClickPendingIntent(R.id.widget_root, launchIntent(context, "tamaneena://widgets/ayah"))
        return views
    }

    fun bindWird(context: Context, widgetData: SharedPreferences): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_wird_large)
        views.setTextViewText(R.id.widget_title, read(widgetData, "wird_title", "ورد اليوم"))
        views.setTextViewText(R.id.widget_primary, read(widgetData, "wird_progress", "0%"))
        views.setTextViewText(R.id.widget_caption, read(widgetData, "wird_summary", "ابدأ وردك الآن"))
        views.setTextViewText(R.id.widget_footer, read(widgetData, "widget_updated_at", "طمأنينة"))
        views.setOnClickPendingIntent(R.id.widget_root, launchIntent(context, "tamaneena://widgets/wird"))
        return views
    }

    private fun read(widgetData: SharedPreferences, key: String, fallback: String): String {
        return widgetData.getString(key, fallback)?.takeIf { it.isNotBlank() } ?: fallback
    }

    private fun compact(text: String): String {
        return if (text.length <= 120) text else text.take(117).trimEnd() + "…"
    }

    private fun resolveNextPrayer(widgetData: SharedPreferences): PrayerScheduleItem? {
        val now = System.currentTimeMillis()
        val next = readSchedule(widgetData)
            .filter { it.isPrayer && it.epochMillis > now }
            .minByOrNull { it.epochMillis }
        return next?.withRemaining(formatRemaining(next.epochMillis - now))
    }

    private fun readSchedule(widgetData: SharedPreferences): List<PrayerScheduleItem> {
        val raw = read(widgetData, "prayer_schedule_json", "[]")
        return try {
            val array = JSONArray(raw)
            buildList {
                for (index in 0 until array.length()) {
                    val item = array.getJSONObject(index)
                    add(
                        PrayerScheduleItem(
                            name = item.optString("name"),
                            time = item.optString("time"),
                            epochMillis = item.optLong("epochMillis"),
                            isPrayer = item.optBoolean("isPrayer", true),
                        )
                    )
                }
            }
        } catch (_: Exception) {
            emptyList()
        }
    }

    private fun formatRemaining(diffMillis: Long): String {
        if (diffMillis <= 0L) return "الآن"
        val totalMinutes = (diffMillis / 60000L).coerceAtLeast(0L)
        val hours = totalMinutes / 60L
        val minutes = totalMinutes % 60L
        return if (hours <= 0L) "بعد $minutes د" else "بعد $hours س $minutes د"
    }

    private fun launchIntent(context: Context, uri: String): PendingIntent {
        val intent = Intent(context, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = android.net.Uri.parse(uri)
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
        return PendingIntent.getActivity(context, uri.hashCode(), intent, flags)
    }

    private data class PrayerScheduleItem(
        val name: String,
        val time: String,
        val epochMillis: Long,
        val isPrayer: Boolean,
        val remaining: String = "",
    ) {
        fun withRemaining(value: String): PrayerScheduleItem = copy(remaining = value)
    }
}

class HomePrayerWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { appWidgetManager.updateAppWidget(it, TamaneenaWidgetBinder.bindPrayer(context, widgetData)) }
    }
}

class HomeDhikrWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { appWidgetManager.updateAppWidget(it, TamaneenaWidgetBinder.bindDhikr(context, widgetData)) }
    }
}

class HomeAyahWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { appWidgetManager.updateAppWidget(it, TamaneenaWidgetBinder.bindAyah(context, widgetData)) }
    }
}

class HomeWirdWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { appWidgetManager.updateAppWidget(it, TamaneenaWidgetBinder.bindWird(context, widgetData)) }
    }
}

class HomePrayerTimesWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { appWidgetManager.updateAppWidget(it, TamaneenaWidgetBinder.bindPrayerTimes(context, widgetData)) }
    }
}
