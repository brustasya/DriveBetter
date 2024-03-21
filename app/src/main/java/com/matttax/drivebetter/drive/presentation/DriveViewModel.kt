package com.matttax.drivebetter.drive.presentation

import androidx.lifecycle.ViewModel
import com.matttax.drivebetter.speedometer.model.CurrentDriveStatus
import com.matttax.drivebetter.speedometer.model.DashboardData
import com.matttax.drivebetter.drive.AddressRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.*
import javax.inject.Inject

@HiltViewModel
class DriveViewModel @Inject constructor(
    private val addressRepository: AddressRepository,
) : ViewModel() {

    private val _dashboard = MutableStateFlow(DashboardUiModel())
    val dashboard = _dashboard.asStateFlow()

    private val _drivingState = MutableStateFlow(DrivingState.INACTIVE)
    val drivingState = _drivingState.asStateFlow()

    private val _gpsSignalStrengthPercentage = MutableStateFlow(0)
    val gpsSignalStrengthPercentage = _gpsSignalStrengthPercentage.asStateFlow()

    private val _drivingCommandSingleEvent = Channel<DrivingCommand>()
    val drivingCommand = _drivingCommandSingleEvent.receiveAsFlow()

    fun updateDashboardData(dashboardData: DashboardData) {
        _dashboard.value = DashboardUiModel(
            currentSpeed = dashboardData.currentSpeedKph,
            averageSpeed = dashboardData.averageSpeedKph,
            maxSpeed = dashboardData.maxSpeedKph,
            distanceKm = dashboardData.distanceKm,
            timeActiveMs = dashboardData.timeMs
        )
        _drivingState.value = when (dashboardData.rideStatus) {
            CurrentDriveStatus.STARTING, CurrentDriveStatus.STARTED -> DrivingState.STARTED
            CurrentDriveStatus.PAUSED -> DrivingState.PAUSED
            else -> DrivingState.INACTIVE
        }
        _gpsSignalStrengthPercentage.value = dashboardData.gpsStrengthPercentage
    }

    fun startDrive() {
        _drivingCommandSingleEvent.trySend(DrivingCommand.START)
        _drivingState.value = DrivingState.STARTED
    }

    fun pauseDrive() {
        _drivingCommandSingleEvent.trySend(DrivingCommand.PAUSE)
        _drivingState.value = DrivingState.PAUSED
    }

    fun stopDrive() {
        _drivingCommandSingleEvent.trySend(DrivingCommand.STOP)
        _drivingState.value = DrivingState.INACTIVE
    }
}

enum class DrivingCommand {
    START,
    PAUSE,
    STOP
}

enum class DrivingState {
    STARTED,
    PAUSED,
    INACTIVE
}

data class DashboardUiModel(
    val currentSpeed: Double = 0.0,
    val averageSpeed: Double = 0.0,
    val maxSpeed: Double = 0.0,
    val distanceKm: Double = 0.0,
    val timeActiveMs: Long = 0
)
