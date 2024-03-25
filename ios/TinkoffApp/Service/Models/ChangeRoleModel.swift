//
//  ChangeRoleModel.swift
//  TinkoffApp
//
//  Created by Станислава on 22.03.2024.
//

import Foundation

enum Role: String {
    case driver = "водитель"
    case passenger = "пассажир"
}

struct ChangeRoleModel: Codable {
    let uuid: String
    let rideId: Int
    let selectedRole: String
    
    enum CodingKeys: String, CodingKey {
        case uuid = "uuid"
        case rideId = "ride_id"
        case selectedRole = "selected_role"
    }
}
