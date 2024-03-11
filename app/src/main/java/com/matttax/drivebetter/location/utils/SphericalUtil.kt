package com.matttax.drivebetter.location.utils

import com.matttax.drivebetter.location.data.model.LocationPoint

object SphericalUtil {
    /**
     * Wraps the given value into the inclusive-exclusive interval between min and max.
     *
     * @param n   The value to wrap.
     * @param min The minimum.
     * @param max The maximum.
     */
    fun wrap(n: Double, min: Double, max: Double): Double {
        return if (n >= min && n < max) n else mod(n - min, max - min) + min
    }

    /**
     * Returns the non-negative remainder of x / m.
     *
     * @param x The operand.
     * @param m The modulus.
     */
    fun mod(x: Double, m: Double): Double {
        return (x % m + m) % m
    }

    /**
     * Returns the heading from one _root_ide_package_.com.matttax.drivebetter.location.data.model.LocationPoint to another _root_ide_package_.com.matttax.drivebetter.location.data.model.LocationPoint. Headings are
     * expressed in degrees clockwise from North within the range [-180,180).
     *
     * @return The heading in degrees clockwise from north.
     */
    fun computeHeading(from: LocationPoint, to: LocationPoint): Double {
        // http://williams.best.vwh.net/avform.htm#Crs
        val fromLat = Math.toRadians(from.latitude)
        val fromLng = Math.toRadians(from.longitude)
        val toLat = Math.toRadians(to.latitude)
        val toLng = Math.toRadians(to.longitude)
        val dLng = toLng - fromLng
        val heading = Math.atan2(
            Math.sin(dLng) * Math.cos(toLat),
            Math.cos(fromLat) * Math.sin(toLat) - Math.sin(fromLat) * Math.cos(toLat) * Math.cos(
                dLng
            )
        )
        return wrap(Math.toDegrees(heading), -180.0, 180.0)
    }

    /**
     * Returns the distance between two LocationPoints, in meters.
     */
    fun computeDistanceBetween(from: LocationPoint, to: LocationPoint): Double {
        return computeAngleBetween(from, to) * EARTH_RADIUS
    }

    /**
     * The earth's radius, in meters.
     * Mean radius as defined by IUGG.
     */
    const val EARTH_RADIUS = 6371009.0

    /**
     * Returns the angle between two _root_ide_package_.com.matttax.drivebetter.location.LocationPoints, in radians.
     */
    fun computeAngleBetween(from: LocationPoint, to: LocationPoint): Double {
        // Haversine's formula
        val fromLat = Math.toRadians(from.latitude)
        val fromLng = Math.toRadians(from.longitude)
        val toLat = Math.toRadians(to.latitude)
        val toLng = Math.toRadians(to.longitude)
        val dLat = fromLat - toLat
        val dLng = fromLng - toLng
        return 2 * Math.asin(
            Math.sqrt(
                Math.pow(Math.sin(dLat / 2), 2.0) +
                        Math.cos(fromLat) * Math.cos(toLat) * Math.pow(Math.sin(dLng / 2), 2.0)
            )
        )
    }
}