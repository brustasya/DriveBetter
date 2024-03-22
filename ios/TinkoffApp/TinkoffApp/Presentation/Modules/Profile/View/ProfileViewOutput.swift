//
//  ProfileViewOutput.swift
//  TinkoffApp
//
//  Created by Станислава on 10.03.2024.
//

import Foundation

protocol ProfileViewOutput: AnyObject {
    func viewIsReady()
    func addPhotoButtonTapped(with delegate: ProfileSaveDelegate?)
    func editButtonTapped(with delegate: ProfileSaveDelegate?)
    func openRating()
    func update(with profileModel: UserProfileViewModel)
}
