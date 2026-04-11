package com.tamaneena.tamaneena_app

import android.app.NotificationManager
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.telephony.SmsManager
import com.ryanheise.audioservice.AudioServiceActivity
import com.tamaneena.tamaneena_app.smartoutreach.SmartOutreachAlarmConstants
import com.tamaneena.tamaneena_app.smartoutreach.alarmScheduler.SmartOutreachAlarmScheduler
import com.tamaneena.tamaneena_app.smartoutreach.alarmScheduler.SmartOutreachAlarmSchedulerImpl
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceActivity() {
    companion object {
        private const val DEVICE_ID_CHANNEL =
            "com.tamaneena.tamaneena_app/device_identity"
        private const val SMART_OUTREACH_CHANNEL =
            "com.tamaneena.tamaneena_app/smart_outreach"

        private var pendingSmartOutreachScheduleId: Int? = null
    }

    private lateinit var smartOutreachAlarmScheduler: SmartOutreachAlarmScheduler

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        cachePendingSmartOutreachIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        cachePendingSmartOutreachIntent(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        smartOutreachAlarmScheduler = SmartOutreachAlarmSchedulerImpl(this)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            DEVICE_ID_CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getDeviceId" -> {
                    val androidId = Settings.Secure.getString(
                        contentResolver,
                        Settings.Secure.ANDROID_ID,
                    )

                    if (androidId.isNullOrBlank()) {
                        result.error(
                            "UNAVAILABLE",
                            "ANDROID_ID is unavailable",
                            null,
                        )
                    } else {
                        result.success(androidId)
                    }
                }

                else -> result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            SMART_OUTREACH_CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "sendSmsDirect" -> {
                    val phone = call.argument<String>("phone").orEmpty().trim()
                    val message = call.argument<String>("message").orEmpty()

                    if (phone.isBlank()) {
                        result.error("INVALID_PHONE", "Phone number is empty", null)
                        return@setMethodCallHandler
                    }

                    try {
                        val smsManager: SmsManager =
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                                applicationContext.getSystemService(SmsManager::class.java)
                            } else {
                                @Suppress("DEPRECATION")
                                SmsManager.getDefault()
                            }

                        smsManager.sendTextMessage(phone, null, message, null, null)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("SMS_FAILED", e.message, null)
                    }
                }

                "canUseFullScreenIntent" -> {
                    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                        result.success(true)
                        return@setMethodCallHandler
                    }

                    try {
                        val manager = getSystemService(NotificationManager::class.java)
                        result.success(manager?.canUseFullScreenIntent() == true)
                    } catch (e: Exception) {
                        result.error("FSI_CHECK_FAILED", e.message, null)
                    }
                }

                "openFullScreenIntentSettings" -> {
                    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                        result.success(false)
                        return@setMethodCallHandler
                    }

                    try {
                        val intent =
                            Intent(Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT).apply {
                                data = Uri.parse("package:$packageName")
                            }
                        startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("FSI_SETTINGS_FAILED", e.message, null)
                    }
                }

                "scheduleSmartOutreachDailyAlarm" -> {
                    val requestCode = call.argument<Int>("requestCode")
                    val scheduleId = call.argument<Int>("scheduleId")
                    val hour = call.argument<Int>("hour")
                    val minute = call.argument<Int>("minute")
                    val title = call.argument<String>("title").orEmpty().trim()
                    val body = call.argument<String>("body").orEmpty().trim()

                    if (requestCode == null ||
                        scheduleId == null ||
                        hour == null ||
                        minute == null ||
                        title.isBlank()
                    ) {
                        result.error("INVALID_ARGS", "Invalid daily alarm args", null)
                        return@setMethodCallHandler
                    }

                    smartOutreachAlarmScheduler.scheduleDaily(
                        requestCode = requestCode,
                        scheduleId = scheduleId,
                        hour = hour,
                        minute = minute,
                        title = title,
                        body = body,
                    )
                    result.success(true)
                }

                "scheduleSmartOutreachOneShotAlarm" -> {
                    val requestCode = call.argument<Int>("requestCode")
                    val scheduleId = call.argument<Int>("scheduleId")
                    val triggerAtMillis = call.argument<Number>("triggerAtMillis")?.toLong()
                    val title = call.argument<String>("title").orEmpty().trim()
                    val body = call.argument<String>("body").orEmpty().trim()

                    if (requestCode == null ||
                        scheduleId == null ||
                        triggerAtMillis == null ||
                        title.isBlank()
                    ) {
                        result.error("INVALID_ARGS", "Invalid one-shot alarm args", null)
                        return@setMethodCallHandler
                    }

                    smartOutreachAlarmScheduler.scheduleOneShot(
                        requestCode = requestCode,
                        scheduleId = scheduleId,
                        triggerAtMillis = triggerAtMillis,
                        title = title,
                        body = body,
                    )
                    result.success(true)
                }

                "cancelSmartOutreachAlarm" -> {
                    val requestCode = call.argument<Int>("requestCode")
                    if (requestCode == null) {
                        result.error("INVALID_ARGS", "requestCode is required", null)
                        return@setMethodCallHandler
                    }
                    smartOutreachAlarmScheduler.cancel(requestCode)
                    result.success(true)
                }

                "consumePendingSmartOutreachScheduleId" -> {
                    result.success(consumePendingSmartOutreachScheduleId())
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun cachePendingSmartOutreachIntent(intent: Intent?) {
        if (intent?.action != SmartOutreachAlarmConstants.ACTION_OPEN_SMART_OUTREACH_ALARM) {
            return
        }

        val scheduleId = intent?.getIntExtra(
            SmartOutreachAlarmConstants.EXTRA_SCHEDULE_ID,
            -1,
        ) ?: -1

        if (scheduleId > 0) {
            pendingSmartOutreachScheduleId = scheduleId
        }
    }

    private fun consumePendingSmartOutreachScheduleId(): Int? {
        val value = pendingSmartOutreachScheduleId
        pendingSmartOutreachScheduleId = null
        return value
    }
}
