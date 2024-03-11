package com.matttax.drivebetter.location.utils

import android.icu.text.DecimalFormat
import android.icu.text.MeasureFormat
import android.icu.util.Measure
import android.icu.util.MeasureUnit
import java.util.*

private const val KM_MULT = 3.6
private const val SECONDS_HOUR_MULT = 0.000277778
private const val METRE_KM = 0.001
private const val METRE_MILES = 0.000621371

object ConversionUtil {

    private val decimalFormatter = MeasureFormat.getInstance(
        Locale.getDefault(),
        MeasureFormat.FormatWidth.SHORT,
        DecimalFormat("#.#")
    )
    private val normalFormatter = MeasureFormat.getInstance(
        Locale.getDefault(),
        MeasureFormat.FormatWidth.SHORT,
        DecimalFormat("#")
    )

    fun getDistanceUnit(): String =
        decimalFormatter.format(Measure(0, MeasureUnit.KILOMETER)).replace("0", "").trim()

    fun getSpeedUnit(): String =
        normalFormatter.format(Measure(0, MeasureUnit.KILOMETER_PER_HOUR)).replace("0", "").trim()

    fun getDistance(metre: Double): String =
        roundDouble(convertToKm(metre)).toString()

    fun getSpeed(metrePerSecond: Double): Double =
        convertToKmPerHr(metrePerSecond).toInt().toDouble()

    fun getDistanceWithUnit(metre: Double): String =
        decimalFormatter.format(Measure(convertToKm(metre), MeasureUnit.KILOMETER))

    fun getSpeedWithUnit(metrePerSecond: Double): String =
        normalFormatter.format(
            Measure(
                convertToKmPerHr(metrePerSecond),
                MeasureUnit.KILOMETER_PER_HOUR
            )
        )

    fun getSpeedStr(
        metrePerSecond: Double
    ): String {
        val speed: Double = getSpeed(metrePerSecond)
        return speed.toInt().toString()
    }

    fun convertToHour(sec: Double): Double {
        return if (sec > 0.2) {
            sec * SECONDS_HOUR_MULT
        } else 0.0
    }

    private fun convertToKm(metre: Double): Double {
        return if (metre > 10) {
            metre * METRE_KM
        } else 0.0
    }

    private fun convertToMiles(metre: Double): Double {
        return if (metre > 20) {
            metre * METRE_MILES
        } else 0.0
    }

    private fun convertToKmPerHr(metrePerSec: Double): Double {
        return if (metrePerSec > 0.3) {
            metrePerSec * KM_MULT
        } else 0.0
    }

    private fun roundDouble(value: Double) = DecimalFormat("#.#").format(value)

}
