//
//  DashboardPresenter.swift
//  TinkoffApp
//
//  Created by Станислава on 10.03.2024.
//

import Foundation
import Combine
import CoreMotion
import CoreLocation

final class DashboardPresenter {
    weak var viewInput: DashboardViewInput?
    private let telemetryManager: LocationService
    private lazy var cancellables = Set<AnyCancellable>()
    
    init(
        telemetryManager: LocationService
    ) {
        self.telemetryManager = telemetryManager
    }
    
    func updateCurrentSpeed() {
        telemetryManager.configure(desiredAccuracy: kCLLocationAccuracyNearestTenMeters, distanceFilter: 10)
        telemetryManager.currentSpeed.valuePublisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Subscription finished")
                    case .failure(let error):
                        print("Subscription failed with error: \(error)")
                    }
                },
                receiveValue: {[weak self] value in
                    let speed = value >= 0 ? value : 0
                    self?.viewInput?.updateCurrentSpeed(speed: Int(speed))
                })
            .store(in: &cancellables)
    }
    
    func updateAverageSpeed() {
        telemetryManager.averageSpeed.valuePublisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Subscription finished")
                    case .failure(let error):
                        print("Subscription failed with error: \(error)")
                    }
                },
                receiveValue: {[weak self] value in
                    let speed = value >= 0 ? value : 0
                    self?.viewInput?.updateAverageSpeed(speed: Int(speed))
                })
            .store(in: &cancellables)
        
    }
    
    func updateMaxSpeed() {
        telemetryManager.maxSpeed.valuePublisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Subscription finished")
                    case .failure(let error):
                        print("Subscription failed with error: \(error)")
                    }
                },
                receiveValue: {[weak self] value in
                    let speed = value >= 0 ? value : 0
                    self?.viewInput?.updateMaxSpeed(speed: Int(speed))
                })
            .store(in: &cancellables)
    }
}

extension DashboardPresenter: DashboardViewOutput {
    func viewIsReady() {
        updateCurrentSpeed()
        updateMaxSpeed()
        updateAverageSpeed()
    }
}
