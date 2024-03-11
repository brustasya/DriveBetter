package com.matttax.drivebetter.location.calculation

import javax.inject.Inject

class PauseCalculator @Inject constructor() {

    private var pausedTime: Long = 0
    private var lastPausedTime: Long = 0

    fun onPause() {
        this.lastPausedTime = System.currentTimeMillis()
    }

    fun considerPingForStopPause(pingTime: Long): Boolean {
        if (lastPausedTime > 0) {
            pausedTime += pingTime - lastPausedTime
            lastPausedTime = 0
            return true
        }
        return false
    }

    fun getPausedTime(pingTime: Long): Long {
        if (lastPausedTime > 0) {
            return pausedTime + (pingTime - lastPausedTime)
        }

        return pausedTime
    }
}
