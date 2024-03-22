//
//  ProfileModuleOutput.swift
//  TinkoffApp
//
//  Created by Станислава on 10.03.2024.
//

import Foundation

protocol ProfileModuleOutput: AnyObject {
    func moduleWantsToOpenProfileEditing(
        with profileModel: UserProfileViewModel,
        isPhotoAdded: Bool,
        delegate: ProfileSaveDelegate?
    )
    
    func moduleWantsToOpenRating()
}
