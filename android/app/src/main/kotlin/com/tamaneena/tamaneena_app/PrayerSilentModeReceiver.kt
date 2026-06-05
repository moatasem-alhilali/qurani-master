package com.tamaneena.tamaneena_app

import android.app.AlarmManager
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.media.AudioManager
import android.os.Build

class PrayerSilentModeReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            ACTION_ENTER_SILENT -> enterSilentMode(context, intent)
            ACTION_RESTORE_SOUND -> restoreSoundMode(context, intent)
        }
    }

    private fun enterSilentMode(context: Context, intent: Intent) {
        val triggerId = intent.getIntExtra(EXTRA_TRIGGER_ID, 0)
        val durationMillis = intent.getLongExtra(EXTRA_DURATION_MILLIS, DEFAULT_DURATION_MILLIS)
        val prayerTimeMillis = intent.getLongExtra(
            EXTRA_PRAYER_TIME_MILLIS,
            System.currentTimeMillis(),
        )
        val restoreAtMillis = intent.getLongExtra(
            EXTRA_END_TIME_MILLIS,
            prayerTimeMillis + durationMillis,
        )
        val now = System.currentTimeMillis()

        if (now < prayerTimeMillis - EARLY_TRIGGER_TOLERANCE_MILLIS) {
            rescheduleEnter(context, intent, prayerTimeMillis)
            return
        }

        if (restoreAtMillis <= now) {
            restoreIfActiveNow(context)
            return
        }

        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val wasActive = prefs.getLong(KEY_ACTIVE_UNTIL, 0L) > now

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val notificationManager =
                context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            if (!notificationManager.isNotificationPolicyAccessGranted) {
                return
            }
            if (!wasActive) {
                val previousFilter = notificationManager.currentInterruptionFilter
                prefs.edit()
                    .putInt(KEY_PREVIOUS_FILTER, previousFilter)
                    .apply()
            }
            notificationManager.setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_NONE)
        } else {
            @Suppress("DEPRECATION")
            val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
            if (!wasActive) {
                @Suppress("DEPRECATION")
                val previousMode = audioManager.ringerMode
                prefs.edit()
                    .putInt(KEY_PREVIOUS_RINGER_MODE, previousMode)
                    .apply()
            }
            @Suppress("DEPRECATION")
            audioManager.ringerMode = AudioManager.RINGER_MODE_SILENT
        }

        val activeUntil = maxOf(restoreAtMillis, prefs.getLong(KEY_ACTIVE_UNTIL, 0L))
        prefs.edit()
            .putLong(KEY_ACTIVE_UNTIL, activeUntil)
            .putInt(KEY_ACTIVE_TRIGGER_ID, triggerId)
            .apply()

        scheduleRestore(context, triggerId, activeUntil)
    }

    private fun restoreSoundMode(context: Context, intent: Intent) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val activeUntil = prefs.getLong(KEY_ACTIVE_UNTIL, 0L)
        if (activeUntil > System.currentTimeMillis() + RESTORE_GRACE_MILLIS) {
            return
        }

        restoreIfActiveNow(context)
    }

    private fun scheduleRestore(context: Context, triggerId: Int, restoreAtMillis: Long) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, PrayerSilentModeReceiver::class.java).apply {
            action = ACTION_RESTORE_SOUND
            putExtra(EXTRA_TRIGGER_ID, triggerId)
        }
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            RESTORE_REQUEST_CODE_BASE + triggerId,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        scheduleExactCompat(alarmManager, restoreAtMillis, pendingIntent)
    }

    private fun rescheduleEnter(context: Context, originalIntent: Intent, prayerTimeMillis: Long) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val triggerId = originalIntent.getIntExtra(EXTRA_TRIGGER_ID, 0)
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            triggerId,
            originalIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        scheduleExactCompat(alarmManager, prayerTimeMillis, pendingIntent)
    }

    companion object {
        const val ACTION_ENTER_SILENT =
            "com.tamaneena.tamaneena_app.prayer_silent.ACTION_ENTER_SILENT"
        const val ACTION_RESTORE_SOUND =
            "com.tamaneena.tamaneena_app.prayer_silent.ACTION_RESTORE_SOUND"
        const val EXTRA_TRIGGER_ID = "trigger_id"
        const val EXTRA_DURATION_MILLIS = "duration_millis"
        const val EXTRA_PRAYER_TIME_MILLIS = "prayer_time_millis"
        const val EXTRA_END_TIME_MILLIS = "end_time_millis"
        const val EXTRA_PRAYER_NAME = "prayer_name"

        private const val PREFS_NAME = "prayer_silent_mode"
        private const val KEY_ACTIVE_UNTIL = "active_until"
        private const val KEY_ACTIVE_TRIGGER_ID = "active_trigger_id"
        private const val KEY_PREVIOUS_FILTER = "previous_filter"
        private const val KEY_PREVIOUS_RINGER_MODE = "previous_ringer_mode"
        private const val DEFAULT_DURATION_MILLIS = 30L * 60L * 1000L
        private const val RESTORE_GRACE_MILLIS = 1500L
        private const val EARLY_TRIGGER_TOLERANCE_MILLIS = 60L * 1000L
        private const val RESTORE_REQUEST_CODE_BASE = 700000

        fun restoreIfActiveNow(context: Context) {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val activeUntil = prefs.getLong(KEY_ACTIVE_UNTIL, 0L)
            if (activeUntil <= 0L) {
                return
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val notificationManager =
                    context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                if (notificationManager.isNotificationPolicyAccessGranted) {
                    val previousFilter = prefs.getInt(
                        KEY_PREVIOUS_FILTER,
                        NotificationManager.INTERRUPTION_FILTER_ALL,
                    )
                    notificationManager.setInterruptionFilter(previousFilter)
                }
            } else {
                @Suppress("DEPRECATION")
                val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
                val previousMode = prefs.getInt(
                    KEY_PREVIOUS_RINGER_MODE,
                    AudioManager.RINGER_MODE_NORMAL,
                )
                @Suppress("DEPRECATION")
                audioManager.ringerMode = previousMode
            }

            prefs.edit()
                .remove(KEY_ACTIVE_UNTIL)
                .remove(KEY_ACTIVE_TRIGGER_ID)
                .remove(KEY_PREVIOUS_FILTER)
                .remove(KEY_PREVIOUS_RINGER_MODE)
                .apply()
        }

        fun scheduleExactCompat(
            alarmManager: AlarmManager,
            triggerAtMillis: Long,
            pendingIntent: PendingIntent,
        ) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                try {
                    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S ||
                        alarmManager.canScheduleExactAlarms()
                    ) {
                        alarmManager.setExactAndAllowWhileIdle(
                            AlarmManager.RTC_WAKEUP,
                            triggerAtMillis,
                            pendingIntent,
                        )
                    } else {
                        alarmManager.setAndAllowWhileIdle(
                            AlarmManager.RTC_WAKEUP,
                            triggerAtMillis,
                            pendingIntent,
                        )
                    }
                } catch (_: SecurityException) {
                    alarmManager.setAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        triggerAtMillis,
                        pendingIntent,
                    )
                }
            } else {
                alarmManager.setExact(
                    AlarmManager.RTC_WAKEUP,
                    triggerAtMillis,
                    pendingIntent,
                )
            }
        }
    }
}
