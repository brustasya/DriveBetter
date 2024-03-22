//
//  TelemetryManager.swift
//  TinkoffApp
//
//  Created by Станислава on 19.12.2023.
//

import Foundation
import CoreLocation
import CoreMotion

import UIKit

// гироскоп: углы поворота
// скидовать показания гироскопа

class TelemetryManager: NSObject, CLLocationManagerDelegate {

    public var currentSpeed: ObservableVariable<Double> = ObservableVariable(0.0)
    private let locationManager = CLLocationManager()
    private let motionManager = CMMotionActivityManager()
    private var isMoving = false
    private var lastLocation: CLLocation?
    private(set) var totalDistance = 0.0 // Общая пройденная дистанция в метрах

    // Время начала и конца движения
    private var startTime: Date?
    private var endTime: Date?

    // Общее время поездки в секундах
    var totalTripTime: TimeInterval {
        guard let startTime = startTime,
              let endTime = endTime else {
            return 0
        }
        return endTime.timeIntervalSince(startTime)
    }

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = false
        motionManager.startActivityUpdates(to: .main, withHandler: { [weak self] activity in
            activity?.automotive
            //self?.setActiveMode(activity?.cycling ?? false)
        })
    }

    func requestLocationPermission() {
        
        locationManager.requestWhenInUseAuthorization()
    }

    func startTracking() {
        locationManager.startUpdatingLocation()
    }

    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            // Скорость в метрах в секунду
            let speed = lastLocation.speed
            currentSpeed.updateValue(speed * 3.6)
            print("speed = \(speed * 3.6)")
            updateTotalDistance(from: self.lastLocation, to: lastLocation) // Вычисление дистанции между обновлениями

            if !isMoving && speed > 2 { // Устанавливаем минимальную скорость для начала движения
                isMoving = true
                startTime = Date() // Запомнить время начала движения
                print("Теперь в движении")
            } else if isMoving && speed <= 2 {
                isMoving = false
                endTime = Date() // Запомнить время окончания движения
                print("Теперь остановился")
                print(totalTripTime)
            }

            self.lastLocation = lastLocation
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.allowsBackgroundLocationUpdates = false
            startTracking()
            self.locationManager.requestAlwaysAuthorization()
        case .authorizedAlways:
            locationManager.allowsBackgroundLocationUpdates = true
            startTracking()
        default:
            stopTracking()
        }
    }

    private func updateTotalDistance(from prevLocation: CLLocation?, to newLocation: CLLocation) {
        guard let prevLocation = prevLocation else { return }

        let distance = prevLocation.distance(from: newLocation) // Расстояние между двумя точками в метрах
        totalDistance += distance

        print("Текущий пробег: \(totalDistance) метров")
    }
}

