package com.matttax.drivebetter.location

import com.matttax.drivebetter.location.data.model.DashboardData
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import javax.inject.Inject

class DriveService @Inject constructor(
    private val locationProvider: LocationProvider,
//    private val driveRepository: DriveRepository
) {

    private var currentDrive: CurrentDrive? = null
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
        if (currentDrive == null || currentDrive?.isStopped() == true) {
            currentDrive = CurrentDrive()
        }
        currentDrive?.onStart()
        locationProvider.subscribe(
            locationChangeCallback = { currentLocation ->
                currentDrive?.pingData(
                    locationTime = currentLocation.time,
                    currentLat = currentLocation.latitude,
                    currentLon = currentLocation.longitude,
                    gpsSpeed = currentLocation.speed,
                )
                dashboardDataCallback(getDashboardData())
            },
            gpsSignalCallback = { gpsSignalStrength ->
                this.gpsSignalStrength = gpsSignalStrength
                if (currentDrive?.isStarting() == true) {
                    dashboardDataCallback(getDashboardData())
                }
            }
        )
        dashboardDataCallback(getDashboardData())
    }

    fun pauseDrive() {
        currentDrive?.onPause()
        locationProvider.unsubscribe()
        dashboardDataCallback(getDashboardData())
    }

    fun stopDrive() {
        locationProvider.unsubscribe()
        currentDrive?.onStop()
        dashboardDataCallback(DashboardData.empty())
        currentDrive?.let { drive ->
            addDriveAndTriggerCallback(drive)
        }
        currentDrive = null
    }

    private fun addDriveAndTriggerCallback(currentDrive: CurrentDrive) =
        CoroutineScope(Dispatchers.IO).launch {
            addCurrentDriveAsDrive(currentDrive).let { driveId ->
                CoroutineScope(Dispatchers.Main).launch {
                    driveFinishCallback(driveId)
                }
            }
        }

    private suspend fun addCurrentDriveAsDrive(currentDrive: CurrentDrive): Long? {
        TODO()
    }

    fun isRaceOngoing() = currentDrive != null

    fun getDashboardData(): DashboardData {
        return currentDrive?.let {
            DashboardData(
                runningTime = it.getRunningTime(),
                currentSpeed = it.getCurrentSpeed().toDouble(),
                topSpeed = it.getTopSpeed().toDouble(),
                averageSpeed = it.getAverageSpeed(),
                distance = it.getDistance(),
                status = it.getStatus(),
                gpsSignalStrength = gpsSignalStrength
            )
        } ?: DashboardData.empty()
    }
}
