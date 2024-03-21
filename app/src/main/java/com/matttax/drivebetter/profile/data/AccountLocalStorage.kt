package com.matttax.drivebetter.profile.data

import android.content.Context
import com.matttax.drivebetter.profile.domain.Account
import com.matttax.drivebetter.profile.domain.Gender
import com.matttax.drivebetter.profile.domain.asString
import com.matttax.drivebetter.profile.domain.toGender
import dagger.hilt.android.qualifiers.ApplicationContext
import javax.inject.Inject

class AccountLocalStorage @Inject constructor(
    @ApplicationContext context: Context,
    private val accountCreator: AccountCreator
) {

    private val sharedPrefs = context.getSharedPreferences(ACCOUNT_STORAGE_NAME, Context.MODE_PRIVATE)

    fun userExists(): Boolean {
        return sharedPrefs.getString(ACCOUNT_ID_KEY, null) == null
    }

    fun getUserId(): String {
        val currentID = sharedPrefs.getString(ACCOUNT_ID_KEY, null)
        return currentID ?: accountCreator.getNewId().also {
            updateId(it)
        }
    }

    fun getAccount(): Account {
        return Account(
            id = getUserId(),
            name = sharedPrefs.getString(NAME_KEY, null),
            city = sharedPrefs.getString(CITY_KEY, null),
            age = sharedPrefs.getInt(AGE_KEY, -1).takeIf { it != -1 },
            gender = sharedPrefs.getString(GENDER_KEY, null).toGender(),
            driversLicenseId = sharedPrefs.getString(LICENSE_KEY, null),
            avatarUri = sharedPrefs.getString(AVATAR_URI_KEY, null)
        )
    }

    fun updateAge(age: Int) {
        sharedPrefs.edit().putInt(AGE_KEY, age).apply()
    }

    fun updateCity(city: String) {
        sharedPrefs.edit().putString(CITY_KEY, city).apply()
    }

    fun updateName(name: String) {
        sharedPrefs.edit().putString(NAME_KEY, name).apply()
    }

    fun updateLicense(licenseId: String) {
        sharedPrefs.edit().putString(LICENSE_KEY, licenseId).apply()
    }

    fun updateGender(gender: Gender) {
        sharedPrefs.edit().putString(GENDER_KEY, gender.asString()).apply()
    }

    fun updateAvatar(avatarUri: String) {
        sharedPrefs.edit().putString(AVATAR_URI_KEY, avatarUri).apply()
    }

    private fun updateId(newId: String) {
        sharedPrefs.edit().putString(ACCOUNT_ID_KEY, newId).apply()
    }

    companion object {
        const val ACCOUNT_STORAGE_NAME = "account_storage"
        const val ACCOUNT_ID_KEY = "account_id"
        const val NAME_KEY = "name"
        const val AGE_KEY = "age"
        const val GENDER_KEY = "gender"
        const val LICENSE_KEY = "license"
        const val CITY_KEY = "city"
        const val AVATAR_URI_KEY = "avatar"
    }
}
