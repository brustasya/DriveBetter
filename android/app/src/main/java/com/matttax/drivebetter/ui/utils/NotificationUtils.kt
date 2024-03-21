package com.matttax.drivebetter.ui.utils

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import androidx.core.app.NotificationCompat
import com.matttax.drivebetter.MainActivity
import com.matttax.drivebetter.R

object NotificationUtils {

    fun getRacingNotification(
        context: Context,
    ): Notification {
        checkAndCreateChannel(context)
        val notificationIntent = Intent(context, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            context,
            OPEN_ACTIVITY_CODE,
            notificationIntent,
            PendingIntent.FLAG_IMMUTABLE
        )
        val notificationBuilder = NotificationCompat.Builder(context, FOREGROUND_CHANNEL_ID)
            .setContentTitle("Drive monitoring active")
            .setContentText("Keep the app open to increase accuracy")
            .setWhen(System.currentTimeMillis())
            .setSmallIcon(R.drawable.ic_baseline_car_24)
            .setContentIntent(pendingIntent)
        return notificationBuilder.build()
    }

    private fun checkAndCreateChannel(context: Context) {
        context.getSystemService(NotificationManager::class.java)?.let { notificationManager ->
            if (notificationManager.getNotificationChannel(FOREGROUND_CHANNEL_ID) == null) {
                val serviceChannel = NotificationChannel(
                    FOREGROUND_CHANNEL_ID,
                    FOREGROUND_CHANNEL_ID,
                    NotificationManager.IMPORTANCE_HIGH
                )
                notificationManager.createNotificationChannel(serviceChannel)
            }
        }
    }

    const val NOTIFICATION_ID = 1
    private const val FOREGROUND_CHANNEL_ID = "drive_better"
    private const val OPEN_ACTIVITY_CODE = 1
}
