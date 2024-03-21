package com.matttax.drivebetter.network

import com.matttax.drivebetter.history.RideHistoryResponse
import com.matttax.drivebetter.network.model.AddressResponse
import com.matttax.drivebetter.network.model.ProfileData
import com.matttax.drivebetter.network.model.UserRideBatch
import com.matttax.drivebetter.network.model.UserRideInfo
import retrofit2.http.*

interface ApiService {

    @POST("/api/location")
    suspend fun getLocation(@Body userRideInfo: UserRideInfo): AddressResponse

    @POST("/api/location/batch")
    suspend fun sendBatch(@Body userRideBatch: UserRideBatch)

    @POST("/api/profile")
    suspend fun createUser(@Body profileData: ProfileData)

    @GET("/api/ride")
    suspend fun getRidesHistory(@Query("uuid") userId: String): RideHistoryResponse

    companion object {
        const val BASE_URL = "http://34.155.177.3:8000/"
    }
}
