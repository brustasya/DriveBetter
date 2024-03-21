package com.matttax.drivebetter.profile.data

import java.util.*
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class AccountCreator @Inject constructor() {
    fun getNewId() = UUID.randomUUID().toString()
}
