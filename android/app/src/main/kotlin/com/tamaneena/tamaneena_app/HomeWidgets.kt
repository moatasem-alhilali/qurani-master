package com.tamaneena.tamaneena_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Build
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

private object TamaneenaWidgetBinder {
    fun bindPrayer(context: Context, widgetData: SharedPreferences): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_prayer_large)
        views.setTextViewText(R.id.widget_title, read(widgetData, "prayer_label", "الصلاة القادمة"))
        views.setTextViewText(R.id.widget_primary, read(widgetData, "prayer_name", "الفجر"))
        views.setTextViewText(R.id.widget_time, read(widgetData, "prayer_time", "04:18 ص"))
        views.setTextViewText(R.id.widget_caption, read(widgetData, "prayer_remaining", "قريبًا"))
        views.setTextViewText(R.id.widget_footer, read(widgetData, "widget_updated_at", "طمأنينة"))
        views.setOnClickPendingIntent(R.id.widget_root, launchIntent(context, "tamaneena://widgets/prayer"))
        return views
    }

    fun bindDhikr(context: Context, widgetData: SharedPreferences): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_text_large)
        views.setTextViewText(R.id.widget_title, read(widgetData, "dhikr_title", "ذكر اليوم"))
        views.setTextViewText(R.id.widget_body, read(widgetData, "dhikr_text", "لا إله إلا الله وحده لا شريك له"))
        views.setTextViewText(R.id.widget_footer, read(widgetData, "dhikr_source", "أذكار طمأنينة"))
        views.setOnClickPendingIntent(R.id.widget_root, launchIntent(context, "tamaneena://widgets/dhikr"))
        return views
    }

    fun bindAyah(context: Context, widgetData: SharedPreferences): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_text_large)
        views.setTextViewText(R.id.widget_title, read(widgetData, "ayah_title", "آية اليوم"))
        views.setTextViewText(R.id.widget_body, read(widgetData, "ayah_text", "﴿أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ﴾"))
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
