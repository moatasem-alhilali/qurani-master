package com.tamaneena.tamaneena_app.smartoutreach.autodialer

import android.Manifest
import android.app.Notification
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.BroadcastReceiver
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.content.pm.ServiceInfo
import android.database.sqlite.SQLiteDatabase
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.PowerManager
import android.telecom.TelecomManager
import androidx.core.content.ContextCompat
import androidx.core.app.NotificationCompat
import com.tamaneena.tamaneena_app.MainActivity
import com.tamaneena.tamaneena_app.R
import com.tamaneena.tamaneena_app.l10n.appLocalized
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class AutoDialerCallManagerService : Service() {
    companion object {
        private const val NOTIFICATION_ID = 33001
    }

    private val handler = Handler(Looper.getMainLooper())
    private val numbers = mutableListOf<String>()
    private var currentIndex = 0
    private var groupId = -1
    private var ringTimeout = 20_000L
    private var hangupDelay = 30_000L
    private var delayBetween = 3_000L
    private var stopOnFirst = false
    private var db: SQLiteDatabase? = null
    private var wakeLock: PowerManager.WakeLock? = null
    private var isRinging = false
    private var isAnswered = false

    /**
     * نصوص الإشعارات وأسباب الفشل (المحفوظة في سجل المكالمات ويعرضها Flutter كما هي)
     * بلغة التطبيق المختارة لا لغة الجهاز. يُحدَّث مع كل بدء جلسة.
     */
    private var localizedContext: Context? = null

    private fun text(resId: Int, vararg formatArgs: Any): String {
        val context = localizedContext ?: appLocalized().also { localizedContext = it }
        return if (formatArgs.isEmpty()) {
            context.getString(resId)
        } else {
            context.getString(resId, *formatArgs)
        }
    }

    private val ringTimeoutRunnable = Runnable {
        if (isRinging && !isAnswered) {
            logCall(numbers.getOrNull(currentIndex) ?: "", "not_answered", 0)
            handleNotAnswered()
        }
    }

    private val hangupRunnable = Runnable {
        isRinging = false
        isAnswered = false
        hangUp()
        logCall(numbers.getOrNull(currentIndex) ?: "", "answered", (hangupDelay / 1000).toInt())
        handleAnsweredDone()
    }

    private val callStateReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val state =
                intent.getStringExtra(AutoDialerCallStateReceiver.EXTRA_STATE) ?: return
            handleCallState(state)
        }
    }

    override fun onCreate() {
        super.onCreate()
        registerCallStateReceiver()
        val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = pm.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "Tamaneena::AutoDialerServiceWakeLock",
        )
        wakeLock?.acquire(30 * 60 * 1000L)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        localizedContext = appLocalized()
        AutoDialerNotificationChannel.ensure(this)

        // Android gives a service started with startForegroundService ~5s to
        // promote itself, and kills the process if it does not. Nothing above
        // this line may block, and a refusal here must not propagate: the whole
        // feature failing is better than the app dying.
        if (!promoteToForeground()) {
            stopSelf()
            return START_NOT_STICKY
        }

        groupId = intent?.getIntExtra("group_id", -1) ?: -1
        if (groupId <= 0) {
            stopSelf()
            return START_NOT_STICKY
        }

        // Reading the schedule touches SQLite, which can fail for reasons the
        // user can do nothing about (file not created yet, schema older than
        // this build). It used to be unguarded, so any of those took the
        // process down with it.
        val loaded = try {
            loadGroupData()
            true
        } catch (error: Exception) {
            false
        }

        if (!loaded) {
            finishSession(text(R.string.ad_reason_call_failed))
            return START_NOT_STICKY
        }

        if (numbers.isEmpty()) {
            finishSession(text(R.string.ad_reason_invalid_number))
            return START_NOT_STICKY
        }

        startCallingCycle()
        return START_NOT_STICKY
    }

    /** Returns false when the system refuses the promotion. */
    private fun promoteToForeground(): Boolean {
        val notification = buildNotification(text(R.string.ad_session_starting))
        return try {
            // The type argument is only passed on 34+, where types exist and
            // are enforced. FOREGROUND_SERVICE_TYPE_SPECIAL_USE itself was
            // added in 34, so on older releases the manifest value is ignored
            // and the two-argument call is the correct one.
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                startForeground(
                    NOTIFICATION_ID,
                    notification,
                    ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE,
                )
            } else {
                startForeground(NOTIFICATION_ID, notification)
            }
            true
        } catch (error: Exception) {
            false
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        handler.removeCallbacksAndMessages(null)
        try {
            unregisterReceiver(callStateReceiver)
        } catch (_: Exception) {
        }
        db?.close()
        try {
            if (wakeLock?.isHeld == true) {
                wakeLock?.release()
            }
        } catch (_: Exception) {
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun loadGroupData() {
        val dbPath = getDatabasePath(AutoDialerConstants.DATABASE_NAME)
        db = SQLiteDatabase.openDatabase(dbPath.absolutePath, null, SQLiteDatabase.OPEN_READWRITE)

        val groupCursor = db!!.rawQuery(
            "SELECT ring_timeout, hangup_delay, delay_between_calls, stop_on_first_answered FROM groups WHERE id = ?",
            arrayOf(groupId.toString()),
        )
        groupCursor.use {
            if (it.moveToFirst()) {
                ringTimeout = it.getInt(it.getColumnIndexOrThrow("ring_timeout")) * 1000L
                hangupDelay = it.getInt(it.getColumnIndexOrThrow("hangup_delay")) * 1000L
                delayBetween =
                    it.getInt(it.getColumnIndexOrThrow("delay_between_calls")) * 1000L
                stopOnFirst =
                    it.getInt(it.getColumnIndexOrThrow("stop_on_first_answered")) == 1
            }
        }

        val numberCursor = db!!.rawQuery(
            "SELECT number FROM phone_numbers WHERE group_id = ? ORDER BY sort_order ASC",
            arrayOf(groupId.toString()),
        )
        numberCursor.use {
            while (it.moveToNext()) {
                numbers.add(it.getString(it.getColumnIndexOrThrow("number")))
            }
        }
    }

    private fun startCallingCycle() {
        currentIndex = 0
        callNext()
    }

    private fun callNext() {
        if (currentIndex >= numbers.size) {
            finishSession(text(R.string.ad_cycle_completed))
            return
        }

        val number = numbers[currentIndex]
        updateNotification(text(R.string.ad_calling_number, number))
        placeCall(number)
        isRinging = true
        isAnswered = false
        handler.postDelayed(ringTimeoutRunnable, ringTimeout)
    }

    private fun handleNotAnswered() {
        handler.removeCallbacks(ringTimeoutRunnable)
        isRinging = false
        currentIndex++
        handler.postDelayed({ callNext() }, delayBetween)
    }

    private fun handleAnsweredDone() {
        if (stopOnFirst) {
            finishSession(text(R.string.ad_call_answered))
        } else {
            currentIndex++
            handler.postDelayed({ callNext() }, delayBetween)
        }
    }

    private fun finishSession(reason: String) {
        updateNotification(reason)
        handler.postDelayed({ stopSelf() }, 2_000L)
    }

    private fun handleCallState(state: String) {
        when (state) {
            AutoDialerCallStateReceiver.STATE_RINGING -> isRinging = true
            AutoDialerCallStateReceiver.STATE_OFFHOOK -> {
                if (isRinging && !isAnswered) {
                    isAnswered = true
                    handler.removeCallbacks(ringTimeoutRunnable)
                    handler.postDelayed(hangupRunnable, hangupDelay)
                    updateNotification(text(R.string.ad_answered_auto_hangup, hangupDelay / 1000))
                }
            }
            AutoDialerCallStateReceiver.STATE_IDLE -> {
                if (isRinging && !isAnswered) {
                    handler.removeCallbacks(ringTimeoutRunnable)
                    logCall(numbers.getOrNull(currentIndex) ?: "", "not_answered", 0)
                    isRinging = false
                    currentIndex++
                    handler.postDelayed({ callNext() }, delayBetween)
                } else if (isAnswered) {
                    handler.removeCallbacks(hangupRunnable)
                    logCall(numbers.getOrNull(currentIndex) ?: "", "answered", 0)
                    isRinging = false
                    isAnswered = false
                    handleAnsweredDone()
                }
            }
        }
    }

    private fun placeCall(number: String) {
        val cleanNumber = sanitizeForDial(number)
        if (cleanNumber.isBlank()) {
            failCall(number, text(R.string.ad_reason_invalid_number))
            return
        }

        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CALL_PHONE) !=
            PackageManager.PERMISSION_GRANTED
        ) {
            failCall(cleanNumber, text(R.string.ad_reason_call_permission_disabled))
            return
        }

        // fromParts encodes the scheme-specific part; Uri.parse("tel:$n") does
        // not, so a stored number that still carries a space produced a broken
        // URI and the call either failed or dialled a truncated number.
        val uri = Uri.fromParts("tel", cleanNumber, null)
        try {
            val telecomManager = getSystemService(Context.TELECOM_SERVICE) as TelecomManager
            telecomManager.placeCall(uri, null)
        } catch (e: SecurityException) {
            val callIntent = Intent(Intent.ACTION_CALL, uri).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            try {
                startActivity(callIntent)
            } catch (inner: Exception) {
                failCall(cleanNumber, resolveFailureReason(inner))
            }
        } catch (e: Exception) {
            failCall(cleanNumber, resolveFailureReason(e))
        }
    }

    /**
     * Last line of defence for the dialled string. Dart normalises on the way
     * in, but rows written by older builds are still in the database, so the
     * number is cleaned again here rather than trusted.
     *
     * Keeps digits, a leading +, and the DTMF characters tel: allows.
     */
    private fun sanitizeForDial(raw: String): String {
        val builder = StringBuilder()
        var plus = false

        for (char in raw.trim()) {
            when {
                char == '+' -> if (builder.isEmpty() && !plus) plus = true
                char.isDigit() -> builder.append(char)
                char in "*#,;" -> builder.append(char)
            }
        }

        var digits = builder.toString()
        if (!plus && digits.startsWith("00")) {
            plus = true
            digits = digits.substring(2)
        }

        if (digits.isEmpty()) return ""
        return if (plus) "+$digits" else digits
    }

    private fun failCall(number: String, reason: String) {
        logCall(number, "failed", 0, reason)
        updateNotification(reason)
        isRinging = false
        isAnswered = false
        handler.removeCallbacks(ringTimeoutRunnable)
        currentIndex++
        handler.postDelayed({ callNext() }, delayBetween)
    }

    private fun hangUp() {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                val telecom = getSystemService(Context.TELECOM_SERVICE) as TelecomManager
                telecom.endCall()
            }
        } catch (_: Exception) {
        }
    }

    private fun logCall(number: String, status: String, duration: Int, reason: String? = null) {
        try {
            val values = ContentValues().apply {
                put("group_id", groupId)
                put("number", number)
                put("status", status)
                put("reason", reason)
                put("duration", duration)
                put(
                    "called_at",
                    SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault()).format(Date()),
                )
            }
            db?.insert("call_logs", null, values)
        } catch (_: Exception) {
        }
    }

    private fun resolveFailureReason(error: Throwable?): String {
        val message = error?.message?.lowercase(Locale.getDefault()).orEmpty()
        return when {
            message.contains("permission") ->
                text(R.string.ad_reason_call_permission_disabled)
            message.contains("default dialer") || message.contains("dialer") ->
                text(R.string.ad_reason_default_dialer_required)
            message.contains("background") ->
                text(R.string.ad_reason_background_blocked)
            message.contains("activity") ->
                text(R.string.ad_reason_dialer_screen_failed)
            message.isNotBlank() ->
                text(R.string.ad_reason_call_failed_with_error, error?.message.orEmpty())
            else ->
                text(R.string.ad_reason_call_failed)
        }
    }

    private fun registerCallStateReceiver() {
        val filter = IntentFilter(AutoDialerCallStateReceiver.INTENT_CALL_STATE)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(callStateReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            registerReceiver(callStateReceiver, filter)
        }
    }

    private fun buildNotification(text: String): Notification {
        val launchIntent = PendingIntent.getActivity(
            this,
            0,
            Intent(this, MainActivity::class.java),
            PendingIntent.FLAG_IMMUTABLE,
        )
        return NotificationCompat.Builder(this, AutoDialerConstants.NOTIFICATION_CHANNEL_ID)
            .setContentTitle(text(R.string.ad_notification_title))
            .setContentText(text)
            .setSmallIcon(android.R.drawable.ic_menu_call)
            .setContentIntent(launchIntent)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
    }

    private fun updateNotification(text: String) {
        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.notify(NOTIFICATION_ID, buildNotification(text))
    }
}
