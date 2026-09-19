package com.tamaneena.tamaneena_app.smartoutreach.autodialer

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import com.tamaneena.tamaneena_app.R
import com.tamaneena.tamaneena_app.l10n.appLocalized

object AutoDialerNotificationChannel {
    /**
     * ينشئ قناة إشعارات الاتصال التلقائي، أو يحدّث اسمها ووصفها بلغة التطبيق
     * الحالية (إعادة الإنشاء بالمعرّف نفسه تحدّث الاسم والوصف فقط).
     */
    fun ensure(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            return
        }

        val localized = context.appLocalized()
        val channel = NotificationChannel(
            AutoDialerConstants.NOTIFICATION_CHANNEL_ID,
            localized.getString(R.string.ad_channel_name),
            NotificationManager.IMPORTANCE_LOW,
        ).apply {
            description = localized.getString(R.string.ad_channel_description)
            setShowBadge(false)
        }

        val manager = context.getSystemService(NotificationManager::class.java)
        manager?.createNotificationChannel(channel)
    }
}
