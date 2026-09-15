package com.tamaneena.tamaneena_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.Color
import android.os.Build
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * الويدجتات الإضافية: المسبحة، القبلة، التاريخ الهجري، متابعة القراءة،
 * تتبّع الصلوات، والاختصارات.
 *
 * فُصلت عن [HomeWidgets] لأن أكثرها لا يقرأ بيانات الصلاة، وخلطها في ملف
 * واحد كان يجعل كل تعديل يمسّ كل شيء.
 */
private object ExtraWidgetBinder {

    private const val PALETTE_ON_SURFACE = "widget_on_surface_hex"
    private const val PALETTE_MUTED = "widget_muted_hex"

    // ----------------------------- المسبحة -----------------------------

    /**
     * العدّاد يعيش في تفضيلات الويدجت نفسها لا في التطبيق.
     *
     * السبب أن الضغط يقع والتطبيق مغلق: لو كان المصدر قاعدة بيانات التطبيق
     * لاحتاجت كل تسبيحة إيقاظ محرّك Flutter كاملًا — عشرات الأجزاء من الثانية
     * تأخّرًا على ضغطة يُفترض أن تكون فورية.
     */
    const val KEY_TASBIH_COUNT = "widget_tasbih_count"

    fun bindTasbih(context: Context, widgetData: SharedPreferences): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_tasbih)
        val onSurface = color(widgetData, PALETTE_ON_SURFACE, Color.rgb(255, 247, 225))
        val muted = color(widgetData, PALETTE_MUTED, Color.rgb(212, 184, 115))

        val count = widgetData.getInt(KEY_TASBIH_COUNT, 0)

        views.setTextColor(R.id.widget_title, muted)
        views.setTextColor(R.id.widget_reset, muted)
        views.setTextColor(R.id.widget_count, onSurface)
        views.setTextColor(R.id.widget_body, onSurface)

        views.setTextViewText(R.id.widget_title, read(widgetData, "tasbih_title", "المسبحة"))
        views.setTextViewText(R.id.widget_body, read(widgetData, "tasbih_text", "سبحان الله وبحمده"))
        views.setTextViewText(R.id.widget_count, count.toString())

        // عشر خرزات تدور مع كل عشر تسبيحات، فيبقى التقدّم مرئيًّا مهما كبر
        // العدد بدل شريط يمتلئ مرّة ثم يتجمّد.
        val filled = if (count == 0) 0 else ((count - 1) % 10) + 1
        beadIds.forEachIndexed { index, id ->
            views.setImageViewResource(
                id,
                if (index < filled) R.drawable.widget_bead_active else R.drawable.widget_bead_idle,
            )
        }

        views.setOnClickPendingIntent(
            R.id.widget_count,
            broadcast(context, TasbihWidgetActions.ACTION_COUNT),
        )
        views.setOnClickPendingIntent(
            R.id.widget_reset,
            broadcast(context, TasbihWidgetActions.ACTION_RESET),
        )
        // بقيّة المساحة تفتح المسبحة الكاملة داخل التطبيق.
        views.setOnClickPendingIntent(
            R.id.widget_root,
            launchIntent(context, "tamaneena://widgets/tasbih"),
        )
        return views
    }

    private val beadIds = intArrayOf(
        R.id.widget_bead_1, R.id.widget_bead_2, R.id.widget_bead_3, R.id.widget_bead_4,
        R.id.widget_bead_5, R.id.widget_bead_6, R.id.widget_bead_7, R.id.widget_bead_8,
        R.id.widget_bead_9, R.id.widget_bead_10,
    )

    // ------------------------ قوالب «رقم وسطر» ------------------------

    fun bindQibla(context: Context, widgetData: SharedPreferences): RemoteViews = bindStat(
        context = context,
        widgetData = widgetData,
        title = read(widgetData, "qibla_title", "القبلة"),
        primary = read(widgetData, "qibla_direction", "—"),
        caption = read(widgetData, "qibla_distance", "حدّد موقعك في المواقيت"),
        footer = read(widgetData, "prayer_city", "طمأنينة"),
        deepLink = "tamaneena://widgets/qibla",
    )

    fun bindHijri(context: Context, widgetData: SharedPreferences): RemoteViews = bindStat(
        context = context,
        widgetData = widgetData,
        title = read(widgetData, "hijri_title", "التاريخ الهجري"),
        primary = read(widgetData, "hijri_date", "—"),
        caption = read(widgetData, "hijri_gregorian", ""),
        footer = read(widgetData, "hijri_weekday", "طمأنينة"),
        deepLink = "tamaneena://widgets/hijri",
    )

    fun bindReading(context: Context, widgetData: SharedPreferences): RemoteViews = bindStat(
        context = context,
        widgetData = widgetData,
        title = read(widgetData, "reading_title", "متابعة القراءة"),
        primary = read(widgetData, "reading_surah", "لم تبدأ بعد"),
        caption = read(widgetData, "reading_position", "افتح المصحف لتبدأ"),
        footer = read(widgetData, "widget_updated_at", "طمأنينة"),
        deepLink = "tamaneena://widgets/reading",
    )

    private fun bindStat(
        context: Context,
        widgetData: SharedPreferences,
        title: String,
        primary: String,
        caption: String,
        footer: String,
        deepLink: String,
    ): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_stat)
        val onSurface = color(widgetData, PALETTE_ON_SURFACE, Color.rgb(255, 247, 225))
        val muted = color(widgetData, PALETTE_MUTED, Color.rgb(212, 184, 115))

        views.setTextColor(R.id.widget_title, muted)
        views.setTextColor(R.id.widget_primary, onSurface)
        views.setTextColor(R.id.widget_caption, muted)
        views.setTextColor(R.id.widget_footer, muted)

        views.setTextViewText(R.id.widget_title, title)
        views.setTextViewText(R.id.widget_primary, primary)
        views.setTextViewText(R.id.widget_caption, caption)
        views.setTextViewText(R.id.widget_footer, footer)
        views.setOnClickPendingIntent(R.id.widget_root, launchIntent(context, deepLink))
        return views
    }

    // -------------------------- تتبّع الصلوات --------------------------

    fun bindTracker(context: Context, widgetData: SharedPreferences): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_tracker)
        val onSurface = color(widgetData, PALETTE_ON_SURFACE, Color.rgb(255, 247, 225))
        val muted = color(widgetData, PALETTE_MUTED, Color.rgb(212, 184, 115))

        views.setTextColor(R.id.widget_title, muted)
        views.setTextColor(R.id.widget_primary, onSurface)
        views.setTextColor(R.id.widget_caption, muted)

        // خمسة أحرف: «1» صُلّيت و«0» لا. أبسط من JSON لخمس قيم ثنائية، ولا
        // يحتاج محلّلًا يمكن أن يفشل على شاشة البدء.
        val flags = read(widgetData, "tracker_flags", "00000")
        var done = 0
        dotIds.forEachIndexed { index, id ->
            val isDone = flags.getOrNull(index) == '1'
            if (isDone) done++
            views.setImageViewResource(
                id,
                if (isDone) R.drawable.widget_bead_active else R.drawable.widget_bead_idle,
            )
        }
        labelIds.forEach { views.setTextColor(it, muted) }

        views.setTextViewText(R.id.widget_primary, "$done / 5")
        views.setTextViewText(
            R.id.widget_caption,
            if (done >= 5) "أتممت صلوات اليوم" else read(widgetData, "tracker_caption", "افتح التطبيق لتعليم ما صلّيت"),
        )
        views.setOnClickPendingIntent(
            R.id.widget_root,
            launchIntent(context, "tamaneena://widgets/tracker"),
        )
        return views
    }

    private val dotIds = intArrayOf(
        R.id.widget_dot_1, R.id.widget_dot_2, R.id.widget_dot_3,
        R.id.widget_dot_4, R.id.widget_dot_5,
    )

    private val labelIds = intArrayOf(
        R.id.widget_label_1, R.id.widget_label_2, R.id.widget_label_3,
        R.id.widget_label_4, R.id.widget_label_5,
    )

    // --------------------------- الاختصارات ---------------------------

    fun bindShortcuts(context: Context, widgetData: SharedPreferences): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_shortcuts)
        val onSurface = color(widgetData, PALETTE_ON_SURFACE, Color.rgb(255, 247, 225))

        val targets = listOf(
            Triple(R.id.widget_action_1, R.id.widget_label_1, "tamaneena://widgets/quran" to "القرآن"),
            Triple(R.id.widget_action_2, R.id.widget_label_2, "tamaneena://widgets/dhikr" to "الأذكار"),
            Triple(R.id.widget_action_3, R.id.widget_label_3, "tamaneena://widgets/tasbih" to "المسبحة"),
            Triple(R.id.widget_action_4, R.id.widget_label_4, "tamaneena://widgets/qibla" to "القبلة"),
        )

        targets.forEach { (containerId, labelId, target) ->
            val (uri, label) = target
            views.setTextColor(labelId, onSurface)
            views.setTextViewText(labelId, label)
            views.setOnClickPendingIntent(containerId, launchIntent(context, uri))
        }
        return views
    }

    // ----------------------------- أدوات -----------------------------

    private fun read(widgetData: SharedPreferences, key: String, fallback: String): String =
        widgetData.getString(key, fallback)?.takeIf { it.isNotBlank() } ?: fallback

    private fun color(widgetData: SharedPreferences, key: String, fallback: Int): Int = try {
        Color.parseColor(read(widgetData, key, ""))
    } catch (_: IllegalArgumentException) {
        fallback
    }

    private fun pendingFlags(): Int = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    } else {
        PendingIntent.FLAG_UPDATE_CURRENT
    }

    private fun launchIntent(context: Context, uri: String): PendingIntent {
        val intent = Intent(context, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = android.net.Uri.parse(uri)
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        return PendingIntent.getActivity(context, uri.hashCode(), intent, pendingFlags())
    }

    private fun broadcast(context: Context, action: String): PendingIntent {
        val intent = Intent(context, HomeTasbihWidgetProvider::class.java).apply {
            this.action = action
        }
        return PendingIntent.getBroadcast(context, action.hashCode(), intent, pendingFlags())
    }
}

object TasbihWidgetActions {
    const val ACTION_COUNT = "com.tamaneena.tamaneena_app.widget.TASBIH_COUNT"
    const val ACTION_RESET = "com.tamaneena.tamaneena_app.widget.TASBIH_RESET"
}

/**
 * المسبحة — الويدجت الوحيد الذي يعمل دون فتح التطبيق.
 *
 * يعترض بثّه الخاصّ في [onReceive]، يعدّل العدّاد في التفضيلات، ثم يعيد رسم
 * كل نسخة مثبّتة منه. لا `startActivity` ولا محرّك Flutter في المسار، فالرقم
 * يتغيّر في الإطار التالي للضغطة.
 */
class HomeTasbihWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach {
            appWidgetManager.updateAppWidget(it, ExtraWidgetBinder.bindTasbih(context, widgetData))
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            TasbihWidgetActions.ACTION_COUNT -> mutate(context) { it + 1 }
            TasbihWidgetActions.ACTION_RESET -> mutate(context) { 0 }
            else -> super.onReceive(context, intent)
        }
    }

    private fun mutate(context: Context, transform: (Int) -> Int) {
        val prefs = context.getSharedPreferences(WIDGET_PREFS, Context.MODE_PRIVATE)
        val next = transform(prefs.getInt(ExtraWidgetBinder.KEY_TASBIH_COUNT, 0)).coerceAtLeast(0)
        prefs.edit().putInt(ExtraWidgetBinder.KEY_TASBIH_COUNT, next).apply()

        val manager = AppWidgetManager.getInstance(context)
        val ids = manager.getAppWidgetIds(
            ComponentName(context, HomeTasbihWidgetProvider::class.java),
        )
        ids.forEach {
            manager.updateAppWidget(it, ExtraWidgetBinder.bindTasbih(context, prefs))
        }
    }

    private companion object {
        /** اسم ملفّ التفضيلات الذي تكتب فيه حزمة `home_widget`. */
        const val WIDGET_PREFS = "HomeWidgetPreferences"
    }
}

class HomeQiblaWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { appWidgetManager.updateAppWidget(it, ExtraWidgetBinder.bindQibla(context, widgetData)) }
    }
}

class HomeHijriWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { appWidgetManager.updateAppWidget(it, ExtraWidgetBinder.bindHijri(context, widgetData)) }
    }
}

class HomeReadingWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { appWidgetManager.updateAppWidget(it, ExtraWidgetBinder.bindReading(context, widgetData)) }
    }
}

class HomeTrackerWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { appWidgetManager.updateAppWidget(it, ExtraWidgetBinder.bindTracker(context, widgetData)) }
    }
}

class HomeShortcutsWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { appWidgetManager.updateAppWidget(it, ExtraWidgetBinder.bindShortcuts(context, widgetData)) }
    }
}
