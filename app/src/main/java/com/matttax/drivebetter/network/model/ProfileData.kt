package com.matttax.drivebetter.network.model

import com.google.gson.annotations.SerializedName

data class ProfileData(
    @SerializedName("uuid")
    val uuid: String,

    @SerializedName("age")
    val age: Int,

    @SerializedName("licence_number")
    val licenceNumber: String,

    @SerializedName("sex")
    val sex: String
)
