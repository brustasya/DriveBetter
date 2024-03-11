package com.matttax.drivebetter.location

import com.matttax.drivebetter.location.calculation.EndForgotCalculator
import com.matttax.drivebetter.location.calculation.PauseCalculator
import com.matttax.drivebetter.location.data.model.CurrentDriveStatus
import com.matttax.drivebetter.location.data.model.Drive
import com.matttax.drivebetter.location.data.model.LocationPoint
import com.matttax.drivebetter.location.path.DrivePathBuilder
import com.matttax.drivebetter.location.path.DrivePathItem
import com.matttax.drivebetter.location.utils.SphericalUtil
import java.util.concurrent.TimeUnit
import javax.inject.Inject

class CurrentDrive {

    @Inject lateinit var drivePathBuilder: DrivePathBuilder
    @Inject lateinit var endForgotCalculator: EndForgotCalculator
    @Inject lateinit var pauseCalculator: PauseCalculator

    private var startLocation: LocationPoint? = null
    private var distance: Int = 0
    private var startTime: Long = 0L
    private var topSpeed: Float = 0f
    private var lastPingTime = startTime
    private var lastLocation = startLocation
    private var currentSpeed: Float = 0f
    private var status: Int = CurrentDriveStatus.STARTING

    fun pingData(
        locationTime: Long,
        currentLat: Double,
        currentLon: Double,
        gpsSpeed: Float?,
    ) {
        status = CurrentDriveStatus.STARTED
        if (startLocation == null) {
            initialize(locationTime, currentLat, currentLon)
        }
        val prevLocationNonNull = lastLocation ?: return
        val currentLocation = LocationPoint(currentLat, currentLon)
        val distanceInMetre = getDistanceInMetre(prevLocationNonNull, currentLat, currentLon)
        val timeTakenInSecs = TimeUnit.MILLISECONDS.toSeconds(locationTime - lastPingTime)

        if (pauseCalculator.considerPingForStopPause(locationTime)) {
            lastLocation = currentLocation
            lastPingTime = locationTime
            endForgotCalculator.addPoint(locationTime, LocationPoint(currentLat, currentLon))
            return
        }
        endForgotCalculator.addPoint(locationTime, LocationPoint(currentLat, currentLon))
        if (timeTakenInSecs > 1 && locationTime > lastPingTime) {
            currentSpeed = gpsSpeed ?: 0f
            val spd = distanceInMetre.toDouble() / timeTakenInSecs.toDouble()

            if (spd == 0.0) {
                currentSpeed = 0f
            } else if (currentSpeed == 0f) {
                currentSpeed = spd.toFloat()
            } else if (spd / currentSpeed > 1 && spd / currentSpeed < 1.2) {
                //gps speed is similar to computed
                currentSpeed = spd.toFloat()
            } else if (spd / currentSpeed > 1 && spd / currentSpeed < 2) {
                //Take average of gps speed and computed speed.
                currentSpeed = (spd.toFloat() + currentSpeed) / 2
            }

            if (currentSpeed > topSpeed) {
                topSpeed = currentSpeed
            }

            if (endForgotCalculator.isForgot(currentSpeed).not()) {
                distance += distanceInMetre
                lastLocation = currentLocation
                lastPingTime = locationTime
            }
        }
    }

    fun getAverageSpeed(): Double {
        val timeTaken = getTotalTime()

        if (distance > 20 && timeTaken > TimeUnit.SECONDS.toMillis(1)) {
            return (distance.toDouble() / (TimeUnit.MILLISECONDS.toSeconds(timeTaken).toDouble()))
        }

        return 0.0
    }

    fun getTotalTime() = (lastPingTime - startTime) - pauseCalculator.getPausedTime(lastPingTime)

    fun getRunningTime(): Long {
        return if (startTime > 0) (System.currentTimeMillis() - startTime) - pauseCalculator.getPausedTime(
            System.currentTimeMillis()
        ) else 0
    }

    fun getCurrentSpeed() = currentSpeed

    fun getTopSpeed() = topSpeed

    fun getDistance() = distance

    fun getStatus() = status

    fun isStopped() = status == CurrentDriveStatus.STOPPED

    fun isStarting() = status == CurrentDriveStatus.STARTING

    fun onStart() {
        this.status = CurrentDriveStatus.STARTING
    }

    fun onPause() {
        this.status = CurrentDriveStatus.PAUSED
        pauseCalculator.onPause()
        lastLocation?.let {
            drivePathBuilder.addRacePathItem(it, currentSpeed, lastPingTime, true)
        }
    }

    fun onStop() {
        this.status = CurrentDriveStatus.STOPPED
        lastLocation?.let {
            drivePathBuilder.addRacePathItem(it, currentSpeed, lastPingTime, true)
        }
    }

    fun getAsDrive(): Drive? {
        val startLocationNonNull = startLocation ?: return null
        val endLocationNonNull = lastLocation ?: return null
        if (lastPingTime == 0L) return null
        if (getTotalTime() < 5L) return null
        if (distance < 5) return null

        return Drive(
            startLocation = startLocationNonNull,
            endLocation = endLocationNonNull,
            distance = distance,
            startTime = startTime,
            endTime = lastPingTime,
            pauseTime = pauseCalculator.getPausedTime(lastPingTime),
            topSpeed = topSpeed.toDouble(),
            locationPath = drivePathBuilder.getRacePathLite()
        )
    }

    fun getRacePath(): List<DrivePathItem> = drivePathBuilder.getRacePath()

    private fun initialize(
        locationTime: Long,
        currentLat: Double,
        currentLon: Double
    ) {
        this.startTime = locationTime
        startLocation = LocationPoint(
            latitude = currentLat,
            longitude = currentLon
        )
        lastLocation = startLocation
    }

    private fun getDistanceInMetre(
        prevLocation: LocationPoint,
        currentLat: Double,
        currentLon: Double
    ): Int {
        return SphericalUtil.computeDistanceBetween(
            LocationPoint(
                prevLocation.latitude, prevLocation.longitude
            ),
            LocationPoint(currentLat, currentLon)
        ).toInt()
    }
}
