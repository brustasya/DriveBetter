package com.matttax.drivebetter.profile.domain

import androidx.annotation.FloatRange
import com.matttax.drivebetter.network.model.ProfileData

data class Account(
    val id: String,
    val name: String? = null,
    val age: Int? = null,
    val gender: Gender? = null,
    val city: String? = null,
    val avatarUri: String? = null,
    val driversLicenseId: String? = null,
    @FloatRange(0.0, 10.0) val rating: Double? = null
)

fun Account.toProfileData(): ProfileData {
    return ProfileData(
        uuid = id,
        age = age ?: 0,
        sex = gender.asString(),
        licenceNumber = driversLicenseId ?: "null"
    )
}
