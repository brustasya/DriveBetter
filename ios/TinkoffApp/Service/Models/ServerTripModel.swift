//
//  TripModel.swift
//  TinkoffApp
//
//  Created by Станислава on 22.03.2024.
//

import Foundation

struct ServerTripModel: Codable {
    let uuid: String
    let autoStart: Bool
    let autoFinish: Bool
    let points: [LocationModel]
    
    enum CodingKeys: String, CodingKey {
        case uuid = "uuid"
        case autoStart = "auto_start"
        case autoFinish = "auto_finish"
        case points = "points"
    }
}
