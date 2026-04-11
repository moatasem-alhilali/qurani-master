package com.tamaneena.tamaneena_app

import android.app.NotificationManager
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.telephony.SmsManager
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceActivity() {
    companion object {
        private const val DEVICE_ID_CHANNEL =
            "com.tamaneena.tamaneena_app/device_identity"
        private const val SMART_OUTREACH_CHANNEL =
            "com.tamaneena.tamaneena_app/smart_outreach"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

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

                else -> result.notImplemented()
            }
        }
    }
}
