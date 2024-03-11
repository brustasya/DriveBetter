package com.matttax.drivebetter.network.model

data class AddressResponse(
    val address: Address
)

data class Address(
    val short: String,
    val full: String
)
