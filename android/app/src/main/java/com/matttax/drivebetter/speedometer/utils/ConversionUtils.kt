package com.matttax.drivebetter.speedometer.utils

object ConversionUtils {

    fun getDistance(metre: Double): Double = convertToKm(metre)

    fun getSpeed(metrePerSecond: Double): Double = convertToKmPerHr(metrePerSecond)

    private fun convertToKm(metre: Double): Double {
        return if (metre > 10) {
            metre * METRE_KM
        } else 0.0
    }

    private fun convertToKmPerHr(metrePerSec: Double): Double {
        return if (metrePerSec > 0.3) {
            metrePerSec * KM_HOUR
        } else 0.0
    }

    private const val METRE_KM = 0.001
    private const val KM_HOUR = 3.6
}
