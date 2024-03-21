package com.matttax.drivebetter.ui.utils

import android.text.format.DateFormat
import android.text.format.DateUtils
import java.util.concurrent.TimeUnit

object ClockUtils {

    fun getTimeFromMillis(duration: Long): String {
        if (duration <= 0L)
            return ZERO_TIME
        return getTimeFromSecs(TimeUnit.MILLISECONDS.toSeconds(duration))
    }

    fun getRelativeTime(timeInMillis: Long): String {
        val relativeTimeSpanString: CharSequence? = DateUtils.getRelativeTimeSpanString(
            timeInMillis,
            System.currentTimeMillis(),
            DateUtils.FORMAT_SHOW_TIME.toLong()
        )
        return relativeTimeSpanString?.toString() ?: ""
    }

    fun getTimeFromDate(timeInMillis: Long): String {
        return DateFormat.format("hh:mm aa", timeInMillis).toString()
    }

    private fun getTimeFromSecs(duration: Long): String {
        return DateUtils.formatElapsedTime(duration)
    }

    private const val ZERO_TIME = "00:00"
}
