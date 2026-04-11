package com.tamaneena.tamaneena_app.smartoutreach.alarmScheduler

interface SmartOutreachAlarmScheduler {
    fun scheduleDaily(
        requestCode: Int,
        scheduleId: Int,
        hour: Int,
        minute: Int,
        title: String,
        body: String,
    )

    fun scheduleOneShot(
        requestCode: Int,
        scheduleId: Int,
        triggerAtMillis: Long,
        title: String,
        body: String,
    )

    fun cancel(requestCode: Int)
}
