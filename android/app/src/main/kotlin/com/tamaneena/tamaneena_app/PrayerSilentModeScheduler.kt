package com.tamaneena.tamaneena_app

import android.app.AlarmManager
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.provider.Settings

class PrayerSilentModeScheduler(private val context: Context) {
    private val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
    private val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

    fun hasNotificationPolicyAccess(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return true
        }
        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        return notificationManager.isNotificationPolicyAccessGranted
    }

    fun openNotificationPolicySettings() {
        val intent = Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        context.startActivity(intent)
    }

    fun schedule(windows: List<Map<String, Any?>>, durationMinutes: Int) {
        cancelScheduledAlarms(restoreActiveSession = false)
        val now = System.currentTimeMillis()
        val durationMillis = durationMinutes.coerceAtLeast(1) * 60L * 1000L
        val requestCodes = mutableSetOf<String>()

        windows.forEachIndexed { index, window ->
            val triggerAtMillis = (window["timeMillis"] as? Number)?.toLong() ?: return@forEachIndexed
            val endAtMillis = (window["endMillis"] as? Number)?.toLong()
                ?: (triggerAtMillis + durationMillis)
            if (triggerAtMillis <= now || endAtMillis <= now) {
                return@forEachIndexed
            }

            val requestCode = (window["requestCode"] as? Number)?.toInt()
                ?: (REQUEST_CODE_BASE + index)
            val intent = Intent(context, PrayerSilentModeReceiver::class.java).apply {
                action = PrayerSilentModeReceiver.ACTION_ENTER_SILENT
                putExtra(PrayerSilentModeReceiver.EXTRA_TRIGGER_ID, requestCode)
                putExtra(PrayerSilentModeReceiver.EXTRA_DURATION_MILLIS, durationMillis)
                putExtra(PrayerSilentModeReceiver.EXTRA_PRAYER_TIME_MILLIS, triggerAtMillis)
                putExtra(PrayerSilentModeReceiver.EXTRA_END_TIME_MILLIS, endAtMillis)
                putExtra(PrayerSilentModeReceiver.EXTRA_PRAYER_NAME, window["name"] as? String ?: "")
            }
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                requestCode,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
            PrayerSilentModeReceiver.scheduleExactCompat(
                alarmManager,
                triggerAtMillis,
                pendingIntent,
            )
            requestCodes.add(requestCode.toString())
        }

        prefs.edit()
            .putStringSet(KEY_ENTER_REQUEST_CODES, requestCodes)
            .apply()
    }

    fun cancel() {
        cancelScheduledAlarms(restoreActiveSession = true)
    }

    private fun cancelScheduledAlarms(restoreActiveSession: Boolean) {
        val requestCodes = prefs.getStringSet(KEY_ENTER_REQUEST_CODES, emptySet()).orEmpty()
        requestCodes.forEach { code ->
            val requestCode = code.toIntOrNull() ?: return@forEach
            cancelPendingIntent(
                requestCode = requestCode,
                action = PrayerSilentModeReceiver.ACTION_ENTER_SILENT,
            )
            cancelPendingIntent(
                requestCode = RESTORE_REQUEST_CODE_BASE + requestCode,
                action = PrayerSilentModeReceiver.ACTION_RESTORE_SOUND,
            )
        }
        if (restoreActiveSession) {
            PrayerSilentModeReceiver.restoreIfActiveNow(context)
        }
        prefs.edit()
            .remove(KEY_ENTER_REQUEST_CODES)
            .apply()
    }

    private fun cancelPendingIntent(requestCode: Int, action: String) {
        val intent = Intent(context, PrayerSilentModeReceiver::class.java).apply {
            this.action = action
        }
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            requestCode,
            intent,
            PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE,
        )
        if (pendingIntent != null) {
            alarmManager.cancel(pendingIntent)
            pendingIntent.cancel()
        }
    }

    companion object {
        private const val PREFS_NAME = "prayer_silent_mode"
        private const val KEY_ENTER_REQUEST_CODES = "enter_request_codes"
        private const val REQUEST_CODE_BASE = 630000
        private const val RESTORE_REQUEST_CODE_BASE = 700000
    }
}
