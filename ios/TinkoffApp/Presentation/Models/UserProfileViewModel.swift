//
//  UserProfileViewModel.swift
//  TinkoffApp
//
//  Created by Станислава on 11.03.2024.
//

import UIKit

struct UserProfileViewModel: Codable {
    let userName: String?
    let userDescription: String?
    let userAvatar: Data?
    let age: String?
    let licenceNumber: String?
    let sex: String?
}
