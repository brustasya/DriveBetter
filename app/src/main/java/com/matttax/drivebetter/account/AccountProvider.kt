package com.matttax.drivebetter.account

import android.content.Context
import dagger.hilt.android.qualifiers.ApplicationContext
import javax.inject.Inject

class AccountProvider @Inject constructor(
    @ApplicationContext context: Context,
    private val accountCreator: AccountCreator
) {

    private val sharedPrefs = context.getSharedPreferences(ACCOUNT_STORAGE_NAME, Context.MODE_PRIVATE)

    fun getUserId(): String {
        val currentID = sharedPrefs.getString(ACCOUNT_ID_KEY, null)
        return currentID ?: accountCreator.getNewId().also {
            updateId(it)
        }
    }

    private fun updateId(newId: String) {
        sharedPrefs.edit().putString(ACCOUNT_ID_KEY, newId).apply()
    }

    companion object {
        const val ACCOUNT_STORAGE_NAME = "account_storage"
        const val ACCOUNT_ID_KEY = "account_id"
    }
}
