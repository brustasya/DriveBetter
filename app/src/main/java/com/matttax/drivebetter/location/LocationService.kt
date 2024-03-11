package com.matttax.drivebetter.location

import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.IBinder
import android.os.PowerManager
import com.matttax.drivebetter.location.data.model.DashboardData
import com.matttax.drivebetter.location.utils.MessengerProtocol
import com.matttax.drivebetter.location.utils.NotificationUtils
import java.util.concurrent.TimeUnit
import javax.inject.Inject

class LocationService: Service() {

    @Inject
    lateinit var driveService: DriveService

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

        driveService.registerCallback(
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
            NotificationUtils.RACE_NOTIFICATION_ID,
            NotificationUtils.getRacingNotification(this)
        )
    }

    private fun stopForeground() {
        isForeGround = false
        stopSelf()
    }

    override fun onBind(intent: Intent?): IBinder {
        stopForeground(true)
        return serviceMessenger.getBinder()
    }

    override fun onRebind(intent: Intent?) {
        super.onRebind(intent)
        stopForeground()
    }

    override fun onUnbind(intent: Intent?): Boolean {
        if (driveService.isRaceOngoing()) {
            startForeGround()
        } else {
            stopForeground()
        }
        return true
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return START_NOT_STICKY
    }

    private fun onCommandReceived(@MessengerProtocol.Command command: Int) {
        when (command) {
            MessengerProtocol.COMMAND_HANDSHAKE -> {
                serviceMessenger.sendDashboardData(driveService.getDashboardData())
            }
            MessengerProtocol.COMMAND_START -> {
                driveService.startDrive()
            }
            MessengerProtocol.COMMAND_PAUSE -> {
                driveService.pauseDrive()
            }
            MessengerProtocol.COMMAND_STOP -> {
                stopRace()
            }
        }
    }

    private fun stopRace() {
        driveService.stopDrive()
        stopForeground()
    }

    override fun onDestroy() {
        super.onDestroy()

        if (wakeLock.isHeld) {
            wakeLock.release()
        }
    }

    private fun checkAndUpdateCPUWake(dashboardData: DashboardData) {
        if (dashboardData.isRunning().not()) {
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