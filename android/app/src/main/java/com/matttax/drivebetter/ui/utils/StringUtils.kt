package com.matttax.drivebetter.ui.utils

object StringUtils {

    fun getButtonText(isRinding: Boolean): String {
        return if (isRinding) "Finish ride" else "Start ride"
    }
}
