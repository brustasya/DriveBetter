package com.matttax.drivebetter.history

import com.google.gson.annotations.SerializedName
import com.matttax.drivebetter.network.model.Address

data class RideHistoryResponse(
    val rides: List<Ride>
)

data class Ride(
    @SerializedName("ride_id")
    val rideId: Int,

    @SerializedName("detected_role")
    val detectedRole: String,

    @SerializedName("selected_role")
    val selectedRole: String,

    @SerializedName("max_speed")
    val maxSpeed: String,

    @SerializedName("min_speed")
    val minSpeed: String,

    @SerializedName("speeding")
    val speedingHistory: List<Speeding>,

    @SerializedName("dangerous_accelerations")
    val accelerationHistory: List<Acceleration>,

    @SerializedName("dangerous_shifts")
    val shiftHistory: List<Shift>,

    @SerializedName("light_nighttime")
    val lightNighttimePercentage: Float,

    @SerializedName("nighttime")
    val nighttimePercentage: Float,

    @SerializedName("weather")
    val weatherHistory: List<Weather>
)

data class Speeding(
    val timestamp: Long,
    val speed: Float,
    val address: Address
)

data class Acceleration(
    val timestamp: Long,
    val acceleration: Float,
    val address: Address
)

data class Shift(
    @SerializedName("timestamp")
    val timestamp: Long,

    @SerializedName("shift_angle")
    val shiftAngle: Float,

    @SerializedName("rate_of_angle_change")
    val angleChange: Float,

    @SerializedName("address")
    val address: Address,
)

data class Weather(
    @SerializedName("timestamp")
    val timestamp: Long,

    @SerializedName("visibility")
    val visibility: Float,

    @SerializedName("weather_code")
    val weatherCode: Int,
)
