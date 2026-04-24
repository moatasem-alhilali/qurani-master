package com.tamaneena.tamaneena_app.smartoutreach.autodialer

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.telephony.TelephonyManager

class AutoDialerCallStateReceiver : BroadcastReceiver() {
    companion object {
        const val INTENT_CALL_STATE =
            "com.tamaneena.tamaneena_app.smartoutreach.autodialer.CALL_STATE_CHANGED"
        const val EXTRA_STATE = "call_state"
        const val STATE_RINGING = "RINGING"
        const val STATE_OFFHOOK = "OFFHOOK"
        const val STATE_IDLE = "IDLE"
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != "android.intent.action.PHONE_STATE") {
            return
        }

        val stateStr = intent.getStringExtra(TelephonyManager.EXTRA_STATE) ?: return
        val mappedState = when (stateStr) {
            TelephonyManager.EXTRA_STATE_RINGING -> STATE_RINGING
            TelephonyManager.EXTRA_STATE_OFFHOOK -> STATE_OFFHOOK
            TelephonyManager.EXTRA_STATE_IDLE -> STATE_IDLE
            else -> return
        }

        val localIntent = Intent(INTENT_CALL_STATE).apply {
            putExtra(EXTRA_STATE, mappedState)
            setPackage(context.packageName)
        }
        context.sendBroadcast(localIntent)
    }
}
