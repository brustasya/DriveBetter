//
//  UserProfileDataServiceProtocol.swift
//  TinkoffApp
//
//  Created by Станислава on 11.03.2024.
//

import Foundation
import Combine

protocol UserProfileDataServiceProtocol {
    func saveUserProfile(_ userProfile: UserProfileViewModel, completion: @escaping (Bool) -> Void)
    func loadUserProfile() -> AnyPublisher<UserProfileViewModel?, Never>
    func cancelSave()
}
