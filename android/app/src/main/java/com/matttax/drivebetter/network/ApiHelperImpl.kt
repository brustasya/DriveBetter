package com.matttax.drivebetter.network

import com.matttax.drivebetter.history.Ride
import com.matttax.drivebetter.network.model.Address
import com.matttax.drivebetter.network.model.UserRideBatch
import com.matttax.drivebetter.network.model.UserRideInfo
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import javax.inject.Inject

class ApiHelperImpl @Inject constructor(
    private val apiService: ApiService
): ApiHelper {

    override fun getLocation(userRideInfo: UserRideInfo): Flow<Address> {
        return flow { emit(apiService.getLocation(userRideInfo).address) }
    }

    override fun getRidesHistory(userId: String): Flow<List<Ride>> {
//        return flow { emit(apiService.getRidesHistory(userId).rides) }
        return flow { emit(emptyList()) }
    }

    override fun sendBatch(userRideBatch: UserRideBatch) {
        TODO("Not yet implemented")
    }
}
