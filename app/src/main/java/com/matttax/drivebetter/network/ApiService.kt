package com.matttax.drivebetter.network

import com.matttax.drivebetter.network.model.AddressResponse
import com.matttax.drivebetter.network.model.UserRideBatch
import com.matttax.drivebetter.network.model.UserRideInfo
import retrofit2.http.*

interface ApiService {

    @POST("/api/location")
    suspend fun getLocation(@Body userRideInfo: UserRideInfo): AddressResponse

    @POST("/api/location/batch")
    suspend fun sendBatch(@Body userRideBatch: UserRideBatch)
}
