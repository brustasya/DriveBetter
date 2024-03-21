package com.matttax.drivebetter.profile.domain

enum class Gender {
    MALE,
    FEMALE
}

fun Gender?.asString(): String {
    return when (this) {
        Gender.MALE -> "M"
        Gender.FEMALE -> "F"
        null -> "unknown"
    }
}

fun String?.toGender(): Gender? {
    return when (this) {
        "male", "m", "M" -> Gender.MALE
        "female", "f", "F" -> Gender.FEMALE
        "unknown", "null", null -> null
        else -> throw IllegalArgumentException("\"${this}\" is not a gender")
    }
}
