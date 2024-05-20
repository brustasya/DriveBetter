//
//  MainScreenPresenter.swift
//  TinkoffApp
//
//  Created by Станислава on 08.02.2024.
//

import Foundation
import UIKit

final class MainScreenPresenter {
    weak var viewInput: MainScreenViewInput?
    weak var moduleOutput: MainScreenModuleOutput?
    
    let uuid = UIDevice.current.identifierForVendor?.uuidString ?? "\(UUID())"
    
    private let telemetryServiceProtocol: TelemetryServiceProtocol
    private var trips: [TripModel] = []
//            TripModel(rideID: 0, date: Date(), endTimestamp: Date(), city: "Москва", rating: 7.7, isDriver: true, maxSpeed: 120, averageSpeed: 60, nightTime: 20, lightNightTime: 80, weather: [ WeatherModel(date: Date(), visibility: 1000, weaterType: .sun) ], overSdeeds: [ SpeedModel(speed: 90, timestamp: Date(), address: "г Москва, ул Сухонская, д 11") ], accelerations: [ DangerousDrivingModel(date: Date(), acceleration: 10, address: "г Москва, ул Сухонская, д 11") ]),
//            TripModel(rideID: 1, date: Date(), endTimestamp: Date(), city: "Москва", rating: 5.1, isDriver: true, maxSpeed: 120, averageSpeed: 60, nightTime: 20, lightNightTime: 80, weather: [
//                WeatherModel(date: Date(), visibility: 100, weaterType: .fog),
//                WeatherModel(date: Calendar.current.date(byAdding: .hour, value: 1, to: Date.now) ?? Date(), visibility: 1000, weaterType: .sun),
//                WeatherModel(date: Calendar.current.date(byAdding: .hour, value: 3, to: Date.now) ?? Date(), visibility: 300, weaterType: .rain)
//            ], overSdeeds: [
//                SpeedModel(speed: 45, timestamp: Date(), address: "ул. Вавилова, д. 46"),
//                SpeedModel(speed: 62, timestamp: Calendar.current.date(byAdding: .hour, value: 3, to: Date.now) ?? Date(), address: "ул. Большая Полянка, д. 1/3"),
//                SpeedModel(speed: 120, timestamp: Calendar.current.date(byAdding: .hour, value: 5, to: Date.now) ?? Date(), address: "ул. Бутлерова, д. 4"),
//            ], accelerations: [
//                DangerousDrivingModel(date: Date(), acceleration: 20, address: "ул. Вавилова, д. 46"),
//                DangerousDrivingModel(date: Calendar.current.date(byAdding: .hour, value: 1, to: Date.now) ?? Date(), acceleration: -20, address: "ул. Бутлерова, д. 4"),
//                DangerousDrivingModel(date: Calendar.current.date(byAdding: .hour, value: 4, to: Date.now) ?? Date(), acceleration: 20, address: "ул. Большая Полянка, д. 1/3"),
//            ]),
//            TripModel(rideID: 2, date: Date(), endTimestamp: Date(), city: "Москва", rating: 7.7, isDriver: false, maxSpeed: 120, averageSpeed: 60, nightTime: 20, lightNightTime: 80, weather: [ WeatherModel(date: Date(), visibility: 1000, weaterType: .sun) ], overSdeeds: [ SpeedModel(speed: 90, timestamp: Date(), address: "г Москва, ул Сухонская, д 11") ], accelerations: [ DangerousDrivingModel(date: Date(), acceleration: 10, address: "г Москва, ул Сухонская, д 11") ]),
//            TripModel(rideID: 2, date: Date(), endTimestamp: Date(), city: "Москва", rating: 7.7, isDriver: true, maxSpeed: 120, averageSpeed: 60, nightTime: 20, lightNightTime: 80, weather: [ WeatherModel(date: Date(), visibility: 1000, weaterType: .sun) ], overSdeeds: [], accelerations: [ DangerousDrivingModel(date: Date(), acceleration: 10, address: "г Москва, ул Сухонская, д 11") ]),
//            TripModel(rideID: 2, date: Date(), endTimestamp: Date(), city: "Москва", rating: 7.7, isDriver: true, maxSpeed: 120, averageSpeed: 60, nightTime: 20, lightNightTime: 80, weather: [], overSdeeds: [ SpeedModel(speed: 90, timestamp: Date(), address: "г Москва, ул Сухонская, д 11") ], accelerations: [ DangerousDrivingModel(date: Date(), acceleration: 10, address: "г Москва, ул Сухонская, д 11") ]),
//            TripModel(rideID: 2, date: Date(), endTimestamp: Date(), city: "Москва", rating: 7.7, isDriver: true, maxSpeed: 120, averageSpeed: 60, nightTime: 20, lightNightTime: 80, weather: [ WeatherModel(date: Date(), visibility: 1000, weaterType: .sun) ], overSdeeds: [ SpeedModel(speed: 90, timestamp: Date(), address: "г Москва, ул Сухонская, д 11") ], accelerations: [])
//        ]
    
    init(
        moduleOutput: MainScreenModuleOutput,
        telemetryServiceProtocol: TelemetryServiceProtocol
    ) {
        self.moduleOutput = moduleOutput
        self.telemetryServiceProtocol = telemetryServiceProtocol
    }
   
    private func getRating(id: Int) -> Double {
        switch id {
        case 0:
            return 5.1
        case 1:
            return 5.4
        case 2:
            return 9.1
        case 3:
            return 7.2
        case 4:
            return 9.8
        case 5:
            return 9.9
        case 6:
            return 9.7
        case 7:
            return 9.9
        default:
            return 7.3
        }
    }
    
    private func getTrips() {
        telemetryServiceProtocol.getTrips() { [weak self] result in
            switch result {
            case .success(let trips):
                self?.trips = trips.compactMap { TripModel(
                    rideID: $0.rideID,
                    date: Date(timeIntervalSince1970:  TimeInterval($0.startTimestamp)),
                    endTimestamp: Date(timeIntervalSince1970:  TimeInterval($0.endTimestamp)),
                    city: $0.address["address_region"] ?? "",
                    rating: self?.getRating(id: $0.rideID) ?? 7.0,
                    isDriver: ($0.selectedRole ?? $0.detectedRole) == "водитель",
                    maxSpeed: Int($0.maxSpeed),
                    averageSpeed: Int($0.maxSpeed / 2.5),
                    nightTime: Int($0.nighttime),
                    lightNightTime: Int($0.lightNighttime),
                    weather: $0.weather.compactMap { WeatherModel(
                        date: Date(timeIntervalSince1970:  TimeInterval($0.timestamp)),
                        visibility: $0.visibility,
                        weaterType: WeatherType(value: $0.weatherCode) ?? .sun
                    )},
                    overSdeeds: $0.speeding.compactMap { SpeedModel(
                        speed: Int($0.speed),
                        timestamp: Date(timeIntervalSince1970:  TimeInterval($0.timestamp)),
                        address: $0.address["short"] ?? ""
                    )},
                    accelerations: $0.dangerousAccelerations.compactMap { DangerousDrivingModel(
                        date: Date(timeIntervalSince1970:  TimeInterval($0.timestamp)),
                        acceleration: $0.acceleration,
                        address: $0.address["short"] ?? ""
                    )}
                )}
                DispatchQueue.main.async {
                    self?.viewInput?.applySnapshot(tripModels: self?.trips ?? [])
                    self?.viewInput?.stopRefreshing()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MainScreenPresenter: MainScreenViewOutput {
    func viewWillAppear() {
        getTrips()
    }
    
    func tripDidSelect(model: TripModel) {
        moduleOutput?.moduleWantsToOpenTrip(with: model)
    }
}

