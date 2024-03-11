package com.matttax.drivebetter.network

import com.matttax.drivebetter.network.model.Address
import com.matttax.drivebetter.network.model.UserRideBatch
import com.matttax.drivebetter.network.model.UserRideInfo
import kotlinx.coroutines.flow.Flow

interface ApiHelper {
    fun getLocation(userRideInfo: UserRideInfo): Flow<Address>
    fun sendBatch(userRideBatch: UserRideBatch)
}
