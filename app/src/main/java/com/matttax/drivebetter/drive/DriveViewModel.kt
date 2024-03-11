package com.matttax.drivebetter.drive

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.matttax.drivebetter.network.model.Address
import com.matttax.drivebetter.location.data.AddressRepository
import com.matttax.drivebetter.network.model.UserRideInfo
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.*
import javax.inject.Inject

@HiltViewModel
class DriveViewModel @Inject constructor(
    private val addressRepository: AddressRepository
) : ViewModel() {

    private val _location = MutableStateFlow<Address?>(null)
    val location get() = _location.asStateFlow()

    init {
        addressRepository.getAddress(
            UserRideInfo(
                uuid = "1",
                latitude = 55.5945159f,
                longitude = 37.5439955f,
                speed = 100f
            )
        // {"latitude":55.5945159,"longitude":37.5439955,"speed":100.0,"uuid":"1"}
        ).flowOn(Dispatchers.IO).onEach {
            _location.value = it
        }.launchIn(viewModelScope)
    }
}
