package com.matttax.drivebetter.speedometer.model

import android.os.Parcelable
import com.matttax.drivebetter.speedometer.utils.ConversionUtils
import kotlinx.parcelize.IgnoredOnParcel
import kotlinx.parcelize.Parcelize

@Parcelize
data class DashboardData(
    private val currentSpeed: Double,
    private val topSpeed: Double,
    private val averageSpeed: Double,
    private val distance: Int,
    private val runningTime: Long,
    private val status: Int,
    private val gpsSignalStrength: Int
) : Parcelable {

    @IgnoredOnParcel
    val isRunning: Boolean
        get() = status != CurrentDriveStatus.STOPPED

    @IgnoredOnParcel
    val timeMs: Long = runningTime

    @IgnoredOnParcel
    val currentSpeedKph = ConversionUtils.getSpeed(currentSpeed)

    @IgnoredOnParcel
    val maxSpeedKph = ConversionUtils.getSpeed(topSpeed)

    @IgnoredOnParcel
    val averageSpeedKph = ConversionUtils.getSpeed(averageSpeed)

    @IgnoredOnParcel
    val distanceKm = ConversionUtils.getDistance(distance.toDouble())

    @IgnoredOnParcel
    val gpsStrengthPercentage = gpsSignalStrength

    @IgnoredOnParcel
    val rideStatus = status

    companion object {
        val EMPTY = DashboardData(
            runningTime = 0L,
            currentSpeed = 0.0,
            topSpeed = 0.0,
            averageSpeed = 0.0,
            distance = 0,
            status = CurrentDriveStatus.STOPPED,
            gpsSignalStrength = 0,
        )
    }
}
