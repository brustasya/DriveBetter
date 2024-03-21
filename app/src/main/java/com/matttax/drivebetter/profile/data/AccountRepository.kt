package com.matttax.drivebetter.profile.data

import com.matttax.drivebetter.network.ApiService
import com.matttax.drivebetter.profile.domain.Account
import com.matttax.drivebetter.profile.domain.Gender
import com.matttax.drivebetter.profile.domain.toProfileData
import javax.inject.Inject

class AccountRepository @Inject constructor(
    private val apiService: ApiService,
    private val accountLocalStorage: AccountLocalStorage
) {

    suspend fun createOrUpdate(newAccount: Account) {
        if (accountLocalStorage.userExists()) {
            apiService.createUser(newAccount.toProfileData())
        }
    }

    fun getId(): String {
        return accountLocalStorage.getUserId()
    }

    fun getAccount(): Account {
        return accountLocalStorage.getAccount()
    }

    fun updateAge(age: Int) = accountLocalStorage.updateAge(age)

    fun updateCity(city: String) = accountLocalStorage.updateCity(city)

    fun updateName(name: String) = accountLocalStorage.updateName(name)

    fun updateLicense(licenseId: String) = accountLocalStorage.updateLicense(licenseId)

    fun updateGender(gender: Gender) = accountLocalStorage.updateGender(gender)

    fun updateAvatar(avatarUri: String) = accountLocalStorage.updateAvatar(avatarUri)
}
