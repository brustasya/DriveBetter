package com.matttax.drivebetter.speedometer

import com.matttax.drivebetter.speedometer.model.CurrentDriveStatus
import com.matttax.drivebetter.history.Drive
import com.matttax.drivebetter.speedometer.path.EndForgotCalculator
import com.matttax.drivebetter.speedometer.model.LocationPoint
import com.matttax.drivebetter.speedometer.path.PauseCalculator
import com.matttax.drivebetter.speedometer.model.PathItem
import com.matttax.drivebetter.speedometer.path.DrivePathBuilder
import com.matttax.drivebetter.speedometer.utils.SphericalUtils
import java.util.concurrent.TimeUnit

class CurrentRideDataCollector(
    private val endForgotCalculator: EndForgotCalculator = EndForgotCalculator(),
    private val pauseCalculator: PauseCalculator = PauseCalculator(),
    private val drivePathBuilder: DrivePathBuilder = DrivePathBuilder()
) {

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
            onInitial(locationTime, currentLat, currentLon)
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
            val speed = distanceInMetre.toDouble() / timeTakenInSecs.toDouble()
            currentSpeed = when {
                speed == 0.0 -> 0f
                isCloseToComputed(speed) || currentSpeed == 0f -> speed.toFloat()
                speed / currentSpeed < 2 && speed / currentSpeed > 1 -> (speed.toFloat() + currentSpeed) / 2
                else -> currentSpeed
            }
            if (currentSpeed > topSpeed) {
                topSpeed = currentSpeed
            }
            if (endForgotCalculator.isForgot(currentSpeed).not()) {
                distance += distanceInMetre
                drivePathBuilder.addPathItem(currentLocation, currentSpeed)
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
        return 0.0.coerceAtMost(topSpeed.toDouble())
    }

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
        status = CurrentDriveStatus.STARTING
    }

    fun onPause() {
        this.status = CurrentDriveStatus.PAUSED
        pauseCalculator.onPause()
        lastLocation?.let {
            drivePathBuilder.addPathItem(it, currentSpeed)
        }
    }

    fun onStop() {
        this.status = CurrentDriveStatus.STOPPED
        lastLocation?.let {
            drivePathBuilder.addPathItem(it, currentSpeed)
        }
    }

    fun getRacePath(): List<PathItem> = drivePathBuilder.getRacePath()

    fun getAsDrive(): Drive? {
        val startLocationNonNull = startLocation ?: return null
        val endLocationNonNull = lastLocation ?: return null
        if (lastPingTime == 0L || getTotalTime() < 5L || distance < 5) return null
        return Drive(
            startLocation = startLocationNonNull,
            endLocation = endLocationNonNull,
            distance = distance,
            startTime = startTime,
            endTime = lastPingTime,
            pauseTime = pauseCalculator.getPausedTime(lastPingTime),
            topSpeed = topSpeed.toDouble(),
            path = drivePathBuilder.getRacePath()
        )
    }

    private fun onInitial(locationTime: Long, currentLat: Double, currentLon: Double) {
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
        return SphericalUtils.computeDistanceBetween(
            LocationPoint(prevLocation.latitude, prevLocation.longitude),
            LocationPoint(currentLat, currentLon)
        ).toInt()
    }

    private fun getTotalTime() = (lastPingTime - startTime) - pauseCalculator.getPausedTime(lastPingTime)

    private fun isCloseToComputed(speed: Double) = (speed / currentSpeed > 1 && speed / currentSpeed < 1.2)
}
