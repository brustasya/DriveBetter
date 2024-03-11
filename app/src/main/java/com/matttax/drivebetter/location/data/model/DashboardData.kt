package com.matttax.drivebetter.location.data.model

import android.os.Parcelable
import com.matttax.drivebetter.location.utils.ClockUtils
import com.matttax.drivebetter.location.utils.ConversionUtil
import com.matttax.drivebetter.location.data.model.CurrentDriveStatus.PAUSED
import com.matttax.drivebetter.location.data.model.CurrentDriveStatus.STOPPED
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

    fun getCurrentSpeed() = ConversionUtil.getSpeed(currentSpeed).toInt()

    fun getTopSpeed() = ConversionUtil.getSpeed(topSpeed).toInt()

    fun getAverageSpeedText() = ConversionUtil.getSpeedStr(averageSpeed)

    fun getCurrentSpeedText() = ConversionUtil.getSpeedStr(currentSpeed)

    fun getTopSpeedText() = ConversionUtil.getSpeedStr(topSpeed)

    fun getDistanceText() = ConversionUtil.getDistance(distance.toDouble())

    fun getSpeedUnitText() = ConversionUtil.getSpeedUnit()

    fun getDistanceUnitText() = ConversionUtil.getDistanceUnit()

    fun getGPSSignalStrength() = gpsSignalStrength

    fun timeText(): String {
        if (runningTime == 0L || runningTime <= 0L) {
            return "00:00"
        }
        return ClockUtils.getTimeFromMillis(runningTime)
    }

    fun getStatus(): Int {
        return status
    }

    fun isRunning(): Boolean {
        return status != STOPPED
    }

    fun isPaused(): Boolean {
        return status == PAUSED
    }

    companion object {
        fun empty() = DashboardData(
            runningTime = 0L,
            currentSpeed = 0.0,
            topSpeed = 0.0,
            averageSpeed = 0.0,
            distance = 0,
            status = STOPPED,
            gpsSignalStrength = 0,
        )
    }
}
