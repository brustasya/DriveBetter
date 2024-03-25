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
    private var profileModel: UserProfileViewModel
    private var isEditing: Bool
    
    private let telemetryService: TelemetryServiceProtocol
    
    init(
        profileService: UserProfileDataServiceProtocol,
        telemetryService: TelemetryServiceProtocol,
        moduleOutput: ProfileEditingModuleOutput,
        profileModel: UserProfileViewModel,
        isPhotoAdded: Bool
    ) {
        self.profileService = profileService
        self.telemetryService = telemetryService
        self.moduleOutput = moduleOutput
        self.profileModel = profileModel
        self.isEditing = isPhotoAdded
    }
    
    private func saveProfile(with userProfileModel: UserProfileViewModel) {
        profileService.saveUserProfile(userProfileModel) { [weak self] (isSaved) in
            if isSaved {
                self?.viewInput?.showSucsessAlert()
                self?.delegate?.profileSaved(with: userProfileModel)
                self?.profileModel = userProfileModel
                self?.sendProfile()
            } else {
                self?.viewInput?.showErrorAlert()
            }
            
            self?.viewInput?.changeEnableForSaving(false)
        }
    }
    
    private func sendProfile() {
        telemetryService.createProile(with: ServerProfileModel(
            uuid: UserID.uuid,
            age: Int(profileModel.age ?? "0") ?? 0,
            licenceNumber: profileModel.licenceNumber ?? "",
            sex: profileModel.sex ?? ""
        )) { result in
            switch result {
            case .success(_):
                print("Send profile success")
            case .failure(let failure):
                print(failure)
            }
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
            viewInput?.updateProfileData(with: profileModel)
        } else {
            moduleOutput?.moduleWantsToCloseProfileEditing()
        }
    }
    
    func stopEditing() {
        isEditing = false
    }
}
