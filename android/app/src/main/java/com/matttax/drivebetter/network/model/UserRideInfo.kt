package com.matttax.drivebetter.network.model

data class UserRideInfo(
    val uuid: String,
    val latitude: Float,
    val longitude: Float,
    val speed: Float
)

data class UserRideBatch(
    val uuid: String,
    val ridePoints: List<RidePoint>
)
