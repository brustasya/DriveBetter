package com.matttax.drivebetter.speedometer.model

data class LocationPoint(
    val latitude: Double,
    val longitude: Double,
    val timestamp: Long = System.currentTimeMillis()
)
