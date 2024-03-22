//
//  ProfileEditingViewInput.swift
//  TinkoffApp
//
//  Created by Станислава on 11.03.2024.
//

import Foundation

protocol ProfileEditingViewInput: AnyObject {
    func updateProfileData(with profileModel: UserProfileViewModel)
    func changeEnableForSaving(_ isSaving: Bool)
    func showSucsessAlert()
    func showErrorAlert()
    func showPhotoAlert()
    func enableEditing()
    func disableEditing()
}
