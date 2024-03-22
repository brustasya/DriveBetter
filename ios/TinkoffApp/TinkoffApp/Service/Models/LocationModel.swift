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
    let speed: Double
    let timestamp: Date
}
