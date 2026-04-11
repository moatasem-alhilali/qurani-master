package com.tamaneena.tamaneena_app.smartoutreach.alarmNotificationService

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import androidx.core.app.NotificationCompat
import com.tamaneena.tamaneena_app.MainActivity
import com.tamaneena.tamaneena_app.R
import com.tamaneena.tamaneena_app.smartoutreach.SmartOutreachAlarmConstants

class SmartOutreachAlarmNotificationServiceImpl(
    private val context: Context,
) : SmartOutreachAlarmNotificationService {
    private val notificationManager: NotificationManager =
        context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    init {
        createNotificationChannel()
    }

    override fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            return
        }

        val soundUri = Uri.parse("android.resource://${context.packageName}/${R.raw.default_custom}")
        val audioAttributes = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_ALARM)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .build()

        val channel = NotificationChannel(
            SmartOutreachAlarmConstants.CHANNEL_ID,
            SmartOutreachAlarmConstants.CHANNEL_NAME,
            NotificationManager.IMPORTANCE_HIGH,
        ).apply {
            description = "تنبيهات مهمة التواصل الذكي"
            setBypassDnd(true)
            lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            enableLights(true)
            enableVibration(true)
            setSound(soundUri, audioAttributes)
        }

        notificationManager.createNotificationChannel(channel)
    }

    override fun showNotification(
        requestCode: Int,
        scheduleId: Int,
        title: String,
        body: String,
    ) {
        val fullScreenIntent = Intent(context, MainActivity::class.java).apply {
            action = SmartOutreachAlarmConstants.ACTION_OPEN_SMART_OUTREACH_ALARM
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra(SmartOutreachAlarmConstants.EXTRA_SCHEDULE_ID, scheduleId)
        }

        val fullScreenPendingIntent = PendingIntent.getActivity(
            context,
            requestCode,
            fullScreenIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val notification = NotificationCompat.Builder(
            context,
            SmartOutreachAlarmConstants.CHANNEL_ID,
        )
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(title)
            .setContentText(body)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setContentIntent(fullScreenPendingIntent)
            .setFullScreenIntent(fullScreenPendingIntent, true)
            .setOngoing(true)
            .setAutoCancel(true)
            .build()

        notificationManager.cancel(requestCode)
        notificationManager.notify(requestCode, notification)
    }

    override fun cancelNotification(id: Int) {
        notificationManager.cancel(id)
    }
}
