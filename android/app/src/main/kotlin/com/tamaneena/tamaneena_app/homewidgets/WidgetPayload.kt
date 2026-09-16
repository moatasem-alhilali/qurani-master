package com.tamaneena.tamaneena_app.homewidgets

import android.content.Context
import android.util.Log
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray
import org.json.JSONObject
import java.time.LocalDate

data class WidgetPrayer(
    val key: String,
    val name: String,
    val at: Long,
    val time: String,
    val isPrayer: Boolean,
)

data class WidgetDay(
    val date: String,
    val weekday: String,
    val gregorian: String,
    val hijri: String,
    val prayers: List<WidgetPrayer>,
)

data class WidgetVerse(
    val date: String,
    val text: String,
    val source: String,
)

/**
 * بيانات الودجات كما يكتبها `HomeWidgetPayloadBuilder` في Dart.
 *
 * كل ما يلزم لاختيار المعروض **الآن** موجود هنا: مواقيت 30 يومًا بلحظات حقيقية
 * (`at` بالميلي ثانية)، فلا حاجة لتشغيل Flutter كي تنتقل الودجت إلى الصلاة
 * التالية أو إلى اليوم التالي.
 */
class WidgetPayload(
    val utcOffsetMinutes: Int,
    val location: String?,
    val days: List<WidgetDay>,
    val verses: List<WidgetVerse>,
) {
    private val offsetMillis: Long get() = utcOffsetMinutes * 60_000L

    /** أوّل صلاة لم يحن وقتها بعد (الشروق مستثنى)، مع يومها. */
    fun nextPrayer(nowMillis: Long): Pair<WidgetDay, WidgetPrayer>? {
        for (day in days) {
            for (prayer in day.prayers) {
                if (prayer.isPrayer && prayer.at > nowMillis) return day to prayer
            }
        }
        return null
    }

    /** تاريخ المدينة الآن بصيغة `yyyy-MM-dd` — نفس مفاتيح Dart. */
    fun dateKey(nowMillis: Long): String {
        val epochDay = Math.floorDiv(nowMillis + offsetMillis, DAY_MILLIS)
        return LocalDate.ofEpochDay(epochDay).toString()
    }

    fun verseFor(nowMillis: Long): WidgetVerse? {
        val key = dateKey(nowMillis)
        return verses.firstOrNull { it.date == key }
    }

    /**
     * أقرب لحظة يتغيّر فيها المعروض: أيّ وقت صلاة أو شروق، أو منتصف ليل المدينة
     * (تبدّل آية اليوم والتاريخ). عندها يوقظ `WidgetScheduler` الودجات.
     */
    fun nextBoundary(nowMillis: Long): Long {
        val prayerBoundary = days.asSequence()
            .flatMap { it.prayers.asSequence() }
            .map { it.at }
            .filter { it > nowMillis }
            .minOrNull()
        val nextMidnight =
            (Math.floorDiv(nowMillis + offsetMillis, DAY_MILLIS) + 1) * DAY_MILLIS - offsetMillis
        return if (prayerBoundary != null) minOf(prayerBoundary, nextMidnight) else nextMidnight
    }

    companion object {
        /** يطابق `HomeWidgetIds.payloadKey` في Dart حرفيًا. */
        const val KEY = "tamaneena_widgets_v2_payload"

        /** يطابق `HomeWidgetIds.payloadVersion`. بيانات بإصدار آخر تُتجاهل. */
        private const val VERSION = 2

        private const val DAY_MILLIS = 86_400_000L
        private const val TAG = "TamaneenaWidgets"

        fun load(context: Context): WidgetPayload? {
            return try {
                val raw = HomeWidgetPlugin.getData(context).getString(KEY, null) ?: return null
                parse(JSONObject(raw))
            } catch (error: Exception) {
                Log.w(TAG, "Unreadable widget payload", error)
                null
            }
        }

        private fun parse(json: JSONObject): WidgetPayload? {
            if (json.optInt("version") != VERSION) return null
            return WidgetPayload(
                utcOffsetMinutes = json.optInt("utcOffsetMinutes"),
                location = json.optString("location").takeIf { it.isNotBlank() && it != "null" },
                days = json.optJSONArray("days").mapObjects(::parseDay),
                verses = json.optJSONArray("verses").mapObjects { verse ->
                    WidgetVerse(
                        date = verse.optString("date"),
                        text = verse.optString("text"),
                        source = verse.optString("source"),
                    )
                },
            )
        }

        private fun parseDay(day: JSONObject) = WidgetDay(
            date = day.optString("date"),
            weekday = day.optString("weekday"),
            gregorian = day.optString("gregorian"),
            hijri = day.optString("hijri"),
            prayers = day.optJSONArray("prayers").mapObjects { prayer ->
                WidgetPrayer(
                    key = prayer.optString("key"),
                    name = prayer.optString("name"),
                    at = prayer.optLong("at"),
                    time = prayer.optString("time"),
                    isPrayer = prayer.optBoolean("isPrayer", true),
                )
            },
        )

        private fun <T> JSONArray?.mapObjects(transform: (JSONObject) -> T): List<T> {
            if (this == null) return emptyList()
            return (0 until length()).mapNotNull { index -> optJSONObject(index)?.let(transform) }
        }
    }
}
