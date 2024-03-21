package com.matttax.drivebetter.speedometer.background

import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.IBinder
import android.os.PowerManager
import com.matttax.drivebetter.speedometer.DriveManager
import com.matttax.drivebetter.speedometer.background.communication.ServiceMessenger
import com.matttax.drivebetter.speedometer.background.protocol.annotations.Command
import com.matttax.drivebetter.speedometer.background.protocol.CommunicationProtocol
import com.matttax.drivebetter.speedometer.model.DashboardData
import com.matttax.drivebetter.ui.utils.NotificationUtils
import dagger.hilt.android.AndroidEntryPoint
import java.util.concurrent.TimeUnit
import javax.inject.Inject

@AndroidEntryPoint
class DriveService : Service() {

    @Inject lateinit var driveManager: DriveManager

    private var isForeGround: Boolean = false
    private val serviceMessenger =
        ServiceMessenger(::onCommandReceived)

    private val wakeLock by lazy {
        (getSystemService(Context.POWER_SERVICE) as PowerManager).newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            packageName
        ).also {
            it.setReferenceCounted(false)
        }
    }

    override fun onCreate() {
        super.onCreate()
        driveManager.registerCallback(
            dashboardDataCallback = { dashboardData ->
                serviceMessenger.sendDashboardData(dashboardData)
                checkAndUpdateCPUWake(dashboardData)
            },
            driveFinishCallback = { driveId ->
                serviceMessenger.sendRaceFinished(driveId)
                releaseWakelock()
            }
        )
    }

    private fun startForeGround() {
        isForeGround = true
        startForeground(
            NotificationUtils.NOTIFICATION_ID,
            NotificationUtils.getRacingNotification(this)
        )
    }

    private fun stopForeground() {
        isForeGround = false
        stopForeground(STOP_FOREGROUND_REMOVE)
    }

    override fun onBind(intent: Intent?): IBinder {
        stopForeground(STOP_FOREGROUND_REMOVE)
        return serviceMessenger.getBinder()
    }

    override fun onRebind(intent: Intent?) {
        super.onRebind(intent)
        stopForeground()
    }

    override fun onUnbind(intent: Intent?): Boolean {
        if (driveManager.isRaceOngoing()) {
            startForeGround()
        } else {
            stopForeground()
        }
        return true
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return START_NOT_STICKY
    }

    private fun onCommandReceived(@Command command: Int) {
        when (command) {
            CommunicationProtocol.COMMAND_HANDSHAKE -> {
                serviceMessenger.sendDashboardData(driveManager.getDashboardData())
            }
            CommunicationProtocol.COMMAND_START_RIDE -> {
                driveManager.startDrive()
            }
            CommunicationProtocol.COMMAND_PAUSE_RIDE -> {
                driveManager.pauseDrive()
            }
            CommunicationProtocol.COMMAND_STOP_RIDE -> {
                stopRace()
            }
        }
    }

    private fun stopRace() {
        driveManager.stopDrive()
        stopForeground()
    }

    override fun onDestroy() {
        super.onDestroy()

        if (wakeLock.isHeld) {
            wakeLock.release()
        }
    }

    private fun checkAndUpdateCPUWake(dashboardData: DashboardData) {
        if (!dashboardData.isRunning) {
            releaseWakelock()
        } else if (wakeLock.isHeld.not()) {
            wakeLock.acquire(TimeUnit.HOURS.toMillis(2))
        }
    }

    private fun releaseWakelock() {
        if (wakeLock.isHeld) {
            wakeLock.release()
        }
    }

}
