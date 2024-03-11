package com.matttax.drivebetter.location.path

import com.google.gson.annotations.SerializedName
import com.matttax.drivebetter.location.data.model.LocationPoint

data class DrivePathItem(
    @SerializedName("locationPoint") val locationPoint: LocationPoint,
    @SerializedName("speed") val speed: Float,
    @SerializedName("time") val time: Long,
    @SerializedName("duration") val duration: Long,
    @SerializedName("distance") val distance: Int,
    @SerializedName("nextLocationPoint") val nextLocationPoint: LocationPoint?
)
