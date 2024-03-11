package com.matttax.drivebetter.di

import com.matttax.drivebetter.network.ApiHelper
import com.matttax.drivebetter.network.ApiHelperImpl
import dagger.Binds
import dagger.Module
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent

@Module
@InstallIn(SingletonComponent::class)
abstract class NetworkBinder {
    @Binds
    abstract fun bindApiHelper(apiHelperImpl: ApiHelperImpl): ApiHelper
}
