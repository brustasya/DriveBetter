//
//  ServerTripsModel.swift
//  TinkoffApp
//
//  Created by Станислава on 22.03.2024.
//

import Foundation

struct ServerTripsModel: Codable {
    let rides: [RideModel]
}

struct RideModel: Codable {
    let rideID: Int
    let uuid: String
    let detectedRole: String
    let selectedRole: String?
    let maxSpeed: Double
    let minSpeed: Double
  //  let averageSpeed: Double
    let speeding: [ServerOverSpeedModel]
    let dangerousAccelerations: [ServerAccelerationModel]
    let dangerousShifts: [ServerShiftsModel]
    let lightNighttime: Double
    let nighttime: Double
    let weather: [ServerWeatherModel]
    let autoStart: Bool
    let autoFinish: Bool
    let address: [String: String]
    let startTimestamp: Int
    let endTimestamp: Int
    
    enum CodingKeys: String, CodingKey {
        case rideID = "ride_id"
        case uuid = "uuid"
        case detectedRole = "detected_role"
        case selectedRole = "selected_role"
        case maxSpeed = "max_speed"
        case minSpeed = "min_speed"
   //     case averageSpeed = "average_speed"
        case speeding = "speeding"
        case dangerousAccelerations = "dangerous_accelerations"
        case dangerousShifts = "dangerous_shifts"
        case lightNighttime = "light_nighttime"
        case nighttime = "nighttime"
        case weather = "weather"
        case autoStart = "auto_start"
        case autoFinish = "auto_finish"
        case address = "address"
        case startTimestamp = "start_timestamp"
        case endTimestamp = "end_timestamp"
    }
}

struct ServerWeatherModel: Codable {
    let timestamp: Int
    let visibility: Double
    let weatherCode: Int
    
    enum CodingKeys: String, CodingKey {
        case timestamp = "timestamp"
        case visibility = "visibility"
        case weatherCode = "weather_code"
    }
}

struct ServerOverSpeedModel: Codable {
    let speed: Double
    let address: [String: String]
    let timestamp: Int
}

struct ServerAccelerationModel: Codable {
    let address: [String: String]
    let timestamp: Int
    let acceleration: Double
}

struct ServerShiftsModel: Codable {
    let address: [String: String]
    let timestamp: Int
    let shiftAngle: Int
    let rateOfAngleChange: Double
    
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case timestamp = "timestamp"
        case shiftAngle = "shift_angle"
        case rateOfAngleChange = "rate_of_angle_change"
    }
}

struct ServerAddressModel: Codable {
    let full: String
    let short: String
    let region: String
    let regionTypeFull: String
    
    enum CodingKeys: String, CodingKey {
        case full = "full"
        case short = "short"
        case region = "region"
        case regionTypeFull = "region_type_full"
    }
}

struct AddressModel: Codable {
    let full: String
    let short: String
    let region: String
    let regionTypeFull: String
    
    enum CodingKeys: String, CodingKey {
        case full = "address_full"
        case short = "address_short"
        case region = "address_region"
        case regionTypeFull = "address_region_type_full"
    }
}

