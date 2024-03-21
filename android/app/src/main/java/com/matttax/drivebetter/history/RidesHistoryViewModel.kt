package com.matttax.drivebetter.history

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.matttax.drivebetter.profile.data.AccountRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.*
import javax.annotation.concurrent.Immutable
import javax.inject.Inject

@HiltViewModel
class RidesHistoryViewModel @Inject constructor(
    private val driveRepository: DriveRepository,
    private val accountRepository: AccountRepository
) : ViewModel() {

    private val _driversRides = MutableStateFlow<List<RideUiModel>>(emptyList())
    val driversRides = _driversRides.asStateFlow()

    private val _passengerRides = MutableStateFlow<List<RideUiModel>>(emptyList())
    val passengerRides = _passengerRides.asStateFlow()

    init {
        driveRepository
            .getRideHistoryById(accountRepository.getId())
            .flowOn(Dispatchers.IO)
            .onEach { list ->
                _driversRides.value = list
                    .filter { it.detectedRole == "driver" }
                    .map { it.toUiModel() } + mockDriversRides
                _passengerRides.value = list
                    .filter { it.detectedRole == "passenger" }
                    .map { it.toUiModel() } + mockPassengerRides
            }.launchIn(viewModelScope)
    }

    companion object {
        val mockDriversRides = listOf(
            RideUiModel(1, "March 20, 2024 16:02", "Moscow", 7.8f),
            RideUiModel(1, "March 20, 2024 16:34", "Moscow", 10f),
            RideUiModel(1, "March 20, 2024 17:12", "Moscow", 5.3f),
            RideUiModel(1, "March 20, 2024 17:20", "Moscow", 6.3f)
        ).reversed()

        val mockPassengerRides = listOf(
            RideUiModel(1, "March 20, 2024 14:12", "Moscow"),
            RideUiModel(1, "March 20, 2024 16:58", "Moscow")
        )
    }
}

fun Ride.toUiModel(): RideUiModel {
    return RideUiModel(
        id = rideId,
        title = "March 20, 2024 16:02",
        location = "Moscow",
        rating = if (detectedRole == "passenger") {
            (3..9).random() + ((1..9).random() / 10f)
        } else null
    )
}

@Immutable
data class RideUiModel(
    val id: Int,
    val title: String,
    val location: String,
    val rating: Float? = null
)
