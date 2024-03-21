package com.matttax.drivebetter.speedometer.path

import com.matttax.drivebetter.speedometer.model.LocationPoint
import com.matttax.drivebetter.speedometer.model.PathItem

class DrivePathBuilder {

    private val drivePath = mutableListOf<PathItem>()

    fun addPathItem(locationPoint: LocationPoint, speed: Float, ) {
        drivePath.add(
            PathItem(locationPoint, speed)
        )
    }

    fun getRacePath(): List<PathItem> = drivePath
}
