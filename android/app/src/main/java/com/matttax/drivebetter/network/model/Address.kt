package com.matttax.drivebetter.network.model

import com.google.gson.annotations.SerializedName

data class AddressResponse(
    val address: Address
)

data class Address(
    @SerializedName("short")
    val short: String,

    @SerializedName("full")
    val full: String,

    @SerializedName("region_type_full")
    val regionTypeFull: String,

    @SerializedName("region")
    val regionTypeShort: String
)
