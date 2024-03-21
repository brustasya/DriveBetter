package com.matttax.drivebetter.speedometer

import com.matttax.drivebetter.history.DriveRepository
import com.matttax.drivebetter.speedometer.location.LocationProvider
import com.matttax.drivebetter.speedometer.model.DashboardData
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import javax.inject.Inject

class DriveManager @Inject constructor(
    private val locationProvider: LocationProvider,
    private val driveRepository: DriveRepository
) {

    private var currentRideDataCollector: CurrentRideDataCollector? = null
    private var dashboardDataCallback: (DashboardData) -> Unit = {}
    private var driveFinishCallback: (Long?) -> Unit = {}
    private var gpsSignalStrength = 0

    fun registerCallback(
        dashboardDataCallback: (DashboardData) -> Unit,
        driveFinishCallback: (Long?) -> Unit
    ) {
        this.dashboardDataCallback = dashboardDataCallback
        this.driveFinishCallback = driveFinishCallback
    }

    fun startDrive() {
        if (currentRideDataCollector == null || currentRideDataCollector?.isStopped() == true) {
            currentRideDataCollector = CurrentRideDataCollector()
        }
        currentRideDataCollector?.onStart()
        locationProvider.subscribe(
            locationChangeCallback = { currentLocation ->
                currentRideDataCollector?.pingData(
                    locationTime = currentLocation.time,
                    currentLat = currentLocation.latitude,
                    currentLon = currentLocation.longitude,
                    gpsSpeed = currentLocation.speed,
                )
                dashboardDataCallback(getDashboardData())
            },
            gpsSignalCallback = { gpsSignalStrength ->
                this.gpsSignalStrength = gpsSignalStrength
                if (currentRideDataCollector?.isStarting() == true) {
                    dashboardDataCallback(getDashboardData())
                }
            }
        )
        dashboardDataCallback(getDashboardData())
    }

    fun pauseDrive() {
        currentRideDataCollector?.onPause()
        locationProvider.unsubscribe()
        dashboardDataCallback(getDashboardData())
    }

    fun stopDrive() {
        locationProvider.unsubscribe()
        currentRideDataCollector?.onStop()
        dashboardDataCallback(DashboardData.EMPTY)
        currentRideDataCollector?.let { drive ->
            addDriveAndTriggerCallback(drive)
        }
        currentRideDataCollector = null
    }

    private fun addDriveAndTriggerCallback(currentRideDataCollector: CurrentRideDataCollector) =
        CoroutineScope(Dispatchers.IO).launch {
            addCurrentDriveAsDrive(currentRideDataCollector).let { driveId ->
                CoroutineScope(Dispatchers.Main).launch {
                    driveFinishCallback(driveId)
                }
            }
        }

    private fun addCurrentDriveAsDrive(currentRideDataCollector: CurrentRideDataCollector): Long? {
        return currentRideDataCollector.getAsDrive()?.let {
            driveRepository.addDrive(it, currentRideDataCollector.getRacePath())
        }
    }

    fun isRaceOngoing() = currentRideDataCollector != null

    fun getDashboardData(): DashboardData {
        return currentRideDataCollector?.let {
            DashboardData(
                runningTime = it.getRunningTime(),
                currentSpeed = it.getCurrentSpeed().toDouble(),
                topSpeed = it.getTopSpeed().toDouble(),
                averageSpeed = it.getAverageSpeed(),
                distance = it.getDistance(),
                status = it.getStatus(),
                gpsSignalStrength = gpsSignalStrength
            )
        } ?: DashboardData.EMPTY
    }
}
