package com.tamaneena.tamaneena_app.smartoutreach.alarmNotificationService

interface SmartOutreachAlarmNotificationService {
    fun createNotificationChannel()

    fun showNotification(
        requestCode: Int,
        scheduleId: Int,
        title: String,
        body: String,
    )

    fun cancelNotification(id: Int)
}
