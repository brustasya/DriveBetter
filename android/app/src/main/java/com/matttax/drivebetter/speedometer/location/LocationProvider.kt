package com.matttax.drivebetter.speedometer.location

import android.annotation.SuppressLint
import android.content.Context
import android.location.GnssStatus
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Handler
import android.os.Looper
import dagger.hilt.android.qualifiers.ApplicationContext
import javax.inject.Inject

class LocationProvider @Inject constructor(
    @ApplicationContext context: Context
) : LocationListener, GnssStatus.Callback() {

    private val locationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager

    private var locationChangeCallback: (Location) -> Unit = {}
    private var gpsSignalCallback: (signalStrength: Int) -> Unit = {}
    private var startTime = System.currentTimeMillis()
    private var currentGPSStrength = 0

    override fun onLocationChanged(location: Location) {
        if (location.time >= startTime && currentGPSStrength != 0 && location.isValid) {
            locationChangeCallback(location)
        }
    }

    @SuppressLint("MissingPermission")
    fun subscribe(
        locationChangeCallback: (Location) -> Unit,
        gpsSignalCallback: (gpsSignalStrength: Int) -> Unit
    ) {
        this.locationChangeCallback = locationChangeCallback
        this.gpsSignalCallback = gpsSignalCallback
        startTime = System.currentTimeMillis()
        locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 100, 0F, this)
        locationManager.registerGnssStatusCallback(
            this,
            Handler(Looper.getMainLooper())
        )
    }

    fun unsubscribe() {
        this.locationChangeCallback = {}
        locationManager.removeUpdates(this)
    }

    override fun onSatelliteStatusChanged(status: GnssStatus) {
        super.onSatelliteStatusChanged(status)
        status.let { gnsStatus ->
            val totalSatellites = gnsStatus.satelliteCount
            if (totalSatellites > 0) {
                var satellitesFixed = 0
                for (i in 0 until totalSatellites) {
                    if (gnsStatus.usedInFix(i)) {
                        satellitesFixed++
                    }
                }
                currentGPSStrength = (satellitesFixed * 100) / totalSatellites
                gpsSignalCallback(currentGPSStrength)
            }
        }
    }
}
