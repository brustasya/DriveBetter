//
//  ServerProfileModel.swift
//  TinkoffApp
//
//  Created by Станислава on 22.03.2024.
//

import Foundation

struct ServerProfileModel: Codable {
    let uuid: String
    let age: Int
    let licenceNumber: String
    let sex: String
    
    enum CodingKeys: String, CodingKey {
        case uuid = "uuid"
        case age = "age"
        case licenceNumber = "licence_number"
        case sex = "sex"
    }
}
