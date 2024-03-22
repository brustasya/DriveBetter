//
//  ProfileEditingPresenter.swift
//  TinkoffApp
//
//  Created by Станислава on 11.03.2024.
//

import Foundation
import Combine

final class ProfileEditingPresenter {
    weak var viewInput: ProfileEditingViewInput?
    weak var moduleOutput: ProfileEditingModuleOutput?
    weak var delegate: ProfileSaveDelegate?
    
    private let profileService: UserProfileDataServiceProtocol
    private let profileModel: UserProfileViewModel
    private var isEditing: Bool
    
    init(
        profileService: UserProfileDataServiceProtocol,
        moduleOutput: ProfileEditingModuleOutput,
        profileModel: UserProfileViewModel,
        isPhotoAdded: Bool
    ) {
        self.profileService = profileService
        self.moduleOutput = moduleOutput
        self.profileModel = profileModel
        self.isEditing = isPhotoAdded
    }
    
    private func saveProfile(with userProfileModel: UserProfileViewModel) {
        profileService.saveUserProfile(userProfileModel) { [weak self] (isSaved) in
            if isSaved {
                self?.viewInput?.showSucsessAlert()
                self?.delegate?.profileSaved(with: userProfileModel)
            } else {
                self?.viewInput?.showErrorAlert()
            }
            
            self?.viewInput?.changeEnableForSaving(false)
        }
    }
}

extension ProfileEditingPresenter: ProfileEditingViewOutput {
    func viewIsReady() {
        if isEditing {
            viewInput?.enableEditing()
        } else {
            viewInput?.disableEditing()
        }
        viewInput?.updateProfileData(with: profileModel)
    }
    
    func saveButtonTapped(profileModel: UserProfileViewModel) {
        if isEditing {
            viewInput?.changeEnableForSaving(true)
            saveProfile(with: profileModel)
        } else {
            viewInput?.enableEditing()
            isEditing = true
        }
    }
    
    func addPhotoButtonTapped() {
        viewInput?.enableEditing()
        isEditing = true
        viewInput?.showPhotoAlert()
    }
    
    func cancelButtonTapped() {
        if isEditing {
            viewInput?.disableEditing()
            isEditing = false
        } else {
            moduleOutput?.moduleWantsToCloseProfileEditing()
        }
    }
    
    func stopEditing() {
        isEditing = false
    }
}
