package com.matttax.drivebetter.speedometer.path

import com.matttax.drivebetter.speedometer.model.LocationPoint
import com.matttax.drivebetter.speedometer.utils.SphericalUtils
import java.util.concurrent.TimeUnit

class EndForgotCalculator {

    private val locationPoints: MutableMap<Long, LocationPoint> =
        object : LinkedHashMap<Long, LocationPoint>() {
            override fun removeEldestEntry(eldest: MutableMap.MutableEntry<Long, LocationPoint>?): Boolean {
                return size > 4
            }
        }

    fun addPoint(locationTime: Long, locationPoint: LocationPoint) {
        locationPoints[TimeUnit.MILLISECONDS.toSeconds(locationTime)] = locationPoint
    }

    fun isForgot(speed: Float): Boolean {
        val locationPointList = locationPoints.values.toList()
        val locationPoint1 = locationPointList.getOrNull(0)
        val locationPoint2 = locationPointList.getOrNull(1)
        val locationPoint3 = locationPointList.getOrNull(2)
        val locationPoint4 = locationPointList.getOrNull(3)
        return speed <= 1f && isDiffSmall(locationPoint1, locationPoint2) &&
                isDiffSmall(locationPoint1, locationPoint3) &&
                isDiffSmall(locationPoint1, locationPoint4) &&
                isDiffSmall(locationPoint2, locationPoint3) &&
                isDiffSmall(locationPoint2, locationPoint4)
    }

    private fun isDiffSmall(
        locationPoint1: LocationPoint?,
        locationPoint2: LocationPoint?
    ): Boolean {
        if (locationPoint1 == null || locationPoint2 == null) {
            return false
        }
        return SphericalUtils.computeDistanceBetween(
            locationPoint1,
            locationPoint2
        ) <= 2
    }
}
