//
//  LocationModel.swift
//  TinkoffApp
//
//  Created by Станислава on 12.03.2024.
//

import Foundation

struct LocationModel: Codable {
    let latitude: Double
    let longitude: Double
    let speed: Int
    let timestamp: Int
    let movementAngle: Int
    
    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
        case speed = "speed"
        case timestamp = "timestamp"
        case movementAngle = "movement_angle"
    }
}
