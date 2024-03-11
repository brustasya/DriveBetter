package com.matttax.drivebetter.location.calculation

import com.matttax.drivebetter.location.data.model.LocationPoint
import com.matttax.drivebetter.location.path.DrivePathItem
import com.matttax.drivebetter.location.path.DrivePathItemBuilder
import com.matttax.drivebetter.location.utils.SphericalUtil
import javax.inject.Inject
import kotlin.math.abs

class PathAngleDiffChecker @Inject constructor() {

    private var prevLocationPoint: DrivePathItem? = null
    private var prevPrevLocationPoint: DrivePathItem? = null

    fun addLocationPoint(locationPoint: LocationPoint, speed: Float, time: Long) {
        if (prevPrevLocationPoint == null) {
            prevPrevLocationPoint = DrivePathItemBuilder()
                .setLocationPoint(locationPoint)
                .setSpeed(speed)
                .setTime(time)
                .build()
        } else if (prevLocationPoint == null) {
            prevLocationPoint = DrivePathItemBuilder()
                .setLocationPoint(locationPoint)
                .setSpeed(speed)
                .setTime(time)
                .build()
        } else {
            val distance: Double = prevLocationPoint?.let { prevPoint ->
                SphericalUtil.computeDistanceBetween(
                    prevPoint.locationPoint,
                    locationPoint
                )
            } ?: 0.0

            if (distance > 10.0) {
                prevPrevLocationPoint = prevLocationPoint
                prevLocationPoint = DrivePathItemBuilder()
                    .setLocationPoint(locationPoint)
                    .setSpeed(speed)
                    .setTime(time)
                    .build()
            }
        }
    }

    fun isAngleDiff(locationPoint: LocationPoint, isLite: Boolean): Boolean {

        val prevPrevLocPoint = prevPrevLocationPoint ?: return true
        val prevLocPoint = prevLocationPoint ?: return true

        val prevHeading = SphericalUtil.computeHeading(
            prevLocPoint.locationPoint,
            prevPrevLocPoint.locationPoint
        )

        val currentHeading = SphericalUtil.computeHeading(
            locationPoint,
            prevLocPoint.locationPoint
        )

        var diff = abs(currentHeading - prevHeading)
        if (diff > 180) {
            diff = 360 - diff
        }

        return if (isLite) {
            diff > 20
        } else {
            diff > 15
        }
    }
}
