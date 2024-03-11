package com.matttax.drivebetter.location.path

import com.matttax.drivebetter.location.data.model.LocationPoint
import com.matttax.drivebetter.location.calculation.PathAngleDiffChecker
import javax.inject.Inject

class DrivePathBuilder @Inject constructor(
    private val pathAngleDiffChecker: PathAngleDiffChecker
) {

    private val drivePath = mutableListOf<DrivePathItemBuilder>()
    private val drivePathLite = mutableListOf<LocationPoint>()

    fun addRacePathItem(
        locationPoint: LocationPoint,
        speed: Float,
        time: Long,
        forceAdd: Boolean = false
    ) {
        drivePath.add(
            DrivePathItemBuilder()
                .setLocationPoint(locationPoint)
                .setSpeed(speed)
                .setTime(time)
        )
        if (isCriteriaMatchesForLite(locationPoint) || forceAdd) {
            drivePathLite.add(locationPoint)
        }
    }

    fun getRacePath(): List<DrivePathItem> = drivePath.map {
        it.build()
    }.toList()

    fun getRacePathLite(): List<LocationPoint> = drivePathLite.toList()

    private fun isCriteriaMatchesForLite(locationPoint: LocationPoint): Boolean {
        return pathAngleDiffChecker.isAngleDiff(locationPoint, true)
    }
}
