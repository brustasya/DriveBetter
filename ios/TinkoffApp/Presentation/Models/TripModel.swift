//
//  TripModel.swift
//  TinkoffApp
//
//  Created by Станислава on 13.03.2024.
//

import Foundation

struct TripModel: Hashable {
    let uuid = UUID()
    let rideID: Int
    let date: Date
    let endTimestamp: Date
    let city: String
    let rating: Double
    let isDriver: Bool
    let maxSpeed: Int
    let averageSpeed: Int
    let nightTime: Int
    let lightNightTime: Int
    let weather: [WeatherModel]
    let overSdeeds: [SpeedModel]
    let accelerations: [DangerousDrivingModel]
}
