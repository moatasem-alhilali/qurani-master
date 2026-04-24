package com.tamaneena.tamaneena_app

import android.app.NotificationManager
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.telephony.SmsManager
import android.app.NotificationChannel
import com.ryanheise.audioservice.AudioServiceActivity
import com.tamaneena.tamaneena_app.smartoutreach.autodialer.AutoDialerCallManagerService
import com.tamaneena.tamaneena_app.smartoutreach.autodialer.AutoDialerConstants
import com.tamaneena.tamaneena_app.smartoutreach.autodialer.AutoDialerGroupScheduler
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceActivity() {
    companion object {
        private const val DEVICE_ID_CHANNEL =
            "com.tamaneena.tamaneena_app/device_identity"
        private const val SMART_OUTREACH_CHANNEL =
            "com.tamaneena.tamaneena_app/smart_outreach"
    }

    private lateinit var autoDialerGroupScheduler: AutoDialerGroupScheduler

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        autoDialerGroupScheduler = AutoDialerGroupScheduler(this)
        createAutoDialerNotificationChannel()

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

                "scheduleGroup" -> {
                    val groupId = call.argument<Int>("groupId")
                    val time = call.argument<String>("time").orEmpty().trim()
                    val daysJson = call.argument<String>("days").orEmpty().ifBlank { "[]" }

                    if (groupId == null || groupId <= 0 || time.isBlank()) {
                        result.error("INVALID_ARGS", "Invalid scheduleGroup args", null)
                        return@setMethodCallHandler
                    }

                    autoDialerGroupScheduler.scheduleNextOccurrence(groupId, daysJson, time)
                    result.success(true)
                }

                "cancelGroup" -> {
                    val groupId = call.argument<Int>("groupId")
                    if (groupId == null || groupId <= 0) {
                        result.error("INVALID_ARGS", "groupId is required", null)
                        return@setMethodCallHandler
                    }

                    autoDialerGroupScheduler.cancel(groupId)
                    result.success(true)
                }

                "triggerGroupNow" -> {
                    val groupId = call.argument<Int>("groupId")
                    if (groupId == null || groupId <= 0) {
                        result.error("INVALID_ARGS", "groupId is required", null)
                        return@setMethodCallHandler
                    }

                    val serviceIntent = Intent(this, AutoDialerCallManagerService::class.java).apply {
                        putExtra("group_id", groupId)
                    }

                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(serviceIntent)
                    } else {
                        startService(serviceIntent)
                    }
                    result.success(true)
                }

                "openBatterySettings" -> {
                    val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                        data = Uri.parse("package:$packageName")
                    }
                    startActivity(intent)
                    result.success(true)
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun createAutoDialerNotificationChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            return
        }

        val channel = NotificationChannel(
            AutoDialerConstants.NOTIFICATION_CHANNEL_ID,
            AutoDialerConstants.NOTIFICATION_CHANNEL_NAME,
            NotificationManager.IMPORTANCE_LOW,
        ).apply {
            description = "إشعارات خدمة الاتصال التلقائي"
            setShowBadge(false)
        }

        val manager = getSystemService(NotificationManager::class.java)
        manager?.createNotificationChannel(channel)
    }
}
