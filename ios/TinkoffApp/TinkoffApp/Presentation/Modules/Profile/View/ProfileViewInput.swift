//
//  ProfileViewInput.swift
//  TinkoffApp
//
//  Created by Станислава on 10.03.2024.
//

import Foundation

protocol ProfileViewInput: AnyObject {
    func updateProfile(with model: UserProfileViewModel)
}
