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
    
    init(
        moduleOutput: MainScreenModuleOutput,
        telemetryServiceProtocol: TelemetryServiceProtocol
    ) {
        self.moduleOutput = moduleOutput
        self.telemetryServiceProtocol = telemetryServiceProtocol
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
                    rating: 9.1,
                    isDriver: $0.detectedRole == "водитель",
                    maxSpeed: Int($0.maxSpeed),
                    averageSpeed: Int($0.minSpeed),
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

