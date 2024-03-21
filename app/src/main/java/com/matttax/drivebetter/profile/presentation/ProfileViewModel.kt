package com.matttax.drivebetter.profile.presentation

import android.net.Uri
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.matttax.drivebetter.profile.data.AccountRepository
import com.matttax.drivebetter.profile.domain.Gender
import com.matttax.drivebetter.profile.data.IconRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class ProfileViewModel @Inject constructor(
    private val accountRepository: AccountRepository,
    private val iconRepository: IconRepository
) : ViewModel() {

    private val _account = MutableStateFlow(accountRepository.getAccount())
    val account = _account.asStateFlow()

    init {
        _account
            .onEach { updateUser() }
            .launchIn(viewModelScope)
    }

    fun onAgeUpdated(age: Int) {
        accountRepository.updateAge(age)
        _account.update { it.copy(age = age) }
    }

    fun onCityUpdated(city: String) {
        accountRepository.updateCity(city)
        _account.update { it.copy(city = city) }
    }

    fun onNameUpdated(name: String) {
        accountRepository.updateName(name)
        _account.update { it.copy(name = name) }
    }

    fun onLicenseUpdated(licenseId: String) {
        accountRepository.updateLicense(licenseId)
        _account.update { it.copy(driversLicenseId = licenseId) }
    }

    fun onGenderUpdated(gender: Gender) {
        accountRepository.updateGender(gender)
        _account.update { it.copy(gender = gender) }
    }

    fun onAvatarUpdated(avatarUri: Uri) {
        iconRepository.saveToInternalStorage(avatarUri, _account.value.id, _account.value.avatarUri)?.let { uri ->
            accountRepository.updateAvatar(uri)
            _account.update { it.copy(avatarUri = uri) }
        }
    }

    private fun updateUser() {
        viewModelScope.launch(Dispatchers.IO) {
            accountRepository.createOrUpdate(_account.value)
        }
    }
}
