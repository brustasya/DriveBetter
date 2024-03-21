package com.matttax.drivebetter.speedometer.location

import android.location.Location

val Location.isValid: Boolean
    get() = 0 < accuracy && accuracy <= 20
