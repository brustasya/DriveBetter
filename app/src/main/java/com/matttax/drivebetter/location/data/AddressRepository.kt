package com.matttax.drivebetter.location.data

import com.matttax.drivebetter.network.model.Address
import com.matttax.drivebetter.network.model.UserRideInfo
import com.matttax.drivebetter.network.ApiHelper
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject

class AddressRepository @Inject constructor(
    private val apiHelper: ApiHelper
) {
    fun getAddress(userRideInfo: UserRideInfo): Flow<Address> {
        return apiHelper.getLocation(userRideInfo)
    }
}
