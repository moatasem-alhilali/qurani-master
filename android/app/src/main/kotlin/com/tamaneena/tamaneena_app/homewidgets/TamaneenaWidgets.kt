package com.tamaneena.tamaneena_app.homewidgets

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.SystemClock
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import com.tamaneena.tamaneena_app.MainActivity
import com.tamaneena.tamaneena_app.R
import es.antonborri.home_widget.HomeWidgetLaunchIntent

// ───────────────────────────── الأنواع ─────────────────────────────

/** الودجات الثلاث. أسماء الأصناف تطابق `HomeWidgetIds.android*` في Dart. */
enum class TamaneenaWidgetKind(val providerClass: Class<out AppWidgetProvider>) {
    NEXT_PRAYER(NextPrayerWidgetProvider::class.java),
    PRAYER_TIMES(PrayerTimesWidgetProvider::class.java),
    DAILY_AYAH(DailyAyahWidgetProvider::class.java);

    fun render(context: Context, payload: WidgetPayload?, now: Long): RemoteViews = when (this) {
        NEXT_PRAYER -> WidgetRenderer.nextPrayer(context, payload, now)
        PRAYER_TIMES -> WidgetRenderer.prayerTimes(context, payload, now)
        DAILY_AYAH -> WidgetRenderer.dailyAyah(context, payload, now)
    }
}

// ───────────────────────────── المزوّدات ─────────────────────────────

/**
 * أساس المزوّدات الثلاثة.
 *
 * `onUpdate` يصل من ثلاثة مصادر: إضافة الودجت، `updatePeriodMillis` (كل ساعة)،
 * و`HomeWidget.updateWidget` من Dart بعد كل مزامنة. في كلّها: ارسم ثم أعد جدولة
 * المنبّه التالي.
 */
abstract class TamaneenaWidgetProvider(private val kind: TamaneenaWidgetKind) : AppWidgetProvider() {

    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        TamaneenaWidgets.update(context, kind, ids)
        WidgetScheduler.scheduleNext(context)
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        manager: AppWidgetManager,
        id: Int,
        options: Bundle,
    ) {
        TamaneenaWidgets.update(context, kind, intArrayOf(id))
    }

    /** آخر ودجت من هذا النوع أُزيلت: المنبّه يُلغى إن لم يبقَ أيّ نوع. */
    override fun onDisabled(context: Context) {
        WidgetScheduler.scheduleNext(context)
    }
}

class NextPrayerWidgetProvider : TamaneenaWidgetProvider(TamaneenaWidgetKind.NEXT_PRAYER)

class PrayerTimesWidgetProvider : TamaneenaWidgetProvider(TamaneenaWidgetKind.PRAYER_TIMES)

class DailyAyahWidgetProvider : TamaneenaWidgetProvider(TamaneenaWidgetKind.DAILY_AYAH)

// ───────────────────────────── التحديث ─────────────────────────────

object TamaneenaWidgets {

    fun update(context: Context, kind: TamaneenaWidgetKind, ids: IntArray) {
        if (ids.isEmpty()) return
        val views = kind.render(context, WidgetPayload.load(context), System.currentTimeMillis())
        AppWidgetManager.getInstance(context).updateAppWidget(ids, views)
    }

    fun updateAll(context: Context) {
        val payload = WidgetPayload.load(context)
        val now = System.currentTimeMillis()
        val manager = AppWidgetManager.getInstance(context)
        for (kind in TamaneenaWidgetKind.entries) {
            val ids = idsOf(context, kind)
            if (ids.isNotEmpty()) manager.updateAppWidget(ids, kind.render(context, payload, now))
        }
        WidgetScheduler.scheduleNext(context)
    }

    fun hasAnyWidget(context: Context): Boolean =
        TamaneenaWidgetKind.entries.any { idsOf(context, it).isNotEmpty() }

    private fun idsOf(context: Context, kind: TamaneenaWidgetKind): IntArray =
        AppWidgetManager.getInstance(context)
            .getAppWidgetIds(ComponentName(context, kind.providerClass))
}

/**
 * يستقبل منبّه الحدود وأحداث النظام التي تجعل المعروض قديمًا.
 *
 * `DATE_CHANGED` غير مستعمل عمدًا: ليس ضمن البثّ الضمني المسموح لمستقبِلات
 * المانيفست منذ Android 8، فلا يصل. تبدّل اليوم يغطّيه منبّه منتصف الليل.
 */
class WidgetRefreshReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            WidgetScheduler.ACTION_TICK,
            Intent.ACTION_BOOT_COMPLETED,
            Intent.ACTION_MY_PACKAGE_REPLACED,
            Intent.ACTION_TIME_CHANGED,
            Intent.ACTION_TIMEZONE_CHANGED,
            Intent.ACTION_LOCALE_CHANGED -> TamaneenaWidgets.updateAll(context)
        }
    }
}

// ───────────────────────────── الجدولة ─────────────────────────────

/**
 * منبّه واحد عند أقرب حدّ: وقت صلاة أو منتصف ليل المدينة.
 *
 * - **غير موقِظ** (`RTC` لا `RTC_WAKEUP`): لا فائدة من إيقاظ الجهاز لرسم ودجت لا
 *   يراها أحد. إن كانت الشاشة مطفأة يُسلَّم المنبّه لحظة تشغيلها، فيرى المستخدم
 *   المحتوى الصحيح فورًا.
 * - **دقيق حين يُسمح**: Android 12+ يشترط إذن المنبّهات الدقيقة؛ بدونه نافذة
 *   دقيقة واحدة (قد يمدّها النظام). العدّ التنازلي لا يتأثّر — يعدّ بنفسه.
 */
object WidgetScheduler {
    const val ACTION_TICK = "com.tamaneena.tamaneena_app.homewidgets.ACTION_TICK"

    private const val REQUEST_CODE = 740_201
    private const val TAG = "TamaneenaWidgets"

    fun scheduleNext(context: Context) {
        val alarms = context.getSystemService(AlarmManager::class.java) ?: return
        val pending = PendingIntent.getBroadcast(
            context,
            REQUEST_CODE,
            Intent(context, WidgetRefreshReceiver::class.java).setAction(ACTION_TICK),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        alarms.cancel(pending)

        if (!TamaneenaWidgets.hasAnyWidget(context)) return
        val payload = WidgetPayload.load(context) ?: return

        // ثانية بعد الحدّ: عند اللحظة نفسها قد تُعدّ الصلاة «لم تحن بعد».
        val triggerAt = payload.nextBoundary(System.currentTimeMillis()) + 1_000L

        try {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S || alarms.canScheduleExactAlarms()) {
                alarms.setExact(AlarmManager.RTC, triggerAt, pending)
            } else {
                alarms.setWindow(AlarmManager.RTC, triggerAt, 60_000L, pending)
            }
        } catch (error: SecurityException) {
            // سُحب الإذن بين الفحص والطلب.
            Log.w(TAG, "Exact alarm denied; falling back to a window", error)
            alarms.setWindow(AlarmManager.RTC, triggerAt, 60_000L, pending)
        }
    }
}

// ───────────────────────────── الرسم ─────────────────────────────

object WidgetRenderer {

    private val cellIds = intArrayOf(
        R.id.tw_cell_0, R.id.tw_cell_1, R.id.tw_cell_2,
        R.id.tw_cell_3, R.id.tw_cell_4, R.id.tw_cell_5,
    )
    private val nameIds = intArrayOf(
        R.id.tw_name_0, R.id.tw_name_1, R.id.tw_name_2,
        R.id.tw_name_3, R.id.tw_name_4, R.id.tw_name_5,
    )
    private val timeIds = intArrayOf(
        R.id.tw_time_0, R.id.tw_time_1, R.id.tw_time_2,
        R.id.tw_time_3, R.id.tw_time_4, R.id.tw_time_5,
    )

    fun nextPrayer(context: Context, payload: WidgetPayload?, now: Long): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.tw_next_prayer)
        views.setOnClickPendingIntent(android.R.id.background, launch(context, "next-prayer"))
        applyDirection(views, payload)
        views.setTextViewText(
            R.id.tw_label,
            label(context, payload, "nextPrayer", R.string.tw_next_prayer_label),
        )

        val next = payload?.nextPrayer(now)
        if (next == null) {
            views.setTextViewText(R.id.tw_name, label(context, payload, "openApp", R.string.tw_open_app))
            views.setTextViewText(R.id.tw_time, emptyReason(context, payload))
            views.setViewVisibility(R.id.tw_countdown, View.GONE)
            views.setTextViewText(R.id.tw_location, payload?.location.orEmpty())
            return views
        }

        val (_, prayer) = next
        views.setTextViewText(R.id.tw_name, prayer.name)
        views.setTextViewText(R.id.tw_time, prayer.time)
        views.setTextViewText(R.id.tw_location, payload?.location.orEmpty())
        startCountdown(views, prayer.at, now)
        return views
    }

    fun prayerTimes(context: Context, payload: WidgetPayload?, now: Long): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.tw_prayer_times)
        views.setOnClickPendingIntent(android.R.id.background, launch(context, "prayer-times"))
        applyDirection(views, payload)

        val next = payload?.nextPrayer(now)
        if (next == null) {
            views.setTextViewText(R.id.tw_location, label(context, payload, "openApp", R.string.tw_open_app))
            views.setTextViewText(R.id.tw_date, emptyReason(context, payload))
            for (index in cellIds.indices) {
                views.setViewVisibility(cellIds[index], View.INVISIBLE)
            }
            views.setViewVisibility(R.id.tw_footer, View.GONE)
            return views
        }

        // اليوم المعروض هو يوم الصلاة القادمة: بعد العشاء يظهر جدول الغد.
        val (day, prayer) = next
        views.setTextViewText(R.id.tw_location, payload?.location.orEmpty())
        views.setTextViewText(R.id.tw_date, "${day.weekday} · ${day.hijri}")

        for (index in cellIds.indices) {
            val item = day.prayers.getOrNull(index)
            if (item == null) {
                views.setViewVisibility(cellIds[index], View.INVISIBLE)
                continue
            }
            views.setViewVisibility(cellIds[index], View.VISIBLE)
            views.setTextViewText(nameIds[index], item.name)
            views.setTextViewText(timeIds[index], item.time)
            views.setInt(
                cellIds[index],
                "setBackgroundResource",
                if (item.key == prayer.key && item.at == prayer.at) R.drawable.tw_cell_next else 0,
            )
        }

        views.setViewVisibility(R.id.tw_footer, View.VISIBLE)
        val nextIn = payload?.labels?.get("nextIn")?.takeIf { it.contains("{prayer}") }
            ?: "{prayer} بعد"
        views.setTextViewText(R.id.tw_next_label, nextIn.replace("{prayer}", prayer.name))
        startCountdown(views, prayer.at, now)
        return views
    }

    fun dailyAyah(context: Context, payload: WidgetPayload?, now: Long): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.tw_daily_ayah)
        views.setOnClickPendingIntent(android.R.id.background, launch(context, "daily-ayah"))
        // الآية عربية دائمًا فيبقى التخطيط من اليمين؛ العنوان وحده بلغة التطبيق.
        views.setTextViewText(
            R.id.tw_title,
            label(context, payload, "dailyAyah", R.string.tw_daily_ayah_label),
        )

        val verse = payload?.verseFor(now)
        views.setTextViewText(
            R.id.tw_text,
            verse?.text ?: context.getString(R.string.tw_ayah_fallback),
        )
        views.setTextViewText(
            R.id.tw_source,
            verse?.source ?: context.getString(R.string.tw_ayah_fallback_source),
        )
        return views
    }

    /**
     * `Chronometer` يعدّ تنازليًا داخل الشاشة الرئيسية نفسها، ثانية بثانية،
     * دون أيّ تحديث من التطبيق. قاعدته بزمن الإقلاع لا بساعة الجدار، فلا يتأثّر
     * بتغيير الساعة يدويًا (ولذلك نعيد الرسم عند `TIME_CHANGED`).
     */
    private fun startCountdown(views: RemoteViews, targetMillis: Long, now: Long) {
        val base = SystemClock.elapsedRealtime() + (targetMillis - now)
        views.setViewVisibility(R.id.tw_countdown, View.VISIBLE)
        views.setChronometerCountDown(R.id.tw_countdown, true)
        views.setChronometer(R.id.tw_countdown, base, null, true)
    }

    private fun emptyReason(context: Context, payload: WidgetPayload?): String =
        if (payload == null || payload.location == null) {
            label(context, payload, "setLocation", R.string.tw_set_location)
        } else {
            label(context, payload, "refreshNeeded", R.string.tw_refresh_needed)
        }

    private fun label(context: Context, payload: WidgetPayload?, key: String, fallback: Int): String =
        payload?.label(key, context.getString(fallback)) ?: context.getString(fallback)

    /**
     * اتّجاه لغة التطبيق لا لغة الجهاز: مستخدم يختار التركية على هاتف عربي يرى
     * الودجت من اليسار. `View.setLayoutDirection` معلَّم `@RemotableViewMethod`.
     */
    private fun applyDirection(views: RemoteViews, payload: WidgetPayload?) {
        views.setInt(
            android.R.id.background,
            "setLayoutDirection",
            if (payload?.rtl == false) View.LAYOUT_DIRECTION_LTR else View.LAYOUT_DIRECTION_RTL,
        )
    }

    /**
     * `homeWidget` في الرابط شرط home_widget على iOS؛ يُضاف هنا أيضًا ليبقى
     * شكل الرابط واحدًا على المنصّتين.
     */
    private fun launch(context: Context, path: String): PendingIntent =
        HomeWidgetLaunchIntent.getActivity(
            context,
            MainActivity::class.java,
            Uri.parse("tamaneena://widget/$path?homeWidget"),
        )
}
