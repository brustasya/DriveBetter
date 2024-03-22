//
//  ProfileSaveDelegate.swift
//  TinkoffApp
//
//  Created by Станислава on 11.03.2024.
//

import Foundation

protocol ProfileSaveDelegate: AnyObject {
    func profileSaved(with profileModel: UserProfileViewModel)
}
