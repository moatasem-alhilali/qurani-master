package com.tamaneena.tamaneena_app.smartoutreach.autodialer

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.database.sqlite.SQLiteDatabase

class AutoDialerBootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        if (action != Intent.ACTION_BOOT_COMPLETED &&
            action != "android.intent.action.QUICKBOOT_POWERON"
        ) {
            return
        }

        val dbFile = context.getDatabasePath(AutoDialerConstants.DATABASE_NAME)
        if (!dbFile.exists()) {
            return
        }

        val db = SQLiteDatabase.openDatabase(
            dbFile.absolutePath,
            null,
            SQLiteDatabase.OPEN_READONLY,
        )

        val scheduler = AutoDialerGroupScheduler(context)
        val cursor = db.rawQuery(
            "SELECT id, schedule_time, schedule_days, is_daily FROM groups WHERE is_enabled = 1",
            null,
        )

        cursor.use {
            while (it.moveToNext()) {
                val groupId = it.getInt(it.getColumnIndexOrThrow("id"))
                val scheduleTime = it.getString(it.getColumnIndexOrThrow("schedule_time"))
                val daysJson = it.getString(it.getColumnIndexOrThrow("schedule_days"))
                val isDaily = it.getInt(it.getColumnIndexOrThrow("is_daily")) == 1

                scheduler.scheduleNextOccurrence(
                    groupId = groupId,
                    daysJson = if (isDaily) "[]" else daysJson,
                    timeStr = scheduleTime,
                )
            }
        }

        db.close()
    }
}
