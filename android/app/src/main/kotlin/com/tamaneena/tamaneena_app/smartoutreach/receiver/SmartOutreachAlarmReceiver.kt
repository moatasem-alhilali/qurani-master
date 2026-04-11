package com.tamaneena.tamaneena_app.smartoutreach.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.app.KeyguardManager
import com.tamaneena.tamaneena_app.MainActivity
import com.tamaneena.tamaneena_app.smartoutreach.SmartOutreachAlarmConstants
import com.tamaneena.tamaneena_app.smartoutreach.alarmNotificationService.SmartOutreachAlarmNotificationService
import com.tamaneena.tamaneena_app.smartoutreach.alarmNotificationService.SmartOutreachAlarmNotificationServiceImpl
import com.tamaneena.tamaneena_app.smartoutreach.alarmScheduler.SmartOutreachAlarmScheduler
import com.tamaneena.tamaneena_app.smartoutreach.alarmScheduler.SmartOutreachAlarmSchedulerImpl

class SmartOutreachAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        if (intent?.action != SmartOutreachAlarmConstants.ACTION_TRIGGER_SMART_OUTREACH_ALARM) {
            return
        }

        val requestCode = intent.getIntExtra(SmartOutreachAlarmConstants.EXTRA_REQUEST_CODE, -1)
        val scheduleId = intent.getIntExtra(SmartOutreachAlarmConstants.EXTRA_SCHEDULE_ID, -1)
        val title = intent.getStringExtra(SmartOutreachAlarmConstants.EXTRA_TITLE).orEmpty()
        val body = intent.getStringExtra(SmartOutreachAlarmConstants.EXTRA_BODY).orEmpty()
        val isDaily = intent.getBooleanExtra(SmartOutreachAlarmConstants.EXTRA_IS_DAILY, false)

        if (requestCode < 0 || scheduleId <= 0 || title.isBlank()) {
            return
        }

        val notificationService: SmartOutreachAlarmNotificationService =
            SmartOutreachAlarmNotificationServiceImpl(context)

        notificationService.showNotification(
            requestCode = requestCode,
            scheduleId = scheduleId,
            title = title,
            body = body,
        )
        openAlarmScreen(context = context, scheduleId = scheduleId)

        if (isDaily) {
            val hour = intent.getIntExtra(SmartOutreachAlarmConstants.EXTRA_HOUR, -1)
            val minute = intent.getIntExtra(SmartOutreachAlarmConstants.EXTRA_MINUTE, -1)
            if (hour in 0..23 && minute in 0..59) {
                val scheduler: SmartOutreachAlarmScheduler = SmartOutreachAlarmSchedulerImpl(context)
                scheduler.scheduleDaily(
                    requestCode = requestCode,
                    scheduleId = scheduleId,
                    hour = hour,
                    minute = minute,
                    title = title,
                    body = body,
                )
            }
        }
    }

    private fun openAlarmScreen(
        context: Context,
        scheduleId: Int,
    ) {
        val keyguardManager = context.getSystemService(KeyguardManager::class.java)
        if (keyguardManager?.isDeviceLocked == true) {
            return
        }

        val openIntent = Intent(context, MainActivity::class.java).apply {
            action = SmartOutreachAlarmConstants.ACTION_OPEN_SMART_OUTREACH_ALARM
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                Intent.FLAG_ACTIVITY_SINGLE_TOP or
                Intent.FLAG_ACTIVITY_CLEAR_TOP or
                Intent.FLAG_ACTIVITY_NO_USER_ACTION
            putExtra(SmartOutreachAlarmConstants.EXTRA_SCHEDULE_ID, scheduleId)
        }

        try {
            context.startActivity(openIntent)
        } catch (_: Exception) {
            // Keep notification full-screen intent as fallback on restricted devices.
        }
    }
}
