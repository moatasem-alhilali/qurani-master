package com.tamaneena.tamaneena_app.smartoutreach.alarmScheduler

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import com.tamaneena.tamaneena_app.MainActivity
import com.tamaneena.tamaneena_app.smartoutreach.SmartOutreachAlarmConstants
import com.tamaneena.tamaneena_app.smartoutreach.receiver.SmartOutreachAlarmReceiver
import java.util.Calendar

class SmartOutreachAlarmSchedulerImpl(
    private val context: Context,
) : SmartOutreachAlarmScheduler {
    private val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

    override fun scheduleDaily(
        requestCode: Int,
        scheduleId: Int,
        hour: Int,
        minute: Int,
        title: String,
        body: String,
    ) {
        val triggerAtMillis = computeNextDailyTriggerAtMillis(hour = hour, minute = minute)

        val intent = buildReceiverIntent(
            requestCode = requestCode,
            scheduleId = scheduleId,
            title = title,
            body = body,
            isDaily = true,
            hour = hour,
            minute = minute,
        )

        val pendingIntent = PendingIntent.getBroadcast(
            context,
            requestCode,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        scheduleExact(
            triggerAtMillis = triggerAtMillis,
            pendingIntent = pendingIntent,
            requestCode = requestCode,
            scheduleId = scheduleId,
        )
    }

    override fun scheduleOneShot(
        requestCode: Int,
        scheduleId: Int,
        triggerAtMillis: Long,
        title: String,
        body: String,
    ) {
        val intent = buildReceiverIntent(
            requestCode = requestCode,
            scheduleId = scheduleId,
            title = title,
            body = body,
            isDaily = false,
            hour = null,
            minute = null,
        )

        val pendingIntent = PendingIntent.getBroadcast(
            context,
            requestCode,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        scheduleExact(
            triggerAtMillis = triggerAtMillis,
            pendingIntent = pendingIntent,
            requestCode = requestCode,
            scheduleId = scheduleId,
        )
    }

    override fun cancel(requestCode: Int) {
        val intent = Intent(context, SmartOutreachAlarmReceiver::class.java).apply {
            action = SmartOutreachAlarmConstants.ACTION_TRIGGER_SMART_OUTREACH_ALARM
        }

        val pendingIntent = PendingIntent.getBroadcast(
            context,
            requestCode,
            intent,
            PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE,
        )

        pendingIntent?.let {
            alarmManager.cancel(it)
            it.cancel()
        }
    }

    private fun buildReceiverIntent(
        requestCode: Int,
        scheduleId: Int,
        title: String,
        body: String,
        isDaily: Boolean,
        hour: Int?,
        minute: Int?,
    ): Intent {
        return Intent(context, SmartOutreachAlarmReceiver::class.java).apply {
            action = SmartOutreachAlarmConstants.ACTION_TRIGGER_SMART_OUTREACH_ALARM
            putExtra(SmartOutreachAlarmConstants.EXTRA_REQUEST_CODE, requestCode)
            putExtra(SmartOutreachAlarmConstants.EXTRA_SCHEDULE_ID, scheduleId)
            putExtra(SmartOutreachAlarmConstants.EXTRA_TITLE, title)
            putExtra(SmartOutreachAlarmConstants.EXTRA_BODY, body)
            putExtra(SmartOutreachAlarmConstants.EXTRA_IS_DAILY, isDaily)
            if (hour != null) {
                putExtra(SmartOutreachAlarmConstants.EXTRA_HOUR, hour)
            }
            if (minute != null) {
                putExtra(SmartOutreachAlarmConstants.EXTRA_MINUTE, minute)
            }
        }
    }

    private fun scheduleExact(
        triggerAtMillis: Long,
        pendingIntent: PendingIntent,
        requestCode: Int,
        scheduleId: Int,
    ) {
        val showIntent = Intent(context, MainActivity::class.java).apply {
            action = SmartOutreachAlarmConstants.ACTION_OPEN_SMART_OUTREACH_ALARM
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                Intent.FLAG_ACTIVITY_SINGLE_TOP or
                Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra(SmartOutreachAlarmConstants.EXTRA_SCHEDULE_ID, scheduleId)
        }
        val showPendingIntent = PendingIntent.getActivity(
            context,
            requestCode + 700000,
            showIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        try {
            alarmManager.setAlarmClock(
                AlarmManager.AlarmClockInfo(triggerAtMillis, showPendingIntent),
                pendingIntent,
            )
            return
        } catch (_: Exception) {}

        try {
            when {
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.M -> {
                    alarmManager.setExactAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        triggerAtMillis,
                        pendingIntent,
                    )
                }

                else -> {
                    alarmManager.setExact(
                        AlarmManager.RTC_WAKEUP,
                        triggerAtMillis,
                        pendingIntent,
                    )
                }
            }
        } catch (_: SecurityException) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                alarmManager.setAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    triggerAtMillis,
                    pendingIntent,
                )
            } else {
                alarmManager.set(
                    AlarmManager.RTC_WAKEUP,
                    triggerAtMillis,
                    pendingIntent,
                )
            }
        }
    }

    private fun computeNextDailyTriggerAtMillis(
        hour: Int,
        minute: Int,
    ): Long {
        val now = Calendar.getInstance()
        val target = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, hour)
            set(Calendar.MINUTE, minute)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }

        if (!target.after(now)) {
            target.add(Calendar.DAY_OF_YEAR, 1)
        }

        return target.timeInMillis
    }
}
