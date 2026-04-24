package com.tamaneena.tamaneena_app.smartoutreach.autodialer

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.PowerManager

class AutoDialerAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val groupId = intent.getIntExtra("group_id", -1)
        val daysJson = intent.getStringExtra("days_json") ?: "[]"
        val scheduleTime = intent.getStringExtra("schedule_time")

        if (groupId <= 0) {
            return
        }

        val pm = context.getSystemService(Context.POWER_SERVICE) as PowerManager
        val wakeLock = pm.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "Tamaneena::AutoDialerAlarmWakeLock",
        )
        wakeLock.acquire(10_000L)

        val serviceIntent = Intent(context, AutoDialerCallManagerService::class.java).apply {
            putExtra("group_id", groupId)
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(serviceIntent)
        } else {
            context.startService(serviceIntent)
        }

        AutoDialerGroupScheduler(context).scheduleNextOccurrence(
            groupId = groupId,
            daysJson = daysJson,
            timeStr = scheduleTime,
        )

        if (wakeLock.isHeld) {
            wakeLock.release()
        }
    }
}
