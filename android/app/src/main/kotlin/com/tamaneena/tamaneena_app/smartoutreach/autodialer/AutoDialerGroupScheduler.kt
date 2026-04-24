package com.tamaneena.tamaneena_app.smartoutreach.autodialer

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import org.json.JSONArray
import java.util.Calendar

class AutoDialerGroupScheduler(private val context: Context) {
    private val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

    fun scheduleNextOccurrence(groupId: Int, daysJson: String, timeStr: String?) {
        val targetMillis = computeNextTriggerMillis(daysJson, timeStr) ?: return

        val pendingIntent = PendingIntent.getBroadcast(
            context,
            groupId,
            Intent(context, AutoDialerAlarmReceiver::class.java).apply {
                action = AutoDialerConstants.ACTION_TRIGGER_GROUP
                putExtra("group_id", groupId)
                putExtra("days_json", daysJson)
                putExtra("schedule_time", timeStr)
            },
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    targetMillis,
                    pendingIntent,
                )
            } else {
                alarmManager.setExact(
                    AlarmManager.RTC_WAKEUP,
                    targetMillis,
                    pendingIntent,
                )
            }
        } catch (_: SecurityException) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                alarmManager.setAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    targetMillis,
                    pendingIntent,
                )
            } else {
                alarmManager.set(AlarmManager.RTC_WAKEUP, targetMillis, pendingIntent)
            }
        }
    }

    fun cancel(groupId: Int) {
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            groupId,
            Intent(context, AutoDialerAlarmReceiver::class.java).apply {
                action = AutoDialerConstants.ACTION_TRIGGER_GROUP
            },
            PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE,
        )
        pendingIntent?.let {
            alarmManager.cancel(it)
            it.cancel()
        }
    }

    private fun computeNextTriggerMillis(daysJson: String, timeStr: String?): Long? {
        val targetTime = timeStr ?: return null
        val parts = targetTime.split(":")
        if (parts.size != 2) {
            return null
        }

        val hour = parts[0].toIntOrNull() ?: return null
        val minute = parts[1].toIntOrNull() ?: return null
        val now = Calendar.getInstance()
        val daysArray = JSONArray(daysJson)

        return if (daysArray.length() == 0) {
            val candidate = now.clone() as Calendar
            candidate.set(Calendar.HOUR_OF_DAY, hour)
            candidate.set(Calendar.MINUTE, minute)
            candidate.set(Calendar.SECOND, 0)
            candidate.set(Calendar.MILLISECOND, 0)
            if (candidate.timeInMillis <= now.timeInMillis) {
                candidate.add(Calendar.DAY_OF_YEAR, 1)
            }
            candidate.timeInMillis
        } else {
            val days = (0 until daysArray.length()).map { daysArray.getInt(it) }.toSet()
            for (offset in 0..6) {
                val candidate = now.clone() as Calendar
                candidate.add(Calendar.DAY_OF_YEAR, offset)
                candidate.set(Calendar.HOUR_OF_DAY, hour)
                candidate.set(Calendar.MINUTE, minute)
                candidate.set(Calendar.SECOND, 0)
                candidate.set(Calendar.MILLISECOND, 0)
                val dow = candidate.get(Calendar.DAY_OF_WEEK)
                val isoDow = if (dow == Calendar.SUNDAY) 7 else dow - 1
                if (isoDow in days && candidate.timeInMillis > now.timeInMillis) {
                    return candidate.timeInMillis
                }
            }
            null
        }
    }
}
