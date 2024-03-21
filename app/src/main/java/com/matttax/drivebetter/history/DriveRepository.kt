package com.matttax.drivebetter.history

import com.matttax.drivebetter.network.ApiHelper
import com.matttax.drivebetter.speedometer.model.LocationPoint
import com.matttax.drivebetter.speedometer.model.PathItem
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject

class DriveRepository @Inject constructor(
    private val apiHelper: ApiHelper
) {

    fun addDrive(drive: Drive, drivePath: List<PathItem>): Long {
        val id = 1L
        return id
    }

    fun getRideHistoryById(userId: String): Flow<List<Ride>> {
        return apiHelper.getRidesHistory(userId)
    }

}

data class Drive(
    val id: Long? = null,
    val tag: String? = null,
    val startLocation: LocationPoint,
    var startLocality: String? = null,
    val endLocation: LocationPoint,
    var endLocality: String? = null,
    val distance: Int,
    val startTime: Long,
    val endTime: Long,
    val pauseTime: Long,
    val topSpeed: Double,
    val path: List<PathItem>,
    val createdAt: Long = System.currentTimeMillis()
)
