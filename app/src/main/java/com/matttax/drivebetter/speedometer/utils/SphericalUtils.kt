package com.matttax.drivebetter.speedometer.utils

import com.matttax.drivebetter.speedometer.model.LocationPoint
import kotlin.math.*

object SphericalUtils {

    fun computeHeading(from: LocationPoint, to: LocationPoint): Double {
        val fromLat = Math.toRadians(from.latitude)
        val fromLng = Math.toRadians(from.longitude)
        val toLat = Math.toRadians(to.latitude)
        val toLng = Math.toRadians(to.longitude)
        val dLng = toLng - fromLng
        val heading = atan2(
            sin(dLng) * cos(toLat),
            cos(fromLat) * sin(toLat) - sin(fromLat) * cos(toLat) * cos(dLng)
        )
        return wrap(Math.toDegrees(heading))
    }

    fun computeDistanceBetween(from: LocationPoint, to: LocationPoint): Double {
        return computeAngleBetween(from, to) * EARTH_RADIUS
    }

    private fun computeAngleBetween(from: LocationPoint, to: LocationPoint): Double {
        val fromLat = Math.toRadians(from.latitude)
        val fromLng = Math.toRadians(from.longitude)
        val toLat = Math.toRadians(to.latitude)
        val toLng = Math.toRadians(to.longitude)
        val dLat = fromLat - toLat
        val dLng = fromLng - toLng
        return 2 * asin(
            sqrt(
                sin(dLat / 2).pow(2.0) + cos(fromLat) * cos(toLat) * sin(dLng / 2).pow(2.0)
            )
        )
    }

    private fun wrap(n: Double): Double {
        return if (n >= MIN_ANGLE && n < MAX_ANGLE) n
            else mod(n - MIN_ANGLE) + MIN_ANGLE
    }

    private fun mod(x: Double): Double {
        return (x % ANGLES + ANGLES) % ANGLES
    }

    private const val EARTH_RADIUS = 6371009.0
    private const val MIN_ANGLE = -180.0
    private const val MAX_ANGLE = 180.0
    private const val ANGLES = 360.0
}
