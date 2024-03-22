//
//  ProfileEditingViewOutput.swift
//  TinkoffApp
//
//  Created by Станислава on 11.03.2024.
//

import Foundation

protocol ProfileEditingViewOutput: AnyObject {
    func viewIsReady()
    func saveButtonTapped(profileModel: UserProfileViewModel)
    func addPhotoButtonTapped()
    func cancelButtonTapped()
    func stopEditing()
}
